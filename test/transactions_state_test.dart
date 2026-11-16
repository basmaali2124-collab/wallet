import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/transactions/presentation/cubit/transactions_state.dart';

TransactionModel makeTx(
  String id,
  TransactionType type,
  TransactionCategory category,
  DateTime date,
  int cents,
) {
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
  final all = [
    makeTx(
      'a',
      TransactionType.expense,
      TransactionCategory.shopping,
      DateTime(2026, 11, 2),
      300,
    ),
    makeTx(
      'b',
      TransactionType.expense,
      TransactionCategory.shopping,
      DateTime(2026, 11, 9),
      200,
    ),
    makeTx(
      'c',
      TransactionType.income,
      TransactionCategory.salary,
      DateTime(2026, 11, 5),
      100,
    ),
    makeTx(
      'd',
      TransactionType.expense,
      TransactionCategory.others,
      DateTime(2026, 10, 30),
      100,
    ),
  ];

  final state = TransactionsState(
    status: TransactionsStatus.loaded,
    all: all,
    date: DateTime(2026, 11, 15),
  );

  test('visible shows only this month, newest first', () {
    final ids = state.visible.map((t) => t.id).toList();
    expect(ids, ['b', 'c', 'a']);
  });

  test('filter by type', () {
    final filtered = state.copyWith(filter: TransactionType.expense);
    final ids = filtered.visible.map((t) => t.id).toList();
    expect(ids, ['b', 'a']);
  });

  test('filter by category', () {
    final filtered = state.copyWith(category: TransactionCategory.shopping);
    expect(filtered.visible.length, 2);
  });

  test('spendByCategory counts only this month expenses', () {
    expect(state.spendByCategory, {TransactionCategory.shopping: 500});
  });
}
