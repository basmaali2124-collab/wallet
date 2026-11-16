import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/models/account_model.dart';
import 'package:wallet_app/core/models/bill_model.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/bills/domain/bill_repository.dart';
import 'package:wallet_app/features/transactions/domain/transaction_repository.dart';

DateTime addOneMonth(DateTime d, {int? day}) {
  final want = day ?? d.day;
  final target = DateTime(d.year, d.month + 1, 1);
  final lastDay = DateTime(target.year, target.month + 1, 0).day;
  return DateTime(target.year, target.month, want > lastDay ? lastDay : want);
}

class PayBillResult {
  final BillModel original;
  final TransactionModel payment;
  final BillModel? next;
  const PayBillResult(this.original, this.payment, this.next);
}

@lazySingleton
class PayBill {
  PayBill(this._bills, this._transactions);
  final BillRepository _bills;
  final TransactionRepository _transactions;

  Future<PayBillResult> call(
    BillModel bill, {
    String accountId = AccountIds.main,
    DateTime? now,
  }) async {
    final current = await _bills.getById(bill.id) ?? bill;
    if (current.isPaid) throw StateError('Bill already paid');

    final paidAt = now ?? DateTime.now();
    final stamp = paidAt.microsecondsSinceEpoch;

    final payment = TransactionModel(
      id: 'bill_${current.id}_$stamp',
      type: TransactionType.expense,
      amountCents: current.amountCents,
      category: TransactionCategory.bills,
      title: current.name,
      note: current.note == null
          ? 'Bill payment'
          : 'Bill payment · ${current.note}',
      date: paidAt,
      accountId: accountId,
    );

    BillModel? next;
    if (current.isRecurring) {
      final today = DateTime(paidAt.year, paidAt.month, paidAt.day);
      var due = addOneMonth(current.dueDate, day: current.dayOfMonth);
      while (due.isBefore(today)) {
        due = addOneMonth(due, day: current.dayOfMonth);
      }
      next = BillModel(
        id: '$stamp',
        name: current.name,
        amountCents: current.amountCents,
        dueDate: due,
        category: current.category,
        isRecurring: true,
        note: current.note,
        anchorDay: current.dayOfMonth,
      );
    }

    await _transactions.add(payment);
    try {
      await _bills.put(current.copyWith(isPaid: true));
      if (next != null) await _bills.put(next);
    } catch (_) {
      await _transactions.delete(payment.id);
      await _bills.put(current);
      if (next != null) await _bills.delete(next.id);
      rethrow;
    }
    return PayBillResult(current, payment, next);
  }

  Future<void> undo(PayBillResult r) async {
    await _bills.put(r.original);
    await _transactions.delete(r.payment.id);
    if (r.next != null) await _bills.delete(r.next!.id);
  }
}