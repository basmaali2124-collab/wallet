import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/widgets/app_icon_button.dart';
import 'package:wallet_app/features/analytics/presentation/widgets/period_selector.dart';
import 'package:wallet_app/features/transactions/presentation/cubit/transactions_cubit.dart';
import 'package:wallet_app/features/transactions/presentation/cubit/transactions_state.dart';

class TransactionsTopBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onCalendarTap;
  final VoidCallback onSearchTap;

  const TransactionsTopBar({
    super.key,
    required this.onCalendarTap,
    required this.onSearchTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TransactionsCubit>();

    return AppBar(
      automaticallyImplyLeading: false,
      leading: AppIconButton(
        icon: Icons.calendar_today_outlined,
        onPressed: onCalendarTap,
      ),
      centerTitle: true,
      title: BlocSelector<TransactionsCubit, TransactionsState, DateTime>(
        selector: (state) => state.date,
        builder: (context, date) {
          return PeriodSelector(label:  context.formatDate('EEE, d MMM yyyy', date),
                     onPrevious: () => cubit.shiftMonth(-1), onNext: () => cubit.shiftMonth(1)); 
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: AppIconButton(icon: Icons.search_rounded, onPressed: onSearchTap),
        ),
      ],
    );
  }
}