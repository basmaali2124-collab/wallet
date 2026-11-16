import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/models/transaction_model.dart';

class MonthlySummary {
  final int incomeCents;
  final int expenseCents;
  final double? incomeChangePct;
  final double? expenseChangePct;
  const MonthlySummary(
    this.incomeCents,
    this.expenseCents,
    this.incomeChangePct,
    this.expenseChangePct,
  );
}

@lazySingleton
class CalculateMonthlySummary {
  MonthlySummary call(List<TransactionModel> all, DateTime month) {
    final prev = DateTime(month.year, month.month - 1, 1);
    final income = _sum(all, month, TransactionType.income);
    final expense = _sum(all, month, TransactionType.expense);
    return MonthlySummary(
      income,
      expense,
      _change(income, _sum(all, prev, TransactionType.income)),
      _change(expense, _sum(all, prev, TransactionType.expense)),
    );
  }

  int _sum(List<TransactionModel> all, DateTime m, TransactionType type) => all
      .where(
        (t) =>
            t.type == type && t.date.year == m.year && t.date.month == m.month,
      )
      .fold(0, (s, t) => s + t.amountCents);

  double? _change(int now, int before) =>
      before == 0 ? null : (now - before) * 100 / before;
}

@lazySingleton
class CalculateBudget {
  double call(int spentCents, int limitCents) =>
      limitCents <= 0 ? 0 : spentCents * 100 / limitCents;
}