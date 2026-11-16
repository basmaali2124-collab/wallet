import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';

part 'transactions_state.freezed.dart';

enum TransactionsStatus { loading, loaded, error }

@freezed
abstract class TransactionsState with _$TransactionsState {
  const TransactionsState._();

  const factory TransactionsState({
    @Default(TransactionsStatus.loading) TransactionsStatus status,
    @Default(<TransactionModel>[]) List<TransactionModel> all,
    required DateTime date,
    TransactionType? filter,
    TransactionCategory? category,
    String? error,
  }) = _TransactionsState;

  int get filterIndex => switch (filter) {
    null => 0,
    TransactionType.income => 1,
    TransactionType.expense => 2,
    TransactionType.transfer => 3,
  };

  List<TransactionModel> get monthItems => all
      .where((t) => t.date.year == date.year && t.date.month == date.month)
      .toList();

  List<TransactionModel> get visible =>
      monthItems
          .where((t) => filter == null || t.type == filter)
          .where((t) => category == null || t.category == category)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  Map<TransactionCategory, int> get spendByCategory {
    final result = <TransactionCategory, int>{};
    for (final t in monthItems) {
      if (t.type != TransactionType.expense) continue;
      result.update(
        t.category,
        (v) => v + t.amountCents,
        ifAbsent: () => t.amountCents,
      );
    }
    return result;
  }

  bool get showSummary =>
      (filter == null || filter == TransactionType.expense) &&
      spendByCategory.isNotEmpty;
}