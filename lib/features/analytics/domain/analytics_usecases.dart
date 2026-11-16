import 'package:flutter/material.dart' show DateUtils;
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';

enum AnalyticsPeriod { week, month, year }

class PeriodBucket {
  final String label;
  final int incomeCents;
  final int expenseCents;
  const PeriodBucket(this.label, this.incomeCents, this.expenseCents);
}

class CategorySlice {
  final TransactionCategory category;
  final int cents;
  final double percent;
  const CategorySlice(this.category, this.cents, this.percent);
}

class CategoryInsight {
  final TransactionCategory category;
  final int changePct;
  final AnalyticsPeriod period;
  const CategoryInsight(this.category, this.changePct, this.period);
}

class AnalyticsData {
  final List<PeriodBucket> buckets;
  final List<CategorySlice> slices;
  final int incomeCents;
  final int expenseCents;
  final int avgDailyCents;
  final TransactionModel? topExpense;
  final CategoryInsight? insight;
  final AnalyticsPeriod period;

  const AnalyticsData({
    required this.slices,
    required this.incomeCents,
    required this.expenseCents,
    required this.avgDailyCents,
    required this.topExpense,
    this.buckets = const [],
    this.insight,
    this.period = AnalyticsPeriod.month,
  });

  static const empty = AnalyticsData(
    slices: [],
    incomeCents: 0,
    expenseCents: 0,
    avgDailyCents: 0,
    topExpense: null,
  );

  int get netCents => incomeCents - expenseCents;
}

class _Range {
  final DateTime start;
  final DateTime end;
  const _Range(this.start, this.end);

  bool contains(DateTime d) => !d.isBefore(start) && d.isBefore(end);

  int get totalDays => (end.difference(start).inHours / 24).round();
}

@lazySingleton
class BuildAnalytics {
  AnalyticsData call(
    List<TransactionModel> all,
    DateTime month, {
    int months = 6,
    DateTime? now,
    DateTime? anchor,
    AnalyticsPeriod period = AnalyticsPeriod.month,
  }) {
    final today = now ?? DateTime.now();
    final isCurrentMonth =
        month.year == today.year && month.month == today.month;

    final resolved =
        anchor ??
        switch (period) {
          AnalyticsPeriod.week =>
            isCurrentMonth ? today : DateTime(month.year, month.month + 1, 0),
          AnalyticsPeriod.month => DateTime(month.year, month.month),
          AnalyticsPeriod.year => DateTime(month.year),
        };

    final range = _range(period, resolved);
    final prevRange = _range(period, _previousAnchor(period, resolved));

    final expenses = all
        .where(
          (t) => t.type == TransactionType.expense && range.contains(t.date),
        )
        .toList();
    final incomeCents = all
        .where(
          (t) => t.type == TransactionType.income && range.contains(t.date),
        )
        .fold(0, (s, t) => s + t.amountCents);
    final expenseCents = expenses.fold(0, (s, t) => s + t.amountCents);

    final byCategory = <TransactionCategory, int>{};
    for (final t in expenses) {
      byCategory.update(
        t.category,
        (v) => v + t.amountCents,
        ifAbsent: () => t.amountCents,
      );
    }
    final slices =
        byCategory.entries
            .map(
              (e) => CategorySlice(
                e.key,
                e.value,
                expenseCents == 0 ? 0 : e.value * 100 / expenseCents,
              ),
            )
            .toList()
          ..sort((a, b) => b.cents.compareTo(a.cents));

    TransactionModel? top;
    for (final t in expenses) {
      if (top == null || t.amountCents > top.amountCents) top = t;
    }

    final days = range.contains(today)
        ? (DateUtils.dateOnly(today).difference(range.start).inHours / 24)
                  .round() +
              1
        : range.totalDays;

    return AnalyticsData(
      buckets: _buckets(all, period, resolved),
      slices: slices,
      incomeCents: incomeCents,
      expenseCents: expenseCents,
      avgDailyCents: days <= 0 ? 0 : (expenseCents / days).round(),
      topExpense: top,
      insight: _insight(all, range, prevRange, period),
      period: period,
    );
  }

  _Range _range(AnalyticsPeriod period, DateTime a) => switch (period) {
    AnalyticsPeriod.week => () {
      final monday = DateTime(a.year, a.month, a.day - (a.weekday - 1));
      return _Range(
        monday,
        DateTime(monday.year, monday.month, monday.day + 7),
      );
    }(),
    AnalyticsPeriod.month => _Range(
      DateTime(a.year, a.month),
      DateTime(a.year, a.month + 1),
    ),
    AnalyticsPeriod.year => _Range(DateTime(a.year), DateTime(a.year + 1)),
  };

  DateTime _previousAnchor(AnalyticsPeriod period, DateTime a) =>
      switch (period) {
        AnalyticsPeriod.week => DateTime(a.year, a.month, a.day - 7),
        AnalyticsPeriod.month => DateTime(a.year, a.month - 1),
        AnalyticsPeriod.year => DateTime(a.year - 1),
      };

  List<PeriodBucket> _buckets(
    List<TransactionModel> all,
    AnalyticsPeriod period,
    DateTime anchor,
  ) {
    final tx = all.where((t) => t.type != TransactionType.transfer).toList();

    PeriodBucket bucket(String label, bool Function(TransactionModel) test) {
      var income = 0;
      var expense = 0;
      for (final t in tx.where(test)) {
        if (t.type == TransactionType.income) {
          income += t.amountCents;
        } else {
          expense += t.amountCents;
        }
      }
      return PeriodBucket(label, income, expense);
    }

    switch (period) {
      case AnalyticsPeriod.week:
        final monday = _range(period, anchor).start;
        return [
          for (var i = 0; i < 7; i++)
            () {
              final day = DateTime(monday.year, monday.month, monday.day + i);
              return bucket(
                DateFormat.E().format(day),
                (t) => DateUtils.isSameDay(t.date, day),
              );
            }(),
        ];
      case AnalyticsPeriod.month:
        final days = DateTime(anchor.year, anchor.month + 1, 0).day;
        return [
          for (var w = 0; w < (days / 7).ceil(); w++)
            bucket(
              'W${w + 1}',
              (t) =>
                  t.date.year == anchor.year &&
                  t.date.month == anchor.month &&
                  (t.date.day - 1) ~/ 7 == w,
            ),
        ];
      case AnalyticsPeriod.year:
        return [
          for (var m = 1; m <= 12; m++)
            bucket(
              DateFormat.MMM().format(DateTime(anchor.year, m)),
              (t) => t.date.year == anchor.year && t.date.month == m,
            ),
        ];
    }
  }

  CategoryInsight? _insight(
    List<TransactionModel> all,
    _Range current,
    _Range previous,
    AnalyticsPeriod period,
  ) {
    int sum(_Range r, TransactionCategory c) => all
        .where(
          (t) =>
              t.type == TransactionType.expense &&
              t.category == c &&
              r.contains(t.date),
        )
        .fold(0, (s, t) => s + t.amountCents);

    CategoryInsight? best;
    for (final c in TransactionCategory.values.where((c) => c.isSpending)) {
      final before = sum(previous, c);
      if (before == 0) continue;
      final pct = ((sum(current, c) - before) * 100 / before).round();
      if (pct == 0) continue;
      if (best == null || pct.abs() > best.changePct.abs()) {
        best = CategoryInsight(c, pct, period);
      }
    }
    return best;
  }
}
