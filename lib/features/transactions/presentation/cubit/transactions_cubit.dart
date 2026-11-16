import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/transactions/domain/transaction_repository.dart';
import 'package:wallet_app/features/transactions/presentation/cubit/transactions_state.dart';

@injectable
class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit(this._repo)
    : super(TransactionsState(date: DateTime.now())) {
    _subscribe();
  }

  final TransactionRepository _repo;
  StreamSubscription<List<TransactionModel>>? _sub;

  void _subscribe() {
    _sub?.cancel();
    _sub = _repo.watchAll().listen(
      (all) => emit(
        state.copyWith(
          status: TransactionsStatus.loaded,
          all: all,
          error: null,
        ),
      ),
      onError: (Object e) => emit(
        state.copyWith(status: TransactionsStatus.error, error: e.toString()),
      ),
    );
  }

  void retry() {
    emit(state.copyWith(status: TransactionsStatus.loading));
    _subscribe();
  }

  void setFilterIndex(int i) {
    final type = const [
      null,
      TransactionType.income,
      TransactionType.expense,
      TransactionType.transfer,
    ][i];
    emit(state.copyWith(filter: type, category: null));
  }

  void toggleCategory(TransactionCategory c) => emit(
    state.category == c
        ? state.copyWith(category: null)
        : state.copyWith(category: c),
  );

  void setDate(DateTime d) => emit(state.copyWith(date: d, category: null));

  void shiftMonth(int delta) {
    final d = state.date;
    final target = DateTime(d.year, d.month + delta, 1);
    final lastDay = DateTime(target.year, target.month + 1, 0).day;
    setDate(
      DateTime(target.year, target.month, d.day > lastDay ? lastDay : d.day),
    );
  }

  Future<void> add(TransactionModel tx) => _repo.add(tx);
  Future<void> update(TransactionModel tx) => _repo.add(tx);
  Future<void> delete(TransactionModel tx) async {
    emit(state.copyWith(all: state.all.where((t) => t.id != tx.id).toList()));
    await _repo.delete(tx.id);
  }

  Future<void> undoDelete(TransactionModel tx) => _repo.add(tx);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}