import 'package:flutter/material.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/theme/text_style_ext.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/money.dart';
import 'package:wallet_app/core/widgets/stacked_category_bar.dart';

class TotalSpendCard extends StatelessWidget {
  final Map<TransactionCategory, int> totals;
  final TransactionCategory? selected;
  final ValueChanged<TransactionCategory> onCategoryTap;

  const TotalSpendCard({
    super.key,
    required this.totals,
    required this.selected,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final total = totals.values.fold<int>(0, (sum, v) => sum + v);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    context.l10n.totalSpend,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      Money.format(total),
                      style: AppTextStyles.body.tabular,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            StackedCategoryBar(
              totals: totals,
              selected: selected,
              onCategoryTap: onCategoryTap,
            ),
          ],
        ),
      ),
    );
  }
}