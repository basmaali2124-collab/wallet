import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';

List<TransactionCategory> categoriesFor(TransactionType type) => switch (type) {
  TransactionType.expense =>
    TransactionCategory.values.where((c) => c.isSpending).toList(),
  TransactionType.income => [
    TransactionCategory.salary,
    TransactionCategory.others,
  ],
  TransactionType.transfer => const [],
};