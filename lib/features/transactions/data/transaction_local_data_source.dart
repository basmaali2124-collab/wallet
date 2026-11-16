import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/core/models/account_model.dart';

extension TransactionMapper on TransactionModel {
  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type.name,
    'amountCents': amountCents,
    'category': category.name,
    'title': title,
    'note': note,
    'date': date.millisecondsSinceEpoch,
    'accountId': accountId,
    'toAccountId': toAccountId,
    'createdAt': createdAt?.millisecondsSinceEpoch,
  };
}

TransactionModel transactionFromMap(Map m) => TransactionModel(
  id: m['id'] as String,
  type: TransactionType.values.byName(m['type'] as String),
  amountCents: m['amountCents'] as int,
  category: TransactionCategory.values.byName(m['category'] as String),
  title: m['title'] as String,
  note: m['note'] as String?,
  date: DateTime.fromMillisecondsSinceEpoch(m['date'] as int),
  accountId: (m['accountId'] as String?) ?? AccountIds.main,
  toAccountId: m['toAccountId'] as String?,
  createdAt: m['createdAt'] == null
    ? null
    : DateTime.fromMillisecondsSinceEpoch(m['createdAt'] as int),

);

@lazySingleton
class TransactionLocalDataSource {
  TransactionLocalDataSource(@Named('transactions') this._box);
  final Box<Map> _box;

  List<TransactionModel> getAll() =>
      _box.values.map(transactionFromMap).toList();
  Future<void> put(TransactionModel t) => _box.put(t.id, t.toMap());
  Future<void> delete(String id) => _box.delete(id);
  Future<void> clear() => _box.clear();
  Stream<BoxEvent> watch() => _box.watch();
}
