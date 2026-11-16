import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/core/models/bill_model.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/l10n_labels.dart';
import 'package:wallet_app/core/utils/money.dart';
import 'package:wallet_app/core/utils/undo_snackbar.dart';
import 'package:wallet_app/core/widgets/app_sheet.dart';
import 'package:wallet_app/core/widgets/detail_header.dart';
import 'package:wallet_app/core/widgets/detail_row.dart';
import 'package:wallet_app/core/widgets/primary_button.dart';
import 'package:wallet_app/core/widgets/secondary_button.dart';
import 'package:wallet_app/features/bills/presentation/add_bill/bill_actions.dart';
import 'package:wallet_app/features/bills/presentation/cubit/bills_cubit.dart';
import 'package:wallet_app/features/bills/presentation/add_bill/add_bill_sheet.dart';
import 'package:wallet_app/l10n/app_localizations.dart';

enum _BillAction { edit, delete, pay }

class BillDetailSheet extends StatelessWidget {
  const BillDetailSheet({super.key, required this.bill});

  final BillModel bill;

  static Future<void> show(BuildContext context, BillModel bill) async {
    final cubit = context.read<BillsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    final action = await showAppSheet<_BillAction>(
      context,
      builder: (_) => BillDetailSheet(bill: bill),
    );
    if (action == null || !context.mounted) return;

    switch (action) {
      case _BillAction.edit:
        final updated = await AddBillSheet.pick(context, existing: bill);
        if (updated == null) return;
        await cubit.update(updated);
        showUndoSnackBar(
          messenger,
          message: l10n.billUpdated,
          onUndo: () => cubit.update(bill),
        );
      case _BillAction.pay:
        payBillWithUndo(context, bill);
      case _BillAction.delete:
        await cubit.delete(bill);
        showUndoSnackBar(
          messenger,
          message: l10n.billDeleted,
          onUndo: () => cubit.undoDelete(bill),
        );
    }
  }

  String _status(AppLocalizations l10n, DateTime now) {
    if (bill.isPaid) return l10n.billPaid;
    if (bill.isOverdueAt(now)) return l10n.billOverdue;
    return l10n.billUpcoming;
  }

  Color _statusColor(BuildContext context, DateTime now) {
    if (bill.isPaid) return AppColors.income;
    if (bill.isOverdueAt(now)) return AppColors.expense;
    return context.palette.textPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final note = bill.note;

    return AppSheetBody(
      children: [
        DetailHeader(
          icon: bill.icon,
          color: bill.color,
          title: bill.name,
          amount: Money.format(bill.amountCents),
        ),
        SizedBox(height: AppSpacing.xl),
        DetailRow(
          label: l10n.status,
          value: _status(l10n, now),
          valueColor: _statusColor(context, now),
        ),
        DetailRow(label: l10n.category, value: bill.category.localized(l10n)),
        DetailRow(
          label: l10n.dueDate,
          value: context.formatDate('EEE, d MMM yyyy', bill.dueDate),
        ),
        DetailRow(
          label: l10n.repeats,
          value: bill.isRecurring ? l10n.monthly : l10n.once,
        ),
        if (note != null && note.isNotEmpty)
          DetailRow(label: l10n.note, value: note),
        SizedBox(height: AppSpacing.xl),
        if (!bill.isPaid) ...[
          PrimaryButton(
            label: l10n.markAsPaid,
            onPressed: () => Navigator.of(context).pop(_BillAction.pay),
          ),
          SizedBox(height: AppSpacing.md),
        ],
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: l10n.delete,
                color: AppColors.expense,
                onPressed: () => Navigator.of(context).pop(_BillAction.delete),
              ),
            ),
            if (!bill.isPaid) ...[
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: SecondaryButton(
                  label: l10n.edit,
                  onPressed: () => Navigator.of(context).pop(_BillAction.edit),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
