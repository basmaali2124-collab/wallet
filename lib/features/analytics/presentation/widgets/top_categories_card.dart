import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/theme/text_style_ext.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/l10n_labels.dart';
import 'package:wallet_app/core/utils/money.dart';
import 'package:wallet_app/features/analytics/domain/analytics_usecases.dart';

class TopCategoriesCard extends StatelessWidget {
  const TopCategoriesCard({super.key, required this.slices});

  final List<CategorySlice> slices;

  static const int maxItems = 3;

  @override
  Widget build(BuildContext context) {
    final top = slices.take(maxItems).toList();
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.topCategories, style: AppTextStyles.title),
            SizedBox(height: AppSpacing.md),
            for (final s in top)
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: _CategoryRow(slice: s),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.slice});

  final CategorySlice slice;

  @override
  Widget build(BuildContext context) {
    final color = slice.category.color;
    return Row(
      children: [
        Container(
          width: AppSpacing.minTapTarget,
          height: AppSpacing.minTapTarget,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(slice.category.icon, color: color),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      slice.category.localized(context.l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        Money.format(slice.cents),
                        maxLines: 1,
                        style: AppTextStyles.body.tabular,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (slice.percent / 100).clamp(0.0, 1.0),
                      minHeight: 4,
                      borderRadius: AppRadius.pillBorder,
                      color: color,
                      backgroundColor: context.palette.border,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    '${slice.percent.round()}%',
                    style: AppTextStyles.caption.tabular,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}