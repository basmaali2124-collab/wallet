import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';

class StackedCategoryBar extends StatelessWidget {
  final Map<TransactionCategory, int> totals;
  final TransactionCategory? selected;
  final ValueChanged<TransactionCategory>? onCategoryTap;

  const StackedCategoryBar({
    super.key,
    required this.totals,
    this.selected,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final entries = totals.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => a.key.index.compareTo(b.key.index));
    final total = entries.fold<int>(0, (sum, e) => sum + e.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 32.h,
          child: entries.isEmpty
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.palette.border,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < entries.length; i++)
                      Expanded(
                        flex: math.max(
                          1,
                          (entries[i].value * 1000 / total).round(),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                            end: i < entries.length - 1 ? AppSpacing.xs : 0,
                          ),
                          child: GestureDetector(
                            onTap: () => onCategoryTap?.call(entries[i].key),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: _isActive(entries[i].key) ? 1 : 0.3,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: entries[i].key.color,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.xs,
          children: [
            for (final e in entries)
              _LegendItem(
                category: e.key,
                active: _isActive(e.key),
                selected: selected == e.key,
                onTap: () => onCategoryTap?.call(e.key),
              ),
          ],
        ),
      ],
    );
  }

  bool _isActive(TransactionCategory c) => selected == null || selected == c;
}

class _LegendItem extends StatelessWidget {
  final TransactionCategory category;
  final bool active;
  final bool selected;
  final VoidCallback onTap;

  const _LegendItem({
    required this.category,
    required this.active,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: active ? 1 : 0.3),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: AppSpacing.xs + 2),
            Text(
              category.label,
              style: AppTextStyles.caption.copyWith(
                color: selected
                    ? context.palette.textPrimary
                    : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
