import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_app/core/models/account_model.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/accounts/domain/account_usecases.dart';
import 'package:wallet_app/features/transactions/data/transaction_local_data_source.dart';

TransactionModel makeTx(
  TransactionType type,
  int cents, {
  String account = AccountIds.main,
  String? to,
}) {
  return TransactionModel(
    id: '$type$cents',
    type: type,
    amountCents: cents,
    category: TransactionCategory.others,
    title: 't',
    date: DateTime(2026, 11, 1),
    accountId: account,
    toAccountId: to,
  );
}

void main() {
  const accounts = [
    AccountModel(id: AccountIds.main, name: 'Main', openingBalanceCents: 1000),
    AccountModel(id: AccountIds.guest, name: 'Guest'),
  ];

  test('transfer moves money between accounts', () {
    final balances = CalculateAccountBalances()(accounts, [
      makeTx(TransactionType.income, 500),
      makeTx(TransactionType.expense, 200),
      makeTx(TransactionType.transfer, 300, to: AccountIds.guest),
    ]);

    expect(balances[AccountIds.main], 1000);
    expect(balances[AccountIds.guest], 300);
  });

  test('transfer does not change the total money', () {
    final balances = CalculateAccountBalances()(accounts, [
      makeTx(TransactionType.transfer, 700, to: AccountIds.guest),
    ]);

    final total = balances[AccountIds.main]! + balances[AccountIds.guest]!;
    expect(total, 1000);
  });

  test('unknown account id is ignored', () {
    final balances = CalculateAccountBalances()(accounts, [
      makeTx(TransactionType.expense, 100, account: 'deleted'),
    ]);

    expect(balances[AccountIds.main], 1000);
  });

  test('old record without accountId uses the main account', () {
    final oldRecord = {
      'id': 'x',
      'type': 'expense',
      'amountCents': 100,
      'category': 'others',
      'title': 't',
      'note': null,
      'date': DateTime(2026, 11, 1).millisecondsSinceEpoch,
    };

    final tx = transactionFromMap(oldRecord);

    expect(tx.accountId, AccountIds.main);
    expect(tx.toAccountId, isNull);
  });

  test('toMap then fromMap keeps the accounts', () {
    final tx = makeTx(TransactionType.transfer, 300, to: AccountIds.guest);

    final back = transactionFromMap(tx.toMap());

    expect(back.accountId, AccountIds.main);
    expect(back.toAccountId, AccountIds.guest);
  });
}
