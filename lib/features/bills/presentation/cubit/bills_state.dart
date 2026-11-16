import 'package:wallet_app/core/models/bill_model.dart';

enum BillsStatus { loading, loaded, error }

enum BillFilter { upcoming, overdue, paid }

enum BillGroup { overdue, thisWeek, later, paid }

class BillSection {
  final BillGroup group;
  final List<BillModel> bills;
  const BillSection(this.group, this.bills);
}

class BillsState {
  final BillsStatus status;
  final List<BillModel> all;
  final BillFilter filter;
  final String? error;

  const BillsState({
    this.status = BillsStatus.loading,
    this.all = const [],
    this.filter = BillFilter.upcoming,
    this.error,
  });

  BillsState copyWith({
    BillsStatus? status,
    List<BillModel>? all,
    BillFilter? filter,
    String? error,
    bool clearError = false,
  }) => BillsState(
    status: status ?? this.status,
    all: all ?? this.all,
    filter: filter ?? this.filter,
    error: clearError ? null : (error ?? this.error),
  );

  static bool _matches(BillModel b, BillFilter f, DateTime now) => switch (f) {
    BillFilter.upcoming => b.isUpcomingAt(now),
    BillFilter.overdue => b.isOverdueAt(now),
    BillFilter.paid => b.isPaid,
  };

  int countFor(BillFilter f, {DateTime? now}) {
    final n = now ?? DateTime.now();
    return all.where((b) => _matches(b, f, n)).length;
  }

  List<BillModel> visibleAt(DateTime now) {
    final list = all.where((b) => _matches(b, filter, now)).toList();
    list.sort(
      (a, b) => filter == BillFilter.paid
          ? b.dueDate.compareTo(a.dueDate)
          : a.dueDate.compareTo(b.dueDate),
    );
    return list;
  }

  List<BillModel> get visible => visibleAt(DateTime.now());

  List<BillSection> sectionsAt(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final weekEnd = DateTime(
      today.year,
      today.month,
      today.day + (7 - today.weekday),
    );
    DateTime dayOf(BillModel b) =>
        DateTime(b.dueDate.year, b.dueDate.month, b.dueDate.day);

    final overdue = <BillModel>[];
    final thisWeek = <BillModel>[];
    final later = <BillModel>[];
    final paid = <BillModel>[];

    for (final b in all) {
      if (b.isPaid) {
        paid.add(b);
      } else if (b.isOverdueAt(now)) {
        overdue.add(b);
      } else if (!dayOf(b).isAfter(weekEnd)) {
        thisWeek.add(b);
      } else {
        later.add(b);
      }
    }

    int byDue(BillModel a, BillModel b) => a.dueDate.compareTo(b.dueDate);
    overdue.sort(byDue);
    thisWeek.sort(byDue);
    later.sort(byDue);
    paid.sort((a, b) => b.dueDate.compareTo(a.dueDate));

    return [
      for (final s in [
        BillSection(BillGroup.overdue, overdue),
        BillSection(BillGroup.thisWeek, thisWeek),
        BillSection(BillGroup.later, later),
        BillSection(BillGroup.paid, paid),
      ])
        if (s.bills.isNotEmpty) s,
    ];
  }

  List<BillSection> get sections => sectionsAt(DateTime.now());

  int get unpaidCents =>
      all.where((b) => !b.isPaid).fold(0, (s, b) => s + b.amountCents);

  int get paidCents =>
      all.where((b) => b.isPaid).fold(0, (s, b) => s + b.amountCents);

  static bool _inMonth(BillModel b, DateTime now) =>
      b.dueDate.year == now.year && b.dueDate.month == now.month;

  int dueThisMonthCents({DateTime? now}) {
    final n = now ?? DateTime.now();
    return all
        .where((b) => !b.isPaid && (_inMonth(b, n) || b.isOverdueAt(n)))
        .fold(0, (s, b) => s + b.amountCents);
  }

  int paidThisMonthCents({DateTime? now}) {
    final n = now ?? DateTime.now();
    return all
        .where((b) => b.isPaid && _inMonth(b, n))
        .fold(0, (s, b) => s + b.amountCents);
  }

  int get overdueCount => countFor(BillFilter.overdue);
  int get filterIndex => filter.index;
}