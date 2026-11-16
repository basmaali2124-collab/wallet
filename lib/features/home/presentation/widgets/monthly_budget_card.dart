import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/theme/text_style_ext.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/money.dart';

class MonthlyBudgetCard extends StatelessWidget {
  const MonthlyBudgetCard({
    super.key,
    required this.spentCents,
    required this.limitCents,
    required this.percent,
    this.onTap,
  });

  final int spentCents;
  final int limitCents;
  final double percent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final over = limitCents > 0 && spentCents > limitCents;
    final color = over ? AppColors.expense : AppColors.primary;
    final label = over ? percent.ceil() : percent.floor();

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardBorder,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.monthlyBudget),
              const SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: (percent / 100).clamp(0.0, 1.0)),
                duration: const Duration(milliseconds: 600),
                builder: (_, v, _) => LinearProgressIndicator(
                  value: v,
                  minHeight: 8,
                  borderRadius: AppRadius.pillBorder,
                  backgroundColor: AppColors.others,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${l10n.spent} ',
                              style: AppTextStyles.caption.tabular,
                            ),
                            TextSpan(
                              text: Money.format(spentCents),
                              style: AppTextStyles.caption
                                  .copyWith(
                                    color: context.palette.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  )
                                  .tabular,
                            ),
                            TextSpan(
                              text: ' / ${Money.format(limitCents)}',
                              style: AppTextStyles.caption.tabular,
                            ),
                          ],
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$label%',
                    style: AppTextStyles.caption.copyWith(color: color).tabular,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}