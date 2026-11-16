import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_colors.dart';

enum TransactionCategory {
  shopping('Shopping', Icons.shopping_cart_outlined, AppColors.shopping, true),
  foodAndDrink(
    'Food & Drink',
    Icons.restaurant_rounded,
    AppColors.foodAndDrink,
    true,
  ),
  subscription(
    'Subscription',
    Icons.subscriptions_rounded,
    AppColors.subscription,
    true,
  ),
   education('Education', Icons.school_outlined, AppColors.education, true),
  bills('Bills', Icons.receipt_long_outlined, AppColors.bills, true),
  others('Others', Icons.more_horiz_rounded, AppColors.others, true),
  salary('Salary', Icons.payments_outlined, AppColors.income, false),
  transfer('Transfer', Icons.swap_horiz_rounded, AppColors.primary, false);

  const TransactionCategory(this.label, this.icon, this.color, this.isSpending);

  final String label;
  final IconData icon;
  final Color color;
  final bool isSpending;
}
