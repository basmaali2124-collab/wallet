import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/core/models/bill_model.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/undo_snackbar.dart';
import 'package:wallet_app/features/bills/presentation/cubit/bills_cubit.dart';
import 'package:wallet_app/features/home/presentation/cubit/home_cubit.dart';

Future<void> payBillWithUndo(BuildContext context, BillModel bill) async {
  final cubit = context.read<BillsCubit>();
  final accountId = context.read<HomeCubit>().state.selectedAccountId;
  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;
  final result = await cubit.pay(bill, accountId: accountId);
  if (result == null) return;
  showUndoSnackBar(
    messenger,
    message: l10n.billMarkedPaid(bill.name),
    onUndo: () => cubit.undoPay(result),
  );
}