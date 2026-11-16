import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/data/settings_repository.dart';
import 'package:wallet_app/core/models/bill_category.dart';
import 'package:wallet_app/core/models/bill_model.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/accounts/domain/account_repository.dart';
import 'package:wallet_app/features/bills/domain/bill_repository.dart';
import 'package:wallet_app/features/transactions/domain/transaction_repository.dart';
import 'package:wallet_app/core/models/account_model.dart';

@lazySingleton
class DemoSeeder {
  final TransactionRepository _tx;
  final BillRepository _bills;
  final AccountRepository _accounts;
  final SettingsRepository _settings;

  DemoSeeder(this._tx, this._bills, this._accounts, this._settings);

  static const startBalanceCents = 1500000;

  Future<void> seedIfNeeded() async {
    if (_settings.isSeeded) return;
    final now = DateTime.now();

    DateTime d(int day, int h, int m) {
      final base = day <= now.day
          ? DateTime(now.year, now.month, 1)
          : DateTime(now.year, now.month - 1, 1);
      final last = DateTime(base.year, base.month + 1, 0).day;
      return DateTime(base.year, base.month, day > last ? last : day, h, m);
    }

    DateTime inDays(int n) => DateTime(now.year, now.month, now.day + n);

    TransactionModel t(
      String id,
      TransactionType type,
      int cents,
      TransactionCategory cat,
      String title,
      DateTime date, {
      String? note,
    }) => TransactionModel(
      id: id,
      type: type,
      amountCents: cents,
      category: cat,
      title: title,
      date: date,
      note: note,
    );

    const e = TransactionType.expense;
    const i = TransactionType.income;
    final txs = [
      t(
        't1',
        e,
        16999,
        TransactionCategory.subscription,
        'YouTube Premium',
        d(21, 9, 41),
        note: 'Family plan, renews every 21st.',
      ),
      t(
        't2',
        i,
        43000,
        TransactionCategory.salary,
        'Transfer From Sayuti',
        d(21, 8, 10),
      ),
      t(
        't3',
        e,
        1555,
        TransactionCategory.subscription,
        'Apple Music',
        d(20, 18, 5),
      ),
      t(
        't4',
        i,
        55000,
        TransactionCategory.transfer,
        'Transfer From Zahra',
        d(20, 11, 30),
      ),
      t('t5', e, 40950, TransactionCategory.shopping, 'Zara', d(18, 16, 20)),
      t(
        't6',
        e,
        25250,
        TransactionCategory.foodAndDrink,
        'Groceries',
        d(15, 19, 0),
      ),
      t('t7', e, 30000, TransactionCategory.shopping, 'Amazon', d(12, 13, 45)),
      t(
        't8',
        e,
        16500,
        TransactionCategory.education,
        'Udemy Course',
        d(10, 21, 15),
      ),
      t(
        't9',
        e,
        6196,
        TransactionCategory.subscription,
        'Spotify Family',
        d(8, 7, 30),
      ),
      t(
        't10',
        e,
        16000,
        TransactionCategory.foodAndDrink,
        'Starbucks',
        d(5, 10, 0),
      ),
      t('t11', e, 11550, TransactionCategory.others, 'Taxi', d(3, 23, 10)),
      t(
        't12',
        i,
        100000,
        TransactionCategory.salary,
        'Monthly Salary',
        d(1, 9, 0),
      ),
      t(
        't13',
        e,
        16999,
        TransactionCategory.subscription,
        'YouTube Premium',
        DateTime(now.year, now.month - 1, 21, 9, 41),
      ),
    ];
    for (final tx in txs) {
      await _tx.add(tx);
    }

    final bills = [
      BillModel(
        id: 'b1',
        name: 'Internet - Indihome',
        amountCents: 12000,
        dueDate: inDays(3),
        category: BillCategory.internet,
        isRecurring: true,
      ),
      BillModel(
        id: 'b2',
        name: 'Electricity - PLN',
        amountCents: 12000,
        dueDate: inDays(5),
        category: BillCategory.electricity,
        isRecurring: true,
      ),
      BillModel(
        id: 'b3',
        name: 'Mobile - Telkomsel',
        amountCents: 10000,
        dueDate: inDays(-3),
        category: BillCategory.mobile,
      ),
      BillModel(
        id: 'b4',
        name: 'Water - PDAM',
        amountCents: 8500,
        dueDate: inDays(-5),
        category: BillCategory.water,
        isPaid: true,
      ),
    ];
    for (final b in bills) {
      await _bills.put(b);
    }

    final net = txs.fold<int>(0, (sum, tx) {
      return switch (tx.type) {
        TransactionType.income => sum + tx.amountCents,
        TransactionType.expense => sum - tx.amountCents,
        TransactionType.transfer => sum,
      };
    });
       final opening = startBalanceCents - net;
    await _accounts.ensureDefaults();
    await _accounts.setOpeningBalance(AccountIds.main, opening);
    await _settings.markSeeded();await _settings.markSeeded();await _settings.markSeeded();
  }
}