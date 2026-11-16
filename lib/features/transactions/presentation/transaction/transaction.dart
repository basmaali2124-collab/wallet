import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/core/responsive/breakpoints.dart';
import 'package:wallet_app/core/responsive/responsive_columns.dart';
import 'package:wallet_app/core/router/app_router.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/pick_date.dart';
import 'package:wallet_app/core/widgets/date_section_header.dart';
import 'package:wallet_app/core/widgets/error_retry.dart';
import 'package:wallet_app/core/widgets/segmented_tabs.dart';
import 'package:wallet_app/core/widgets/transaction_tile.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/add_transaction_sheet.dart';
import 'package:wallet_app/features/transactions/presentation/cubit/transactions_cubit.dart';
import 'package:wallet_app/features/transactions/presentation/cubit/transactions_state.dart';
import 'package:wallet_app/features/transactions/presentation/detail/transaction_detail_sheet.dart';
import 'package:wallet_app/features/transactions/presentation/transaction/widgets/total_spend_card.dart';
import 'package:wallet_app/features/transactions/presentation/transaction/widgets/transactions_empty_state.dart';
import 'package:wallet_app/features/transactions/presentation/transaction/widgets/transactions_top_bar.dart';

class Transaction extends StatelessWidget {
  const Transaction({super.key});

  static List<Object> _flatten(List<TransactionModel> list) {
    final items = <Object>[];
    DateTime? current;
    for (final t in list) {
      final day = DateTime(t.date.year, t.date.month, t.date.day);
      if (current != day) {
        items.add(day);
        current = day;
      }
      items.add(t);
    }
    return items;
  }

  static List<List<Object>> _groupByDay(List<Object> items) {
    final groups = <List<Object>>[];
    for (final item in items) {
      if (item is DateTime) {
        groups.add(<Object>[item]);
      } else {
        groups.last.add(item);
      }
    }
    return groups;
  }

  Future<void> _pickDate(BuildContext context, DateTime initial) async {
    final cubit = context.read<TransactionsCubit>();
    final picked = await pickAppDate(context, initial);
    if (picked != null) cubit.setDate(picked);
  }

  void _openSearch(BuildContext context) => context.push(AppRoutes.search);

  Widget _pad(Widget sliver) =>
      SliverPadding(padding: AppSpacing.screenHorizontal, sliver: sliver);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TransactionsCubit>();
    final l10n = context.l10n;

    return Scaffold(
      appBar: TransactionsTopBar(
        onCalendarTap: () => _pickDate(context, cubit.state.date),
        onSearchTap: () => _openSearch(context),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<TransactionsCubit, TransactionsState>(
          builder: (context, state) {
            final visible = state.visible;
            final items = _flatten(visible);

            return CustomScrollView(
              slivers: [
                _pad(
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: AppSpacing.md),
                        FilterChipsBar(
                          labels: [
                            l10n.filterAll,
                            l10n.typeIncome,
                            l10n.typeExpense,
                            l10n.typeTransfer,
                          ],
                          selectedIndex: state.filterIndex,
                          onChanged: cubit.setFilterIndex,
                        ),
                        SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
                ..._bodySlivers(context, state, visible, items),
                SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _bodySlivers(
    BuildContext context,
    TransactionsState state,
    List<TransactionModel> visible,
    List<Object> items,
  ) {
    if (state.status == TransactionsStatus.loading) {
      return [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (state.status == TransactionsStatus.error) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ErrorRetry(
            message: state.error,
            onRetry: context.read<TransactionsCubit>().retry,
          ),
        ),
      ];
    }

    if (visible.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: TransactionsEmptyState(
            onAdd: () => AddTransactionSheet.show(context),
          ),
        ),
      ];
    }

    final showSummary = state.showSummary;

    return [
      _pad(
        SliverLayoutBuilder(
          builder: (context, c) {
            final wide = Breakpoints.columnsFor(c.crossAxisExtent) == 2;

            if (wide) {
              final groups = _groupByDay(items);
              return SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showSummary)
                      Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.md),
                        child: _summaryCard(context, state),
                      ),
                    ResponsiveColumns(
                      weights: [for (final g in groups) g.length],
                      children: [
                        for (final g in groups)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final item in g) _itemWidget(context, item),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }

            final offset = showSummary ? 1 : 0;
            return SliverList.builder(
              itemCount: items.length + offset,
              itemBuilder: (context, index) {
                if (showSummary && index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md),
                    child: _summaryCard(context, state),
                  );
                }
                return _itemWidget(context, items[index - offset]);
              },
            );
          },
        ),
      ),
    ];
  }

  Widget _summaryCard(BuildContext context, TransactionsState state) {
    final cubit = context.read<TransactionsCubit>();
    return TotalSpendCard(
      totals: state.spendByCategory,
      selected: state.category,
      onCategoryTap: cubit.toggleCategory,
    );
  }

  Widget _itemWidget(BuildContext context, Object item) {
    if (item is DateTime) {
      return Padding(
        padding: EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
        child: DateSectionHeader(date: item),
      );
    }

    final tx = item as TransactionModel;
    return TransactionTile(
      transaction: tx,
      onTap: () => TransactionDetailSheet.show(context, tx),
    );
  }
}
