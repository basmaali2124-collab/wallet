import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_colors.dart';

enum BillCategory {
  internet('Internet', Icons.wifi, AppColors.shopping),
  electricity('Electricity', Icons.bolt, AppColors.subscription),
  water('Water', Icons.water_drop_outlined, AppColors.info),
  gas('Gas', Icons.local_fire_department_outlined, AppColors.education),
  mobile('Mobile', Icons.smartphone, AppColors.foodAndDrink),
  rent('Rent', Icons.home_outlined, AppColors.bills),
  insurance('Insurance', Icons.shield_outlined, Color(0xFF14B8A6)),
  tv('TV', Icons.tv_rounded, AppColors.expense),
  other('Other', Icons.receipt_long_outlined, AppColors.textSecondary);

  const BillCategory(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;

  static BillCategory? fromName(String? name) {
    for (final c in values) {
      if (c.name == name) return c;
    }
    return null;
  }
}