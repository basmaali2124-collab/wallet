import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';

class BudgetAlertBanner extends StatelessWidget {
  final int percent;
  final VoidCallback onDismiss;

  const BudgetAlertBanner({
    super.key,
    required this.percent,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: EdgeInsetsDirectional.only(
        start: AppSpacing.md,
        top: AppSpacing.xs,
        bottom: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: AppRadius.tileBorder,
      ),
      child: Row(
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.info,
              shape: BoxShape.circle,
            ),
            child: Text(
              '!',
              style: AppTextStyles.body.copyWith(color: Colors.white),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.budgetAlert, style: AppTextStyles.body),
                Text(
                  l10n.budgetAlertBody(percent),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            constraints: BoxConstraints(
              minWidth: AppSpacing.minTapTarget,
              minHeight: AppSpacing.minTapTarget,
            ),
            icon: const Icon(Icons.close_rounded, color: AppColors.info),
          ),
        ],
      ),
    );
  }
}