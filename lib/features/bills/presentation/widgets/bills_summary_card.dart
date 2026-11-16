import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/theme/text_style_ext.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/money.dart';

class BillsSummaryCard extends StatelessWidget {
  const BillsSummaryCard({
    super.key,
    required this.unpaidCents,
    required this.paidCents,
  });

  final int unpaidCents;
  final int paidCents;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            label: l10n.dueThisMonth,
            cents: unpaidCents,
            color: context.palette.textPrimary,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatBox(
            label: l10n.billPaid,
            cents: paidCents,
            color: AppColors.income,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.cents,
    required this.color,
  });

  final String label;
  final int cents;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.palette.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, maxLines: 1, style: AppTextStyles.caption),
          SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              Money.format(cents),
              maxLines: 1,
              style: AppTextStyles.title
                  .copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: color,
                  )
                  .tabular,
            ),
          ),
        ],
      ),
    );
  }
}