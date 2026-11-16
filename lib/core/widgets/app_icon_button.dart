import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool showBadge;
 
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.showBadge = false,
   
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: AppSpacing.sm),
      child: SizedBox(
        width: AppSpacing.minTapTarget,height:AppSpacing.minTapTarget ,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.palette.background,
                  shape: BoxShape.circle,
                  border: AppBorders.all(context),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onPressed,
                  icon: Icon(icon, color: context.palette.textPrimary),
                ),
              ),
            ),
            if (showBadge)
              PositionedDirectional(
                top: AppSpacing.sm,
                end: AppSpacing.md,
                child: Container(
                  width: AppSpacing.badge,
                  height: AppSpacing.badge,
                  decoration: BoxDecoration(
                    color: AppColors.expense,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.palette.background, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}