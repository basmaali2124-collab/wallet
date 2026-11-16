import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/data/settings_repository.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/transactions/domain/transaction_repository.dart';
import 'package:wallet_app/features/transactions/domain/transaction_search.dart';
import 'package:wallet_app/features/transactions/presentation/search/search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(TransactionRepository transactions, SettingsRepository settings)
    : _settings = settings,
      super(SearchState(recent: settings.recentSearches)) {
    _sub = transactions.watchAll().listen((v) {
      _all = v;
      _run();
    });
  }

  static const debounce = Duration(milliseconds: 300);
  static const maxRecent = 8;

  final SettingsRepository _settings;
  StreamSubscription<List<TransactionModel>>? _sub;
  Timer? _timer;
  List<TransactionModel> _all = const [];
  String _pending = '';

  void onChanged(String value) {
    _timer?.cancel();
    _pending = value;
    if (value.trim().isEmpty) {
      emit(state.copyWith(query: '', results: const []));
      return;
    }
    _timer = Timer(debounce, _run);
  }

  void submit(String value) {
    _timer?.cancel();
    _pending = value;
    _run();
    saveRecent(value);
  }

  void _run() {
    final q = _pending.trim();
    emit(state.copyWith(query: q, results: searchTransactions(_all, q)));
  }

  Future<void> saveRecent(String value) async {
    final q = value.trim();
    if (q.isEmpty) return;
    final list = [
      q,
      ...state.recent.where((r) => r.toLowerCase() != q.toLowerCase()),
    ].take(maxRecent).toList();
    await _settings.setRecentSearches(list);
    if (isClosed) return;
    emit(state.copyWith(recent: list));
  }

  Future<void> removeRecent(String value) async {
    final list = state.recent.where((r) => r != value).toList();
    await _settings.setRecentSearches(list);
    if (isClosed) return;
    emit(state.copyWith(recent: list));
  }

  Future<void> clearRecent() async {
    await _settings.setRecentSearches(const []);
    if (isClosed) return;
    emit(state.copyWith(recent: const []));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _sub?.cancel();
    return super.close();
  }
}