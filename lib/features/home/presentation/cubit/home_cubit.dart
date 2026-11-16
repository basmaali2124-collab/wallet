import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/data/settings_repository.dart';
import 'package:wallet_app/core/models/account_model.dart';
import 'package:wallet_app/core/models/bill_model.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/accounts/domain/account_repository.dart';
import 'package:wallet_app/features/accounts/domain/account_usecases.dart';
import 'package:wallet_app/features/bills/domain/bill_repository.dart';
import 'package:wallet_app/features/home/domain/usecases.dart';
import 'package:wallet_app/features/home/presentation/cubit/home_state.dart';
import 'package:wallet_app/features/transactions/domain/transaction_repository.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required TransactionRepository transactions,
    required BillRepository bills,
    required AccountRepository accounts,
    required SettingsRepository settings,
    required CalculateAccountBalances calculateBalances,
    required CalculateMonthlySummary calculateSummary,
    required CalculateBudget calculateBudget,
  }) : _transactions = transactions,
       _bills = bills,
       _accounts = accounts,
       _settings = settings,
       _balances = calculateBalances,
       _summary = calculateSummary,
       _budget = calculateBudget,
       super(const HomeState()) {
    _listen();
    _settingsSub = _settings.changes.listen((_) => _recompute());
  }

  final TransactionRepository _transactions;
  final BillRepository _bills;
  final AccountRepository _accounts;
  final SettingsRepository _settings;
  final CalculateAccountBalances _balances;
  final CalculateMonthlySummary _summary;
  final CalculateBudget _budget;

  List<TransactionModel> _txs = const [];
  List<BillModel> _allBills = const [];
  List<AccountModel> _accountList = const [];
  String _selectedId = AccountIds.main;
  bool _txLoaded = false;
  bool _billsLoaded = false;
  bool _accountsLoaded = false;
  StreamSubscription<List<TransactionModel>>? _txSub;
  StreamSubscription<List<BillModel>>? _billSub;
  StreamSubscription<List<AccountModel>>? _accountSub;
  StreamSubscription<void>? _settingsSub;

  void _listen() {
    _txSub?.cancel();
    _billSub?.cancel();
    _accountSub?.cancel();
    _txLoaded = false;
    _billsLoaded = false;
    _accountsLoaded = false;
    _txSub = _transactions.watchAll().listen((v) {
      _txs = v;
      _txLoaded = true;
      _recompute();
    }, onError: _onError);
    _billSub = _bills.watchAll().listen((v) {
      _allBills = v;
      _billsLoaded = true;
      _recompute();
    }, onError: _onError);
    _accountSub = _accounts.watchAll().listen((v) {
      _accountList = v;
      _accountsLoaded = true;
      _recompute();
    }, onError: _onError);
  }

  void _onError(Object e) =>
      emit(state.copyWith(status: HomeStatus.error, error: e.toString()));

  String _currency() {
    for (final a in _accountList) {
      if (a.id == _selectedId) return a.currency;
    }
    return 'USD';
  }

  void _recompute() {
    if (!_txLoaded || !_billsLoaded || !_accountsLoaded) return;
    try {
      final now = DateTime.now();
      if (_accountList.isNotEmpty &&
          !_accountList.any((a) => a.id == _selectedId)) {
        _selectedId = _accountList.first.id;
      }

      final balances = _balances(_accountList, _txs);
      final scoped = _txs.where((t) => t.accountId == _selectedId).toList();
      final summary = _summary(scoped, now);
      final limit = _settings.monthlyBudgetCents;
      final budgetSpent = _summary(_txs, now).expenseCents;

     final nextMonthStart = DateTime(now.year, now.month + 1, 1);
      final upcoming =
          _allBills
              .where(
                (b) =>
                    b.isUpcomingAt(now) && b.dueDate.isBefore(nextMonthStart),
              )
              .toList()
            ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      final overdueCount = _allBills.where((b) => b.isOverdueAt(now)).length;

      emit(
        HomeState(
          status: HomeStatus.loaded,
          profileName: _settings.profileName,
          totalBalanceCents: balances[_selectedId] ?? 0,
          incomeCents: summary.incomeCents,
          expenseCents: summary.expenseCents,
          incomeChangePct: summary.incomeChangePct,
          expenseChangePct: summary.expenseChangePct,
          budgetLimitCents: limit,
          budgetSpentCents: budgetSpent,
          budgetPercent: _budget(budgetSpent, limit),
          hideBalance: _settings.hideBalance,
          upcomingBills: upcoming.take(3).toList(),
          overdueBillCount: overdueCount,
          accounts: _accountList,
          selectedAccountId: _selectedId,
          currency: _currency(),
        ),
      );
    } catch (e) {
      _onError(e);
    }
  }

  void selectAccount(String id) {
    _selectedId = id;
    _recompute();
  }

  Future<void> toggleHideBalance() =>
      _settings.setHideBalance(!_settings.hideBalance);

  Future<void> setBudget(int cents) => _settings.setMonthlyBudget(cents);

  Future<void> refresh() async {
    _listen();
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> close() {
    _txSub?.cancel();
    _billSub?.cancel();
    _accountSub?.cancel();
    _settingsSub?.cancel();
    return super.close();
  }
}