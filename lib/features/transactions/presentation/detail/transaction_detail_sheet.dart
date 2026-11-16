import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
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
import 'package:wallet_app/features/transactions/presentation/cubit/transactions_cubit.dart';
import 'package:wallet_app/features/transactions/presentation/detail/edit_transaction_sheet.dart';

enum _DetailAction { edit, delete }

class TransactionDetailSheet extends StatelessWidget {
  const TransactionDetailSheet({super.key, required this.tx});

  final TransactionModel tx;

  static Future<void> show(BuildContext context, TransactionModel tx) async {
    final cubit = context.read<TransactionsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    final action = await showAppSheet<_DetailAction>(
      context,
      builder: (_) => TransactionDetailSheet(tx: tx),
    );
    if (action == null || !context.mounted) return;

    switch (action) {
      case _DetailAction.edit:
        final updated = await showEditTransactionSheet(context, tx);
        if (updated == null) return;
        await cubit.update(updated);
        showUndoSnackBar(
          messenger,
          message: l10n.transactionUpdated,
          onUndo: () => cubit.update(tx),
        );
      case _DetailAction.delete:
        await cubit.delete(tx);
        showUndoSnackBar(
          messenger,
          message: l10n.transactionDeleted,
          onUndo: () => cubit.undoDelete(tx),
        );
    }
  }

  Color _amountColor(BuildContext context) => switch (tx.type) {
    TransactionType.income => AppColors.income,
    TransactionType.expense => AppColors.expense,
    TransactionType.transfer => context.palette.textPrimary,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final note = tx.note;
    return AppSheetBody(
      children: [
        DetailHeader(
          icon: tx.category.icon,
          color: tx.category.color,
          title: tx.title,
          amount: Money.signed(tx.amountCents, tx.type),
          amountColor: _amountColor(context),
        ),
        SizedBox(height: AppSpacing.xl),
        DetailRow(label: l10n.typeLabel, value: tx.type.localized(l10n)),
        DetailRow(label: l10n.category, value: tx.category.localized(l10n)),
        DetailRow(
          label: l10n.dateLabel,
          value: context.formatDate('EEE, d MMM yyyy · HH:mm', tx.date),
        ),
        if (note != null && note.isNotEmpty)
          DetailRow(label: l10n.note, value: note),
        SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: l10n.delete,
                color: AppColors.expense,
                onPressed: () =>
                    Navigator.of(context).pop(_DetailAction.delete),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: PrimaryButton(
                label: l10n.edit,
                onPressed: () => Navigator.of(context).pop(_DetailAction.edit),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
