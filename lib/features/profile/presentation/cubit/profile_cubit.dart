import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/data/settings_repository.dart';
import 'package:wallet_app/core/models/account_model.dart';
import 'package:wallet_app/features/accounts/domain/account_repository.dart';
import 'package:wallet_app/features/bills/domain/bill_repository.dart';
import 'package:wallet_app/features/profile/domain/export_csv.dart';
import 'package:wallet_app/features/profile/presentation/cubit/profile_state.dart';
import 'package:wallet_app/features/transactions/domain/transaction_repository.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    SettingsRepository settings,
    TransactionRepository transactions,
    BillRepository bills,
    AccountRepository accounts,
    BuildTransactionsCsv buildCsv,
  ) : _settings = settings,
      _transactions = transactions,
      _bills = bills,
      _accounts = accounts,
      _buildCsv = buildCsv,
      super(ProfileState.from(settings, const [])) {
    _settingsSub = _settings.changes.listen((_) => _refresh());
    _accountsSub = _accounts.watchAll().listen((list) {
      _accountList = list;
      _refresh();
    });
  }

  final SettingsRepository _settings;
  final TransactionRepository _transactions;
  final BillRepository _bills;
  final AccountRepository _accounts;
  final BuildTransactionsCsv _buildCsv;

  List<AccountModel> _accountList = const [];
  StreamSubscription<void>? _settingsSub;
  StreamSubscription<List<AccountModel>>? _accountsSub;

  void _refresh() {
    if (!isClosed) emit(ProfileState.from(_settings, _accountList));
  }

  Future<void> setBudget(int cents) => _settings.setMonthlyBudget(cents);

  Future<void> setOpeningBalance(int cents) =>
      _accounts.setOpeningBalance(AccountIds.main, cents);

  Future<void> updateProfile(String name, String email) =>
      _settings.setProfile(name.trim(), email.trim());

  Future<({String csv, int count})> exportCsv() async {
    final txs = await _transactions.watchAll().first;
    return (csv: _buildCsv(txs), count: txs.length);
  }

  Future<void> resetAll() async {
    await _transactions.clear();
    await _bills.clear();
    await _accounts.resetOpeningBalances();
    await _settings.resetPreferences();
  }

  @override
  Future<void> close() {
    _settingsSub?.cancel();
    _accountsSub?.cancel();
    return super.close();
  }
}