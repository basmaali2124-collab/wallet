import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/analytics/domain/analytics_usecases.dart';
import 'package:wallet_app/features/analytics/presentation/cubit/analytics_state.dart';
import 'package:wallet_app/features/transactions/domain/transaction_repository.dart';

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

@injectable
class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit(this._repo, this._build)
    : super(AnalyticsState(anchor: _today())) {
    _subscribe();
  }

  final TransactionRepository _repo;
  final BuildAnalytics _build;
  List<TransactionModel> _all = const [];
  StreamSubscription<List<TransactionModel>>? _sub;

  AnalyticsData _data(AnalyticsPeriod period, DateTime anchor) => _build(
    _all,
    DateTime(anchor.year, anchor.month),
    period: period,
    anchor: anchor,
  );

  void _subscribe() {
    _sub?.cancel();
    _sub = _repo.watchAll().listen((all) {
      _all = all;
      emit(
        state.copyWith(
          status: AnalyticsStatus.loaded,
          data: _data(state.period, state.anchor),
          clearError: true,
        ),
      );
    }, onError: (Object e) {
      emit(state.copyWith(status: AnalyticsStatus.error, error: e.toString()));
    });
  }

  void retry() {
    emit(state.copyWith(status: AnalyticsStatus.loading));
    _subscribe();
  }

  void setPeriod(AnalyticsPeriod period) {
    if (period == state.period) return;
    emit(state.copyWith(period: period, data: _data(period, state.anchor)));
  }

  void shift(int delta) {
    final target = analyticsShift(state.period, state.anchor, delta);
    if (analyticsPeriodStart(state.period, target).isAfter(_today())) return;
    emit(state.copyWith(anchor: target, data: _data(state.period, target)));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}