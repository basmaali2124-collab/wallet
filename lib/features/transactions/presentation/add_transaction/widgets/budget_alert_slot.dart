import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/budget_alert_banner.dart';

class BudgetAlertSlot extends StatelessWidget {
  const BudgetAlertSlot({
    super.key,
    required this.visible,
    required this.percent,
    required this.onDismiss,
  });

  final bool visible;
  final int percent;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: double.infinity,
        child: visible
            ? Padding(
                padding: EdgeInsets.only(top: AppSpacing.md),
                child: BudgetAlertBanner(percent: percent, onDismiss: onDismiss),
              )
            : null,
      ),
    );
  }
}