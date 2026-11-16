import 'package:wallet_app/core/models/transaction_model.dart';

class SearchState {
  final String query;
  final List<TransactionModel> results;
  final List<String> recent;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.recent = const [],
  });

  SearchState copyWith({
    String? query,
    List<TransactionModel>? results,
    List<String>? recent,
  }) => SearchState(
    query: query ?? this.query,
    results: results ?? this.results,
    recent: recent ?? this.recent,
  );
}