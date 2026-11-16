import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/dropdown_pill.dart';

class TransferPills extends StatelessWidget {
  const TransferPills({
    super.key,
    required this.fromName,
    required this.toName,
    required this.dateLabel,
    required this.onFrom,
    required this.onTo,
    required this.onDate,
  });

  final String fromName;
  final String toName;
  final String dateLabel;
  final VoidCallback onFrom;
  final VoidCallback onTo;
  final VoidCallback onDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownPill(
                icon: Icons.account_balance_wallet_outlined,
                label: fromName,
                onTap: onFrom,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 20.r,
                color: AppColors.textSecondary,
              ),
            ),
            Expanded(
              child: DropdownPill(
                icon: Icons.account_balance_wallet_outlined,
                label: toName,
                onTap: onTo,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        DropdownPill(
          icon: Icons.calendar_today_outlined,
          label: dateLabel,
          onTap: onDate,
        ),
      ],
    );
  }
}