import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/widgets/app_icon_button.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.name,
    this.hasUnreadAlerts = false,
    this.onBell,
    this.onSettings,
  });

  final String name;
  final bool hasUnreadAlerts;
  final VoidCallback? onBell;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: AppSpacing.xxl,
        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
        child: Text(
          initial,
          style: AppTextStyles.title.copyWith(color: AppColors.primary),
        ),
      ),
      title: Text(
        context.l10n.greeting(name),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.body,
      ),
      subtitle: Text(
        context.formatDate('EEE, d MMMM yyyy', DateTime.now()),
        style: AppTextStyles.caption,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconButton(
            icon: Icons.notifications_none_rounded,
            showBadge: hasUnreadAlerts,
            onPressed: onBell ?? () {},
          ),
          AppIconButton(
            icon: CupertinoIcons.gear,
            onPressed: onSettings ?? () {},
          ),
        ],
      ),
    );
  }
}