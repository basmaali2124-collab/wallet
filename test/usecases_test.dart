import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_app/core/models/account_model.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/accounts/domain/account_usecases.dart';
import 'package:wallet_app/features/home/domain/usecases.dart';

TransactionModel makeTx(TransactionType type, int cents, DateTime date) {
  return TransactionModel(
    id: '${date.microsecondsSinceEpoch}$cents',
    type: type,
    amountCents: cents,
    category: TransactionCategory.others,
    title: 't',
    date: date,
  );
}

void main() {
  final now = DateTime(2026, 11, 12);
  final lastMonth = DateTime(2026, 10, 12);

  test('balance = opening + income - expense', () {
    const accounts = [
      AccountModel(id: AccountIds.main, name: 'Main', openingBalanceCents: 500),
    ];
    final all = [
      makeTx(TransactionType.income, 1000, now),
      makeTx(TransactionType.expense, 300, now),
    ];

    final balances = CalculateAccountBalances()(accounts, all);
    expect(balances[AccountIds.main], 1200);
  });

  test('monthly summary sums the month and computes change', () {
    final all = [
      makeTx(TransactionType.income, 2000, now),
      makeTx(TransactionType.income, 1000, lastMonth),
      makeTx(TransactionType.expense, 500, now),
    ];

    final summary = CalculateMonthlySummary()(all, now);

    expect(summary.incomeCents, 2000);
    expect(summary.expenseCents, 500);
    expect(summary.incomeChangePct, 100);
    expect(summary.expenseChangePct, isNull);
  });

  test('monthly summary works in January (previous month is December)', () {
    final jan = DateTime(2026, 1, 5);
    final dec = DateTime(2025, 12, 5);
    final all = [
      makeTx(TransactionType.expense, 200, jan),
      makeTx(TransactionType.expense, 100, dec),
    ];

    final summary = CalculateMonthlySummary()(all, jan);

    expect(summary.expenseChangePct, 100);
  });

  test('budget percent', () {
    expect(CalculateBudget()(50, 200), 25);
  });

  test('budget percent is 0 when limit is 0', () {
    expect(CalculateBudget()(50, 0), 0);
  });
}
