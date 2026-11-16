import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddPressed;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mq = MediaQuery.of(context);
    final isLandscape = mq.orientation == Orientation.landscape;
    final bottomInset = mq.padding.bottom;
    final barHeight = isLandscape ? 52.0 : 64.h;
    final fabSize = isLandscape ? 44.0 : 56.r;
    final fabOverflow = isLandscape ? 8.0 : fabSize / 2;

    return SizedBox(
      height: barHeight + bottomInset + fabOverflow,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: barHeight + bottomInset,
            child: Container(
              padding: EdgeInsets.only(bottom: bottomInset),
              decoration: BoxDecoration(
                color: context.palette.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(isLandscape ? 16 : 24.r),
                ),
                border: Border(top: AppBorders.side(context)),
              ),
              child: Row(
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: l10n.navHome,
                    selected: currentIndex == 0,
                    compact: isLandscape,
                    onTap: () => onTap(0),
                  ),
                  _NavItem(
                    icon: Icons.swap_horiz_rounded,
                    label: l10n.navTransaction,
                    selected: currentIndex == 1,
                    compact: isLandscape,
                    onTap: () => onTap(1),
                  ),
                  SizedBox(width: fabSize + (isLandscape ? 16 : 24.w)),
                  _NavItem(
                    icon: Icons.bar_chart_rounded,
                    label: l10n.navAnalytics,
                    selected: currentIndex == 2,
                    compact: isLandscape,
                    onTap: () => onTap(2),
                  ),
                  _NavItem(
                    icon: Icons.person_outline_rounded,
                    label: l10n.navProfile,
                    selected: currentIndex == 3,
                    compact: isLandscape,
                    onTap: () => onTap(3),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: onAddPressed,
                child: Container(
                  width: fabSize,
                  height: fabSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: AppShadows.fab,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: isLandscape ? 24 : 28.r,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    final iconSize = compact ? 26.0 : 28.r;
    final fontSize = compact ? 14.0 : 13.sp;

    final iconWidget = Icon(icon, color: color, size: iconSize);
    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.caption.copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
    );

    final pillColor = selected
        ? AppColors.primary.withValues(alpha: 0.12)
        : Colors.transparent;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.tileBorder,
        child: Center(
          child: compact
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: pillColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      iconWidget,
                      const SizedBox(width: 6),
                      Flexible(child: text),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: pillColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: iconWidget,
                    ),
                    SizedBox(height: 2.h),
                    text,
                  ],
                ),
        ),
      ),
    );
  }
}
