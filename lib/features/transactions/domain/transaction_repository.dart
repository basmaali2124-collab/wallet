import 'package:wallet_app/core/models/transaction_model.dart';

abstract class TransactionRepository {
  Stream<List<TransactionModel>> watchAll();
  Future<void> add(TransactionModel tx);
  Future<void> delete(String id);
  Future<void> clear();
}
