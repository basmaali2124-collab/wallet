import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/l10n_labels.dart';
import 'package:wallet_app/core/utils/money.dart';
import 'package:wallet_app/core/widgets/count_up_money.dart';
import 'package:wallet_app/features/home/presentation/cubit/home_state.dart';
import 'package:wallet_app/features/home/presentation/widgets/monthly_stat_item.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.state,
    required this.onToggleHidden,
    required this.onSelectAccount,
  });

  final HomeState state;
  final VoidCallback onToggleHidden;
  final ValueChanged<String> onSelectAccount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = Money.symbolFor(state.currency);
    final hidden = state.hideBalance;

    var selectedLabel = l10n.accountMain;
    for (final a in state.accounts) {
      if (a.id == state.selectedAccountId) selectedLabel = accountName(l10n, a);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.cardBorder,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cardGradientStart, AppColors.cardGradientEnd],
        ),
        boxShadow: AppShadows.balanceCard,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: PopupMenuButton<String>(
                    onSelected: onSelectAccount,
                    offset: const Offset(0, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    itemBuilder: (context) => [
                      for (final a in state.accounts)
                        PopupMenuItem(
                          value: a.id,
                          child: Text(accountName(l10n, a)),
                        ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: AppRadius.pillBorder,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              selectedLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.onCard,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                           Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.onCard,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert, color: AppColors.onCard),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.totalBalance,
              style: AppTextStyles.caption.copyWith(
                fontSize: 16,
                color: AppColors.onCardMuted,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CountUpMoney(
                    cents: state.totalBalanceCents,
                    style: AppTextStyles.balance,
                    symbol: symbol,
                    hidden: hidden,
                    dimCents: true,
                  ),
                ),
                IconButton(
                  onPressed: onToggleHidden,
                  icon: Icon(
                    hidden
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.onCard,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(color: AppColors.onCardDivider),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MonthlyStatItem(
                    isHidden: hidden,
                    symbol: symbol,
                    amountCents: state.incomeCents,
                    changePct: state.incomeChangePct,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MonthlyStatItem(
                    isIncome: false,
                    isHidden: hidden,
                    symbol: symbol,
                    amountCents: state.expenseCents,
                    changePct: state.expenseChangePct,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}