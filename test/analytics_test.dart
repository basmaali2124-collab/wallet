import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/analytics/domain/analytics_usecases.dart';

TransactionModel makeTx(
  String id,
  TransactionType type,
  int cents,
  DateTime date, [
  TransactionCategory category = TransactionCategory.others,
]) {
  return TransactionModel(
    id: id,
    type: type,
    amountCents: cents,
    category: category,
    title: id,
    date: date,
  );
}

void main() {
  final build = BuildAnalytics();
  final nov = DateTime(2026, 11);
  final now = DateTime(2026, 11, 10);

  final all = [
    makeTx(
      'a',
      TransactionType.expense,
      600,
      DateTime(2026, 11, 2),
      TransactionCategory.shopping,
    ),
    makeTx(
      'b',
      TransactionType.expense,
      400,
      DateTime(2026, 11, 3),
      TransactionCategory.bills,
    ),
    makeTx(
      'c',
      TransactionType.income,
      5000,
      DateTime(2026, 11, 1),
      TransactionCategory.salary,
    ),
    makeTx('d', TransactionType.expense, 300, DateTime(2026, 10, 20)),
    makeTx('e', TransactionType.transfer, 999, DateTime(2026, 11, 4)),
  ];

  test('transfers are ignored in totals', () {
    final data = build(all, nov, now: now);

    expect(data.incomeCents, 5000);
    expect(data.expenseCents, 1000);
    expect(data.netCents, 4000);
  });

  test('month is split into weekly buckets', () {
    final data = build(all, nov, now: now);

    expect(data.buckets.length, 5);
    expect(data.buckets.first.incomeCents, 5000);
    expect(data.buckets.first.expenseCents, 1000);
  });

  test('slices are sorted from biggest to smallest', () {
    final data = build(all, nov, now: now);

    expect(data.slices.length, 2);
    expect(data.slices[0].category, TransactionCategory.shopping);
    expect(data.slices[1].category, TransactionCategory.bills);
    expect(data.slices[0].percent, 60);
  });

  test('top expense is the biggest one', () {
    final data = build(all, nov, now: now);

    expect(data.topExpense!.id, 'a');
  });

  test('average daily for the current month uses days passed so far', () {
    final data = build(all, nov, now: now);

    expect(data.avgDailyCents, 100);
  });

  test('average daily for a past month uses the whole month', () {
    final data = build(all, DateTime(2026, 10), now: now);
    expect(data.avgDailyCents, 10);
  });

  test('January is compared with December of the previous year', () {
    final list = [
      makeTx(
        'dec',
        TransactionType.expense,
        200,
        DateTime(2025, 12, 10),
        TransactionCategory.shopping,
      ),
      makeTx(
        'jan',
        TransactionType.expense,
        100,
        DateTime(2026, 1, 10),
        TransactionCategory.shopping,
      ),
    ];

    final data = build(list, DateTime(2026, 1), now: now);

    expect(data.insight!.category, TransactionCategory.shopping);
    expect(data.insight!.changePct, -50);
  });

  test('empty data gives zero and no slices', () {
    final data = build(const [], nov, now: now);

    expect(data.expenseCents, 0);
    expect(data.slices, isEmpty);
    expect(data.topExpense, isNull);
  });
}
