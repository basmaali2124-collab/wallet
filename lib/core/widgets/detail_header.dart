import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/theme/text_style_ext.dart';

class DetailHeader extends StatelessWidget {
  const DetailHeader({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.amount,
    this.amountColor,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String amount;
  final Color? amountColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.title,
          ),
          SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              amount,
              maxLines: 1,
              style: AppTextStyles.display
                  .copyWith(
                    fontSize: 32,
                    color: amountColor ?? context.palette.textPrimary,
                  )
                  .tabular,
            ),
          ),
        ],
      ),
    );
  }
}
