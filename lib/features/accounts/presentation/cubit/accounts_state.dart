import 'package:wallet_app/core/models/account_model.dart';

enum AccountsStatus { loading, loaded, error }

class AccountsState {
  final AccountsStatus status;
  final List<AccountModel> accounts;
  final Map<String, int> balances;
  final String? error;

  const AccountsState({
    this.status = AccountsStatus.loading,
    this.accounts = const [],
    this.balances = const {},
    this.error,
  });

  int balanceOf(String id) => balances[id] ?? 0;

  String nameOf(String id) {
    for (final a in accounts) {
      if (a.id == id) return a.name;
    }
    return 'Unknown account';
  }
}