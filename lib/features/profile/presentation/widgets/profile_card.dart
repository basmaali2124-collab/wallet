import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.onEdit,
  });

  final String name;
  final String email;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.palette.background,
        borderRadius: AppRadius.cardBorder,
        border: AppBorders.all(context),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSpacing.xxxl,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Text(
              name.isEmpty ? '?' : name[0].toUpperCase(),
              style: AppTextStyles.title.copyWith(color: AppColors.primary),
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  email,
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onEdit,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: AppRadius.pillBorder),
              side: AppBorders.side(context),
              foregroundColor: context.palette.textPrimary,
              minimumSize: Size(
                AppSpacing.minTapTarget,
                AppSpacing.minTapTarget,
              ),
            ),
            child: Text(context.l10n.edit),
          ),
        ],
      ),
    );
  }
}