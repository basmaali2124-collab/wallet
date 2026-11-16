import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/widgets/primary_button.dart';

class TransactionsEmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const TransactionsEmptyState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final circleSize = isLandscape ? 72.0 : 112.r;
    final iconSize = isLandscape ? 32.0 : 48.r;

    final illustration = Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        color: context.palette.surface,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.receipt_long_rounded,
        size: iconSize,
        color: AppColors.textSecondary,
      ),
    );

    final texts = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isLandscape ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(l10n.noTransactionsYet, style: AppTextStyles.title),
        SizedBox(height: AppSpacing.xs),
        Text(
          l10n.noTransactionsHint,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: AppTextStyles.caption,
        ),
        SizedBox(height: isLandscape ? AppSpacing.lg : AppSpacing.xxl),
       SizedBox(
  width: isLandscape ? 200 : 280,
  height: isLandscape ? 40 : 52,
  child: PrimaryButton(label: l10n.addTransaction, onPressed: onAdd),
),
      ],
    );

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: isLandscape
            ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  illustration,
                  SizedBox(width: AppSpacing.xl),
                  Flexible(child: texts),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  illustration,
                  SizedBox(height: AppSpacing.lg),
                  texts,
                ],
              ),
      ),
    );
  }
}