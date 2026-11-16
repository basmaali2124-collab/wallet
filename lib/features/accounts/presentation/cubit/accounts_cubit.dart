import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/models/account_model.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/accounts/domain/account_repository.dart';
import 'package:wallet_app/features/accounts/domain/account_usecases.dart';
import 'package:wallet_app/features/accounts/presentation/cubit/accounts_state.dart';
import 'package:wallet_app/features/transactions/domain/transaction_repository.dart';

@injectable
class AccountsCubit extends Cubit<AccountsState> {
  AccountsCubit(this._accounts, this._transactions, this._balances)
    : super(const AccountsState()) {
    _listen();
  }

  final AccountRepository _accounts;
  final TransactionRepository _transactions;
  final CalculateAccountBalances _balances;

  List<AccountModel> _accountList = const [];
  List<TransactionModel> _txs = const [];
  bool _accountsLoaded = false;
  bool _txLoaded = false;
  StreamSubscription<List<AccountModel>>? _accSub;
  StreamSubscription<List<TransactionModel>>? _txSub;

  void _listen() {
    _accSub = _accounts.watchAll().listen((v) {
      _accountList = v;
      _accountsLoaded = true;
      _recompute();
    }, onError: _onError);
    _txSub = _transactions.watchAll().listen((v) {
      _txs = v;
      _txLoaded = true;
      _recompute();
    }, onError: _onError);
  }

  void _onError(Object e) => emit(
    AccountsState(
      status: AccountsStatus.error,
      accounts: state.accounts,
      balances: state.balances,
      error: e.toString(),
    ),
  );

  void _recompute() {
    if (!_accountsLoaded || !_txLoaded) return;
    emit(
      AccountsState(
        status: AccountsStatus.loaded,
        accounts: _accountList,
        balances: _balances(_accountList, _txs),
      ),
    );
  }

  @override
  Future<void> close() {
    _accSub?.cancel();
    _txSub?.cancel();
    return super.close();
  }
}