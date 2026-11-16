import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/core/responsive/responsive_two_pane.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/widgets/amount_dialog.dart';
import 'package:wallet_app/core/widgets/error_retry.dart';
import 'package:wallet_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:wallet_app/features/home/presentation/cubit/home_state.dart';
import 'package:wallet_app/features/home/presentation/widgets/balance_card.dart';
import 'package:wallet_app/features/home/presentation/widgets/home_header.dart';
import 'package:wallet_app/features/home/presentation/widgets/monthly_budget_card.dart';
import 'package:wallet_app/features/home/presentation/widgets/upcoming_bills_section.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Future<void> _editBudget(BuildContext context, HomeState state) =>
      editMonthlyBudget(
        context,
        currentCents: state.budgetLimitCents,
        onSave: context.read<HomeCubit>().setBudget,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == HomeStatus.error) {
            return ErrorRetry(
              message: state.error,
              onRetry: context.read<HomeCubit>().refresh,
            );
          }

          return RefreshIndicator(
            onRefresh: context.read<HomeCubit>().refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  children: [
                    HomeHeader(name: state.profileName),
                    ResponsiveTwoPane(
                      stackedGap: 0,
                      primary: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          BalanceCard(
                            state: state,
                            onToggleHidden: context
                                .read<HomeCubit>()
                                .toggleHideBalance,
                            onSelectAccount:
                                context.read<HomeCubit>().selectAccount,
                          ),
                          SizedBox(height: AppSpacing.xl),
                          MonthlyBudgetCard(
                            spentCents: state.budgetSpentCents,
                            limitCents: state.budgetLimitCents,
                            percent: state.budgetPercent,
                            onTap: () => _editBudget(context, state),
                          ),
                        ],
                      ),
                      secondary: UpcomingBillsSection(state: state),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}