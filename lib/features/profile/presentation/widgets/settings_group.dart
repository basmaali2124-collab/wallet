import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/theme/text_style_ext.dart';

class SettingsSectionLabel extends StatelessWidget {
  const SettingsSectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsetsDirectional.only(
      start: AppSpacing.xs,
      bottom: AppSpacing.sm,
    ),
    child: Text(text, style: AppTextStyles.caption),
  );
}

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.palette.background,
        borderRadius: AppRadius.tileBorder,
        border: AppBorders.all(context),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(height: 1, indent: 52),
            children[i],
          ],
        ],
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
    this.color,
    this.showChevron = true,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? color;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.tileBorder,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: AppSpacing.minTapTarget + AppSpacing.md,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          leading: Icon(icon, color: color ?? AppColors.primary),
          title: Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: color ?? context.palette.textPrimary,
            ),
          ),
          trailing:
              trailing ??
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (value != null)
                    Text(
                      value!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.tabular,
                    ),
                  if (showChevron) ...[
                    SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ],
              ),
        ),
      ),
    );
  }
}
