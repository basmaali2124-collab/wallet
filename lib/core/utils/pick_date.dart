import 'package:flutter/material.dart';

Future<DateTime?> pickAppDate(BuildContext context, DateTime initial) =>
    showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

extension DateTimeWithDate on DateTime {
 DateTime withDate(DateTime picked) =>
      DateTime(picked.year, picked.month, picked.day, hour, minute);
}
