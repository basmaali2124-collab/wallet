import 'package:wallet_app/core/models/bill_model.dart';

abstract class BillRepository {
  Stream<List<BillModel>> watchAll();

  Future<BillModel?> getById(String id);
  Future<void> put(BillModel bill);
  Future<void> delete(String id);
  Future<void> clear();
}