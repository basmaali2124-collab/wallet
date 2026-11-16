import 'package:wallet_app/core/models/account_model.dart';
import 'package:wallet_app/core/models/transaction_category.dart';

enum TransactionType {
  income('Income'),
  expense('Expense'),
  transfer('Transfer');

  const TransactionType(this.label);
  final String label;
}

class TransactionModel {
  final String id;
  final TransactionType type;

  final int amountCents;
  final TransactionCategory category;
  final String title;
  final String? note;
  final DateTime date;
  final DateTime? createdAt;
  final String accountId;
  final String? toAccountId;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.amountCents,
    required this.category,
    required this.title,
    required this.date,
    this.note,
    this.accountId = AccountIds.main,
    this.toAccountId, this.createdAt,
  });

  TransactionModel copyWith({
    int? amountCents,
    TransactionCategory? category,
    String? title,
    DateTime? date,
    String? note,
    bool clearNote = false,
    String? accountId,
  }) => TransactionModel(
    id: id,
    type: type,
    amountCents: amountCents ?? this.amountCents,
    category: category ?? this.category,
    title: title ?? this.title,
    date: date ?? this.date,
    note: clearNote ? null : (note ?? this.note),
    accountId: accountId ?? this.accountId,
    toAccountId: toAccountId,
    createdAt: createdAt
  );
}