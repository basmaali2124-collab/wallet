import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/theme/text_style_ext.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/l10n_labels.dart';
import 'package:wallet_app/core/utils/money.dart';
import 'package:wallet_app/features/analytics/domain/analytics_usecases.dart';

class CategoryPieCard extends StatefulWidget {
  final List<CategorySlice> slices;
  final int totalCents;

  const CategoryPieCard({
    super.key,
    required this.slices,
    required this.totalCents,
  });

  @override
  State<CategoryPieCard> createState() => _CategoryPieCardState();
}

class _CategoryPieCardState extends State<CategoryPieCard> {
  int? _selected;

  void _toggle(int index) {
    setState(() => _selected = index < 0 || index == _selected ? null : index);
  }

  @override
  Widget build(BuildContext context) {
    final slices = widget.slices;
    final selected = _selected != null && _selected! < slices.length
        ? _selected
        : null;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: slices.isEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
                child: Center(
                  child: Text(
                    context.l10n.noSpendingPeriod,
                    style: AppTextStyles.caption,
                  ),
                ),
              )
            : Row(
                children: [
                  _Donut(
                    slices: slices,
                    totalCents: widget.totalCents,
                    selected: selected,
                    onTap: _toggle,
                  ),
                  SizedBox(width: AppSpacing.xl),
                  Expanded(
                    child: _Legend(
                      slices: slices,
                      selected: selected,
                      onTap: _toggle,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _Donut extends StatelessWidget {
  const _Donut({
    required this.slices,
    required this.totalCents,
    required this.selected,
    required this.onTap,
  });

  final List<CategorySlice> slices;
  final int totalCents;
  final int? selected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final slice = selected == null ? null : slices[selected!];

    return SizedBox(
      width: 140.r,
      height: 140.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sectionsSpace: 2,
              centerSpaceRadius: 46.r,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  if (event is! FlTapUpEvent) return;
                  onTap(response?.touchedSection?.touchedSectionIndex ?? -1);
                },
              ),
              sections: [
                for (var i = 0; i < slices.length; i++)
                  PieChartSectionData(
                    value: slices[i].cents.toDouble(),
                    color: selected == null || selected == i
                        ? slices[i].category.color
                        : slices[i].category.color.withValues(alpha: 0.35),
                    radius: selected == i ? 22.r : 18.r,
                    showTitle: false,
                  ),
              ],
            ),
          ),
          SizedBox(
            width: 80.r,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    slice?.category.localized(l10n) ?? l10n.spent,
                    maxLines: 1,
                    style: AppTextStyles.caption,
                  ),
                  Text(
                    Money.format(slice?.cents ?? totalCents),
                    maxLines: 1,
                    style: AppTextStyles.title.tabular.copyWith(
                      color: context.palette.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.slices,
    required this.selected,
    required this.onTap,
  });

  final List<CategorySlice> slices;
  final int? selected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = slices.fold<int>(0, (sum, s) => sum + s.cents);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < slices.length; i++)
          InkWell(
            onTap: () => onTap(i),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xs + 1),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: slices[i].category.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      slices[i].category.localized(l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: context.palette.textPrimary,
                        fontWeight:
                            selected == i ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    total == 0
                        ? '0%'
                        : '${(slices[i].cents * 100 / total).round()}%',
                    maxLines: 1,
                    style: AppTextStyles.caption.tabular.copyWith(
                      color: context.palette.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}