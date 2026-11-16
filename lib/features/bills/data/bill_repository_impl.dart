import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/models/bill_category.dart';
import 'package:wallet_app/core/models/bill_model.dart';
import 'package:wallet_app/features/bills/domain/bill_repository.dart';

@LazySingleton(as: BillRepository)
class BillRepositoryImpl implements BillRepository {
  BillRepositoryImpl(@Named('bills') this._box);
  final Box<Map> _box;

  Map<String, dynamic> _toMap(BillModel b) => {
    'id': b.id,
    'name': b.name,
    'amountCents': b.amountCents,
    'dueDate': b.dueDate.millisecondsSinceEpoch,
    'category': b.category.name,
    'isRecurring': b.isRecurring,
    'isPaid': b.isPaid,
    'anchorDay': b.anchorDay,
    'note': b.note,
  };

  static const _legacyIcons = {
    'wifi': BillCategory.internet,
    'bolt': BillCategory.electricity,
    'phone': BillCategory.mobile,
    'water': BillCategory.water,
  };

  static BillCategory _categoryOf(Map m) =>
      BillCategory.fromName(m['category'] as String?) ??
      _legacyIcons[m['iconKey']] ??
      BillCategory.other;

  BillModel _fromMap(Map m) => BillModel(
    id: m['id'] as String,
    name: (m['name'] as String?) ?? '',
    amountCents: (m['amountCents'] as int?) ?? 0,
    dueDate: DateTime.fromMillisecondsSinceEpoch(
      (m['dueDate'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
    ),
    category: _categoryOf(m),
    isRecurring: (m['isRecurring'] as bool?) ?? false,
    isPaid: (m['isPaid'] as bool?) ?? false,
    anchorDay: m['anchorDay'] as int?,
    note: m['note'] as String?,
  );

  List<BillModel> _all() => _box.values.map(_fromMap).toList();

  @override
  Stream<List<BillModel>> watchAll() async* {
    yield _all();
    yield* _box.watch().map((_) => _all());
  }

  @override
  Future<BillModel?> getById(String id) async {
    final raw = _box.get(id);
    return raw == null ? null : _fromMap(raw);
  }

  @override
  Future<void> put(BillModel bill) => _box.put(bill.id, _toMap(bill));

  @override
  Future<void> delete(String id) => _box.delete(id);

  @override
  Future<void> clear() => _box.clear();
}