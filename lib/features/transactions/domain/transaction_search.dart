import 'package:wallet_app/core/models/transaction_model.dart';

List<TransactionModel> searchTransactions(
  List<TransactionModel> all,
  String query,
) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return const [];
  final amountQuery = q.replaceAll(',', '').replaceAll(r'$', '');

  bool matches(TransactionModel t) {
    final amountText = (t.amountCents / 100).toStringAsFixed(2);
    return t.title.toLowerCase().contains(q) ||
        (t.note?.toLowerCase().contains(q) ?? false) ||
        t.category.label.toLowerCase().contains(q) ||
        t.type.label.toLowerCase().contains(q) ||
        (amountQuery.isNotEmpty && amountText.contains(amountQuery));
  }

  return all.where(matches).toList()
    ..sort((a, b) => b.date.compareTo(a.date));
}