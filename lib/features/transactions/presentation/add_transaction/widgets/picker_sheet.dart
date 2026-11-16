import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
class PickerItem<T> {
  final T value;
  final String label;
  final IconData icon;
  final Color? color;

  const PickerItem({
    required this.value,
    required this.label,
    required this.icon,
    this.color,
  });
}

Future<T?> showPickerSheet<T>(
  BuildContext context, {
  required String title,
  required List<PickerItem<T>> items,
  T? selected,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              0,
              AppSpacing.xl,
              AppSpacing.sm,
            ),
            child: Text(title, style: AppTextStyles.title),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                for (final item in items)
                  ListTile(
                    onTap: () => Navigator.of(sheetContext).pop(item.value),
                    leading: Container(
                      width: 40.r,
                      height: 40.r,
                      decoration:  BoxDecoration(
                        color: context.palette.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        size: 20.r,
                        color: item.color ?? AppColors.primary,
                      ),
                    ),
                    title: Text(item.label),
                    trailing: item.value == selected
                        ? const Icon(Icons.check_rounded)
                        : null,
                  ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.sm),
        ],
      ),
    ),
  );
}
