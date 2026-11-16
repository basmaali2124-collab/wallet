import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/transactions/data/transaction_local_data_source.dart';
import 'package:wallet_app/features/transactions/domain/transaction_repository.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._ds);
  final TransactionLocalDataSource _ds;

  @override
  Stream<List<TransactionModel>> watchAll() async* {
    yield _ds.getAll();
    yield* _ds.watch().map((_) => _ds.getAll());
  }

  @override
  Future<void> add(TransactionModel tx) => _ds.put(tx);
  @override
  Future<void> delete(String id) => _ds.delete(id);
  @override
  Future<void> clear() => _ds.clear();
}
