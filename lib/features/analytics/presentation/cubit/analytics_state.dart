import 'package:intl/intl.dart';
import 'package:wallet_app/features/analytics/domain/analytics_usecases.dart';

enum AnalyticsStatus { loading, loaded, error }

DateTime analyticsPeriodStart(AnalyticsPeriod period, DateTime a) =>
    switch (period) {
      AnalyticsPeriod.week => DateTime(a.year, a.month, a.day - (a.weekday - 1)),
      AnalyticsPeriod.month => DateTime(a.year, a.month),
      AnalyticsPeriod.year => DateTime(a.year),
    };

DateTime analyticsShift(AnalyticsPeriod period, DateTime a, int delta) =>
    switch (period) {
      AnalyticsPeriod.week => DateTime(a.year, a.month, a.day + 7 * delta),
      AnalyticsPeriod.month => DateTime(a.year, a.month + delta),
      AnalyticsPeriod.year => DateTime(a.year + delta),
    };

class AnalyticsState {
  final AnalyticsStatus status;
  final AnalyticsPeriod period;
  final DateTime anchor;
  final AnalyticsData data;
  final String? error;

  const AnalyticsState({
    this.status = AnalyticsStatus.loading,
    this.period = AnalyticsPeriod.month,
    required this.anchor,
    this.data = AnalyticsData.empty,
    this.error,
  });

  DateTime get month => DateTime(anchor.year, anchor.month);

  bool get canGoNext {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final next = analyticsShift(period, anchor, 1);
    return !analyticsPeriodStart(period, next).isAfter(today);
  }

  String get label {
    switch (period) {
      case AnalyticsPeriod.week:
        final start = analyticsPeriodStart(period, anchor);
        final end = DateTime(start.year, start.month, start.day + 6);
        return '${DateFormat('d MMM').format(start)} – '
            '${DateFormat('d MMM yyyy').format(end)}';
      case AnalyticsPeriod.month:
        return DateFormat('MMMM yyyy').format(anchor);
      case AnalyticsPeriod.year:
        return DateFormat('yyyy').format(anchor);
    }
  }

  String get periodWord => switch (period) {
    AnalyticsPeriod.week => 'week',
    AnalyticsPeriod.month => 'month',
    AnalyticsPeriod.year => 'year',
  };

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    AnalyticsPeriod? period,
    DateTime? anchor,
    AnalyticsData? data,
    String? error,
    bool clearError = false,
  }) => AnalyticsState(
    status: status ?? this.status,
    period: period ?? this.period,
    anchor: anchor ?? this.anchor,
    data: data ?? this.data,
    error: clearError ? null : (error ?? this.error),
  );
}