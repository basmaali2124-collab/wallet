import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/core/utils/money.dart';

@lazySingleton
class BuildTransactionsCsv {
  String call(List<TransactionModel> transactions) {
    final sorted = [...transactions]..sort((a, b) => b.date.compareTo(a.date));
    final rows = <List<String>>[
      [
        'id', 'date', 'type', 'title', 'category',
        'amount', 'account', 'to_account', 'note',
      ],
      for (final t in sorted)
        [
          t.id,
          t.date.toIso8601String(),
          t.type.name,
          t.title,
          t.category.label,
          Money.plain(t.amountCents),
          t.accountId,
          t.toAccountId ?? '',
          t.note ?? '',
        ],
    ];
    return rows.map((r) => r.map(_escape).join(',')).join('\n');
  }

  String _escape(String v) =>
      (v.contains(',') || v.contains('"') || v.contains('\n'))
      ? '"${v.replaceAll('"', '""')}"'
      : v;
}