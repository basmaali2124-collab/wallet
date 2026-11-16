import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet_app/core/models/bill_model.dart';
import 'package:wallet_app/core/responsive/max_width.dart';
import 'package:wallet_app/core/responsive/responsive_columns.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/widgets/app_icon_button.dart';
import 'package:wallet_app/core/widgets/bill_tile.dart';
import 'package:wallet_app/core/widgets/error_retry.dart';
import 'package:wallet_app/features/bills/presentation/add_bill/add_bill_sheet.dart';
import 'package:wallet_app/features/bills/presentation/add_bill/bill_actions.dart';
import 'package:wallet_app/features/bills/presentation/cubit/bills_cubit.dart';
import 'package:wallet_app/features/bills/presentation/cubit/bills_state.dart';
import 'package:wallet_app/features/bills/presentation/detail/bill_detail_sheet.dart';
import 'package:wallet_app/features/bills/presentation/widgets/bills_summary_card.dart';

class Bills extends StatelessWidget {
  const Bills({super.key});

  static String _groupTitle(BuildContext context, BillGroup g) {
    final l10n = context.l10n;
    return switch (g) {
      BillGroup.overdue => l10n.billOverdue,
      BillGroup.thisWeek => l10n.billThisWeek,
      BillGroup.later => l10n.billLater,
      BillGroup.paid => l10n.billPaid,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<BillsCubit>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: AppIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.bills),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 20),
            child: IconButton(
              style: IconButton.styleFrom(
                fixedSize: Size(
                  AppSpacing.minTapTarget,
                  AppSpacing.minTapTarget,
                ),
                backgroundColor: AppColors.primary,
              ),
              onPressed: () => AddBillSheet.show(context),
              icon: Icon(Icons.add, color: AppColors.surface),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<BillsCubit, BillsState>(
          builder: (context, state) {
            if (state.status == BillsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == BillsStatus.error) {
              return ErrorRetry(message: state.error, onRetry: cubit.retry);
            }

            final sections = state.sections;

            return Padding(
              padding: AppSpacing.screenHorizontal,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 88),
                      children: [
                        SizedBox(height: AppSpacing.md),
                        MaxWidth(
                          maxWidth: 520,
                          child: BillsSummaryCard(
                            unpaidCents: state.dueThisMonthCents(),
                            paidCents: state.paidThisMonthCents(),
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        if (sections.isEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: AppSpacing.xxxl),
                            child: Center(
                              child: Text(
                                l10n.noBillsYet,
                                style: AppTextStyles.caption,
                              ),
                            ),
                          )
                        else
                          for (final section in sections) ...[
                                _SectionHeader(
                                  title: _groupTitle(context, section.group),
                                  isOverdue: section.group == BillGroup.overdue,
                                ),
                                ResponsiveColumns(
                                  gap: AppSpacing.md,
                                  children: [
                                    for (final BillModel bill in section.bills)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: AppSpacing.md,
                                        ),
                                        child: BillTile(
                                          icon: bill.icon,
                                          billTitle: bill.name,
                                          due: bill.dueDate,
                                          amountCents: bill.amountCents,
                                          isPaid: bill.isPaid,
                                          color: bill.isPaid
                                              ? AppColors.income
                                              : bill.color,
                                          onTap: () => BillDetailSheet.show(
                                            context,
                                            bill,
                                          ),
                                          onMarkPaid: bill.isPaid
                                              ? null
                                              : () => payBillWithUndo(
                                                  context,
                                                  bill,
                                                ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.isOverdue});

  final String title;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.md),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: isOverdue ? AppColors.expense : AppColors.textSecondary,
        ),
      ),
    );
  }
}