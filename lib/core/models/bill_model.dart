import 'package:flutter/material.dart';
import 'package:wallet_app/core/models/bill_category.dart';

class BillModel {
  final String id;
  final String name;
  final int amountCents;
  final DateTime dueDate;
  final BillCategory category;
  final bool isRecurring;
  final bool isPaid;
  final String? note;

 final int? anchorDay;

  const BillModel({
    required this.id,
    required this.name,
    required this.amountCents,
    required this.dueDate,
    this.category = BillCategory.other,
    this.isRecurring = false,
    this.isPaid = false,
    this.note,
    this.anchorDay,
  });

  int get dayOfMonth => anchorDay ?? dueDate.day;

  IconData get icon => category.icon;
  Color get color => category.color;

  BillModel copyWith({
    String? name,
    int? amountCents,
    DateTime? dueDate,
    BillCategory? category,
    bool? isRecurring,
    bool? isPaid,
    String? note,
    bool clearNote = false,
  }) => BillModel(
    id: id,
    name: name ?? this.name,
    amountCents: amountCents ?? this.amountCents,
    dueDate: dueDate ?? this.dueDate,
    category: category ?? this.category,
    isRecurring: isRecurring ?? this.isRecurring,
    isPaid: isPaid ?? this.isPaid,
    note: clearNote ? null : (note ?? this.note),
    anchorDay: dueDate == null ? anchorDay : null,
  );
}

extension BillTiming on BillModel {
  bool isOverdueAt(DateTime now) =>
      !isPaid && DateUtils.dateOnly(dueDate).isBefore(DateUtils.dateOnly(now));

  bool isUpcomingAt(DateTime now) => !isPaid && !isOverdueAt(now);
}