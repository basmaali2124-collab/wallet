import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/transactions/domain/transaction_search.dart';

void main() {
  final starbucks = TransactionModel(
    id: '1',
    type: TransactionType.expense,
    amountCents: 1600,
    category: TransactionCategory.foodAndDrink,
    title: 'Starbucks',
    date: DateTime(2026, 11, 5),
  );

  final zara = TransactionModel(
    id: '2',
    type: TransactionType.expense,
    amountCents: 120000,
    category: TransactionCategory.shopping,
    title: 'Zara',
    note: 'Winter jacket',
    date: DateTime(2026, 10, 18),
  );

  final salary = TransactionModel(
    id: '3',
    type: TransactionType.income,
    amountCents: 100000,
    category: TransactionCategory.salary,
    title: 'Salary',
    date: DateTime(2026, 11, 1),
  );

  final all = [starbucks, zara, salary];

  List<String> search(String query) {
    return searchTransactions(all, query).map((t) => t.id).toList();
  }

  test('empty query returns nothing', () {
    expect(search(''), isEmpty);
    expect(search('   '), isEmpty);
  });

  test('matches title ignoring case', () {
    expect(search('starb'), ['1']);
  });

  test('matches note', () {
    expect(search('jacket'), ['2']);
  });

  test('matches category', () {
    expect(search('food'), ['1']);
  });

  test('matches type', () {
    expect(search('income'), ['3']);
  });

  test('matches amount', () {
    expect(search('16'), ['1']);
    expect(search('1,200'), ['2']);
  });

  test('newest comes first', () {
    expect(search('e'), ['1', '3', '2']);
  });

  test('no match returns empty list', () {
    expect(search('zzzz'), isEmpty);
  });
}
