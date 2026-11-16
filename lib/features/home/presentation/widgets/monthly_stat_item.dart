import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/theme/text_style_ext.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/widgets/count_up_money.dart';

class MonthlyStatItem extends StatelessWidget {
  final bool isIncome;
  final bool isHidden;
  final int amountCents;
  final double? changePct;
  final String symbol;

  const MonthlyStatItem({
    super.key,
    this.isIncome = true,
    this.isHidden = false,
    this.symbol = r'$',
    required this.amountCents,
    this.changePct,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final up = (changePct ?? 0) >= 0;
    final good = isIncome ? up : !up;
    final color = good ? AppColors.income : AppColors.expense;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isIncome ? l10n.monthlyIncome : l10n.monthlyExpense,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(color: AppColors.onCardMuted),
        ),
        Row(
          children: [
            Flexible(
              child: CountUpMoney(
                cents: amountCents,
                symbol: symbol,
                hidden: isHidden,
                style: AppTextStyles.balance.copyWith(fontSize: 14),
              ),
            ),
            if (changePct != null) ...[
              const SizedBox(width: 4),
              Icon(
                up && isIncome
                    ? Icons.north_east_rounded
                    : Icons.south_east_rounded,
                color: color,
                size: 16,
              ),
              Text(
                '${changePct!.abs().toStringAsFixed(1)}%',
                style: TextStyle(color: color, fontSize: 13).tabular,
              ),
            ],
          ],
        ),
      ],
    );
  }
}