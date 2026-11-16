import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/features/analytics/domain/analytics_usecases.dart';

class PeriodBarsCard extends StatelessWidget {
  const PeriodBarsCard({super.key, required this.buckets});

  final List<PeriodBucket> buckets;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final maxCents = buckets.fold<int>(
      0,
      (m, b) => math.max(m, math.max(b.incomeCents, b.expenseCents)),
    );
    final maxY = maxCents == 0 ? 1.0 : maxCents / 100 * 1.15;
    final dense = buckets.length > 8;
    final labelStyle = dense
        ? AppTextStyles.caption.copyWith(fontSize: 10)
        : AppTextStyles.caption;
    const hidden = AxisTitles(sideTitles: SideTitles(showTitles: false));

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l10n.incomeVsExpense, style: AppTextStyles.body),
                ),
                _Dot(color: AppColors.income, label: l10n.typeIncome),
                SizedBox(width: AppSpacing.md),
                _Dot(color: AppColors.primary, label: l10n.typeExpense),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 200.h,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  alignment: BarChartAlignment.spaceAround,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: hidden,
                    topTitles: hidden,
                    rightTitles: hidden,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 0 || i >= buckets.length) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            child: Text(buckets[i].label, style: labelStyle),
                          );
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(enabled: false),
                  barGroups: [
                    for (var i = 0; i < buckets.length; i++)
                      BarChartGroupData(
                        x: i,
                        barsSpace: 3,
                        barRods: [
                          BarChartRodData(
                            toY: buckets[i].incomeCents / 100,
                            color: AppColors.income,
                            width: dense ? 6.w : 8.w,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          BarChartRodData(
                            toY: buckets[i].expenseCents / 100,
                            color: AppColors.primary,
                            width: dense ? 6.w : 8.w,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.sm,
          height: AppSpacing.sm,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: AppSpacing.xs),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}