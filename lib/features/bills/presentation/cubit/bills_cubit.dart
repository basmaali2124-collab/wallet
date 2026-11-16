import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/models/account_model.dart';
import 'package:wallet_app/core/models/bill_model.dart';
import 'package:wallet_app/features/bills/domain/bill_repository.dart';
import 'package:wallet_app/features/bills/domain/bill_usecases.dart';
import 'package:wallet_app/features/bills/presentation/cubit/bills_state.dart';

@injectable
class BillsCubit extends Cubit<BillsState> {
  BillsCubit(this._repo, this._payBill) : super(const BillsState()) {
    _subscribe();
  }

  final BillRepository _repo;
  final PayBill _payBill;
  StreamSubscription<List<BillModel>>? _sub;

  void _subscribe() {
    _sub?.cancel();
    _sub = _repo.watchAll().listen(
      (all) => emit(
        state.copyWith(status: BillsStatus.loaded, all: all, clearError: true),
      ),
      onError: (Object e) => emit(
        state.copyWith(status: BillsStatus.error, error: e.toString()),
      ),
    );
  }

  void retry() {
    emit(state.copyWith(status: BillsStatus.loading));
    _subscribe();
  }

  void setFilterIndex(int i) =>
      emit(state.copyWith(filter: BillFilter.values[i]));

  Future<void> add(BillModel bill) => _repo.put(bill);
  Future<void> update(BillModel bill) => _repo.put(bill);

  final _paying = <String>{};

  Future<PayBillResult?> pay(
    BillModel bill, {
    String accountId = AccountIds.main,
  }) async {
    if (!_paying.add(bill.id)) return null;
    try {
      return await _payBill(bill, accountId: accountId);
    } on StateError {
      return null;
    } finally {
      _paying.remove(bill.id);
    }
  }

  Future<void> undoPay(PayBillResult r) => _payBill.undo(r);

  Future<void> delete(BillModel bill) async {
    emit(state.copyWith(all: state.all.where((b) => b.id != bill.id).toList()));
    await _repo.delete(bill.id);
  }

  Future<void> undoDelete(BillModel bill) => _repo.put(bill);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}