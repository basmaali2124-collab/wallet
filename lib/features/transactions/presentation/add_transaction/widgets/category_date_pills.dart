import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/dropdown_pill.dart';

class CategoryDatePills extends StatelessWidget {
  const CategoryDatePills({
    super.key,
    required this.categoryIcon,
    required this.categoryLabel,
    required this.dateLabel,
    required this.onCategory,
    required this.onDate,
  });

  final IconData categoryIcon;
  final String categoryLabel;
  final String dateLabel;
  final VoidCallback onCategory;
  final VoidCallback onDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownPill(
            icon: categoryIcon,
            label: categoryLabel,
            onTap: onCategory,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: DropdownPill(
            icon: Icons.calendar_today_outlined,
            label: dateLabel,
            onTap: onDate,
          ),
        ),
      ],
    );
  }
}