import 'package:wallet_app/core/models/account_model.dart';
import 'package:wallet_app/core/models/bill_model.dart';

enum HomeStatus { loading, loaded, error }

class HomeState {
  final HomeStatus status;
  final String profileName;
  final int totalBalanceCents;
  final int incomeCents;
  final int expenseCents;
  final double? incomeChangePct;
  final double? expenseChangePct;
  final int budgetLimitCents;
  final int budgetSpentCents; 
  final double budgetPercent;
  final bool hideBalance;
  final List<BillModel> upcomingBills;
  final int overdueBillCount;
  final List<AccountModel> accounts;
  final String selectedAccountId;
  final String currency;
  final String? error;

  const HomeState({
    this.status = HomeStatus.loading,
    this.profileName = '',
    this.totalBalanceCents = 0,
    this.incomeCents = 0,
    this.expenseCents = 0,
    this.incomeChangePct,
    this.expenseChangePct,
    this.budgetLimitCents = 0,
    this.budgetSpentCents = 0,
    this.budgetPercent = 0,
    this.hideBalance = false,
    this.upcomingBills = const [],
    this.overdueBillCount = 0,
    this.accounts = const [],
    this.selectedAccountId = AccountIds.main,
    this.currency = 'USD',
    this.error,
  });

  bool get overBudget =>
      budgetLimitCents > 0 && budgetSpentCents > budgetLimitCents;
  double get budgetProgress => (budgetPercent / 100).clamp(0.0, 1.0);

  HomeState copyWith({HomeStatus? status, String? error}) => HomeState(
    status: status ?? this.status,
    profileName: profileName,
    totalBalanceCents: totalBalanceCents,
    incomeCents: incomeCents,
    expenseCents: expenseCents,
    incomeChangePct: incomeChangePct,
    expenseChangePct: expenseChangePct,
    budgetLimitCents: budgetLimitCents,
    budgetSpentCents: budgetSpentCents,
    budgetPercent: budgetPercent,
    hideBalance: hideBalance,
    upcomingBills: upcomingBills,
    overdueBillCount: overdueBillCount,
    accounts: accounts,
    selectedAccountId: selectedAccountId,
    currency: currency,
    error: error,
  );
}