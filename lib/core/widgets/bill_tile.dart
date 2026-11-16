import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/theme/text_style_ext.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/money.dart';

class BillTile extends StatelessWidget {
  final IconData icon;
  final String billTitle;
  final DateTime due;
  final int amountCents;
  final Color color;
  final bool isPaid;
  final VoidCallback? onMarkPaid;
  final VoidCallback? onTap;

  const BillTile({
    super.key,
    required this.icon,
    required this.billTitle,
    required this.due,
    required this.amountCents,
    required this.color,
    this.isPaid = false,
    this.onMarkPaid,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final days = DateTime.utc(due.year, due.month, due.day)
        .difference(DateTime.utc(now.year, now.month, now.day))
        .inDays;
    final urgent = !isPaid && days <= 2;
    final label = isPaid
        ? l10n.billPaid
        : days < 0
        ? l10n.daysLate(-days)
        : days == 0
        ? l10n.dueToday
        : l10n.daysLeft(days);

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color),
        ),
        title: Text(billTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${l10n.billDueOn(context.formatDate('d MMM', due))} · ',
              ),
              TextSpan(
                text: label,
                style: TextStyle(
                  color: isPaid
                      ? AppColors.income
                      : urgent
                      ? AppColors.expense
                      : null,
                ),
              ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  Money.format(amountCents),
                  maxLines: 1,
                  style: AppTextStyles.body.tabular,
                ),
              ),
            ),
            if (onMarkPaid != null)
              IconButton(
                onPressed: onMarkPaid,
                icon: Icon(
                  isPaid ? Icons.check_circle_outline : Icons.circle_outlined,
                  color: isPaid ? AppColors.income : AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}