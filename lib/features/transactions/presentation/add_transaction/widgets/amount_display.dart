import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/theme/text_style_ext.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';

class AmountDisplay extends StatelessWidget {
  const AmountDisplay({
    super.key,
    required this.symbol,
    required this.formatted,
    this.error,
  });

  final String symbol;
  final String formatted;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          error ?? context.l10n.amount,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: error == null ? null : AppColors.expense,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '$symbol$formatted',
            key: const Key('amount_display'),
            style: AppTextStyles.display.tabular,
          ),
        ),
      ],
    );
  }
}