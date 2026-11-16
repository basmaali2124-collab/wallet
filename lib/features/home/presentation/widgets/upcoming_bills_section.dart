import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet_app/core/router/app_router.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/widgets/bill_tile.dart';
import 'package:wallet_app/features/bills/presentation/add_bill/bill_actions.dart';
import 'package:wallet_app/features/bills/presentation/detail/bill_detail_sheet.dart';
import 'package:wallet_app/features/home/presentation/cubit/home_state.dart';

class UpcomingBillsSection extends StatelessWidget {
  const UpcomingBillsSection({super.key, required this.state});
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                l10n.upcomingBills,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (state.overdueBillCount > 0) ...[
              SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  l10n.overdueCount(state.overdueBillCount),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.expense,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const Spacer(),
            TextButton(
              onPressed: () => context.push(AppRoutes.bills),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.viewAll),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                ],
              ),
            ),
          ],
        ),
       if (state.upcomingBills.isEmpty)
  Padding(
    padding: EdgeInsets.only(top: AppSpacing.md),
    child: const _EmptyBills(),
  )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: state.upcomingBills.length,
            separatorBuilder: (_, _) => SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final bill = state.upcomingBills[index];
              return BillTile(
                icon: bill.icon,
                billTitle: bill.name,
                due: bill.dueDate,
                amountCents: bill.amountCents,
                color: bill.color,
                onTap: () => BillDetailSheet.show(context, bill),
                onMarkPaid: bill.isPaid
                    ? null
                    : () => payBillWithUndo(context, bill),
              );
            },
          ),
      ],
    );
  }
}
class _EmptyBills extends StatelessWidget {
  const _EmptyBills();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.xxl,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primary.withValues(alpha: 0.12),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: scheme.primary,
              size: 28,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            l10n.noBillsDueMonth,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            l10n.noBillsDueMonthHint,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}