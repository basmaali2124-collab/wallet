import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';

class DateSectionHeader extends StatelessWidget {
  final DateTime date;
  const DateSectionHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(context.formatDate('d', date), style: AppTextStyles.title),
        SizedBox(width: AppSpacing.sm),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs / 2,
          ),
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(AppSpacing.xs + 2),
          ),
          child: Text(
            context.formatDate('EEE', date),
            style: AppTextStyles.caption,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Text(
          context.formatDate('MM.yyyy', date),
          style: AppTextStyles.caption,
        ),
        SizedBox(width: AppSpacing.sm),
        const Expanded(child: Divider(height: 1)),
      ],
    );
  }
}