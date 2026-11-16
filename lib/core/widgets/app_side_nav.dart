import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';

class AppSideNav extends StatelessWidget {
  const AppSideNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddPressed,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddPressed;

  static const _icons = [
    Icons.home_rounded,
    Icons.swap_horiz_rounded,
    Icons.bar_chart_rounded,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final labels = [l.navHome, l.navTransaction, l.navAnalytics, l.navProfile];

    return Container(
      width: 96.w,
      decoration: BoxDecoration(
        color: context.palette.background,
        border: BorderDirectional(end: AppBorders.side(context)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: AppSpacing.xl),
              Tooltip(
                message: l.addTransaction,
                child: GestureDetector(
                  onTap: onAddPressed,
                  child: Container(
                    width: 56.r,
                    height: 56.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: AppShadows.fab,
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 28.r),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xxl),
              for (var i = 0; i < _icons.length; i++)
                _SideItem(
                  icon: _icons[i],
                  label: labels[i],
                  selected: currentIndex == i,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideItem extends StatelessWidget {
  const _SideItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? context.palette.textPrimary
        : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.tileBorder,
      child: SizedBox(
        width: double.infinity,
        height: 64.r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24.r),
            SizedBox(height: AppSpacing.xs),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}