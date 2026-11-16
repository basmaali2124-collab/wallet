import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/theme/text_style_ext.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/l10n_labels.dart';
import 'package:wallet_app/core/utils/money.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final bool showDate;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
    this.showDate = false,
  });

  Color get _amountColor => switch (transaction.type) {
    TransactionType.income => AppColors.income,
    TransactionType.transfer => AppColors.primary,
    TransactionType.expense => AppColors.expense,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tx = transaction;
    final category = tx.category.localized(l10n);

    return Material(
      color: context.palette.background,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.tileBorder,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              _TileAvatar(transaction: tx),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body,
                    ),
                    Text(
                      showDate
                          ? '$category · ${context.formatDate('d MMM yyyy', tx.date)}'
                          : category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.md),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 140.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        Money.signed(tx.amountCents, tx.type),
                        style: AppTextStyles.body
                            .copyWith(color: _amountColor)
                            .tabular,
                      ),
                    ),
                    Text(
                      tx.type.localized(l10n),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TileAvatar extends StatelessWidget {
  final TransactionModel transaction;
  const _TileAvatar({required this.transaction});

  String get _initial {
    final name = transaction.title.replaceFirst('Transfer From ', '').trim();
    return name.isEmpty ? '?' : name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final tx = transaction;
    final isExpense = tx.type == TransactionType.expense;

    final Color tint = switch (tx.type) {
      TransactionType.expense => context.palette.surface,
      TransactionType.income => AppColors.income.withValues(alpha: 0.12),
      TransactionType.transfer => AppColors.primary.withValues(alpha: 0.12),
    };
    final Color fg = switch (tx.type) {
      TransactionType.expense => tx.category.color,
      TransactionType.income => AppColors.income,
      TransactionType.transfer => AppColors.primary,
    };

    return Container(
      width: 48.r,
      height: 48.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
      child: isExpense
          ? Icon(tx.category.icon, color: fg, size: 22.r)
          : Text(_initial, style: AppTextStyles.title.copyWith(color: fg)),
    );
  }
}