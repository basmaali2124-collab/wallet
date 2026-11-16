import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
class DropdownPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DropdownPill({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.pillBorder,
      child: Container(
        constraints: BoxConstraints(minHeight: AppSpacing.minTapTarget + 4),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: AppRadius.pillBorder,
          border: AppBorders.all(context),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18.r, color: context.palette.textPrimary),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18.r,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
