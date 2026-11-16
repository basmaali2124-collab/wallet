import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/models/account_model.dart';
import 'package:wallet_app/core/models/transaction_model.dart';

@lazySingleton
class CalculateAccountBalances {
   Map<String, int> call(
    List<AccountModel> accounts,
    List<TransactionModel> transactions,
  ) {
    final balances = {for (final a in accounts) a.id: a.openingBalanceCents};

    void add(String? id, int delta) {
      if (id != null && balances.containsKey(id)) {
        balances[id] = balances[id]! + delta;
      }
    }

    for (final t in transactions) {
      switch (t.type) {
        case TransactionType.income:
          add(t.accountId, t.amountCents);
        case TransactionType.expense:
          add(t.accountId, -t.amountCents);
        case TransactionType.transfer:
          add(t.accountId, -t.amountCents);
          add(t.toAccountId, t.amountCents);
      }
    }
    return balances;
  }
}