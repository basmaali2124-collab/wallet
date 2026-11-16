import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.background : null;

    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 18,
        color: selected ? AppColors.background : color,
      ),
      label: Text(label, style: TextStyle(color: foreground)),
      showCheckmark: false,
      selected: selected,
      selectedColor: AppColors.primary,
      side: BorderSide(
        color: selected ? AppColors.primary : context.palette.border,
      ),
      onSelected: (_) => onTap(),
    );
  }
}