import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_app/core/models/bill_model.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/bills/domain/bill_repository.dart';
import 'package:wallet_app/features/bills/domain/bill_usecases.dart';
import 'package:wallet_app/features/bills/presentation/cubit/bills_state.dart';
import 'package:wallet_app/features/transactions/domain/transaction_repository.dart';

class FakeBills implements BillRepository {
  final store = <String, BillModel>{};

  @override
  Stream<List<BillModel>> watchAll() => Stream.value(store.values.toList());
  @override
  Future<BillModel?> getById(String id) async => store[id];
  @override
  Future<void> put(BillModel bill) async => store[bill.id] = bill;
  @override
  Future<void> delete(String id) async => store.remove(id);
  @override
  Future<void> clear() async => store.clear();
}

class FakeTx implements TransactionRepository {
  final store = <String, TransactionModel>{};

  @override
  Stream<List<TransactionModel>> watchAll() =>
      Stream.value(store.values.toList());
  @override
  Future<void> add(TransactionModel tx) async => store[tx.id] = tx;
  @override
  Future<void> delete(String id) async => store.remove(id);
  @override
  Future<void> clear() async => store.clear();
}

BillModel makeBill({
  String id = 'b1',
  DateTime? due,
  bool recurring = false,
  bool paid = false,
}) {
  return BillModel(
    id: id,
    name: 'Internet',
    amountCents: 12000,
    dueDate: due ?? DateTime(2026, 11, 20),
    isRecurring: recurring,
    isPaid: paid,
  );
}

void main() {
  final now = DateTime(2026, 11, 12, 10);
  late FakeBills bills;
  late FakeTx txs;
  late PayBill pay;

  setUp(() {
    bills = FakeBills();
    txs = FakeTx();
    pay = PayBill(bills, txs);
  });

  test('paying a bill marks it paid and creates an expense', () async {
    final bill = makeBill();
    await bills.put(bill);

    final result = await pay(bill, now: now);

    expect(bills.store['b1']!.isPaid, isTrue);
    expect(txs.store.values.single.type, TransactionType.expense);
    expect(txs.store.values.single.amountCents, 12000);
    expect(result.next, isNull);
  });

  test('paying a recurring bill creates next month bill', () async {
    final bill = makeBill(recurring: true);
    await bills.put(bill);

    final result = await pay(bill, now: now);

    expect(bills.store.length, 2);
    expect(result.next!.dueDate, DateTime(2026, 12, 20));
    expect(result.next!.isPaid, isFalse);
  });

  test('undo brings everything back', () async {
    final bill = makeBill(recurring: true);
    await bills.put(bill);
    final result = await pay(bill, now: now);

    await pay.undo(result);

    expect(bills.store.length, 1);
    expect(bills.store['b1']!.isPaid, isFalse);
    expect(txs.store, isEmpty);
  });

  test('paying an already paid bill throws', () async {
    var threw = false;
    try {
      await pay(makeBill(paid: true), now: now);
    } catch (e) {
      threw = true;
    }
    expect(threw, isTrue);
  });

  test('addOneMonth handles short months and new year', () {
    expect(addOneMonth(DateTime(2026, 1, 31)), DateTime(2026, 2, 28));
    expect(addOneMonth(DateTime(2026, 12, 15)), DateTime(2027, 1, 15));
  });

  test('BillsState counts and total', () {
    final overdue = makeBill(id: 'o', due: DateTime(2026, 11, 5));
    final soon = makeBill(id: 's', due: DateTime(2026, 11, 14));
    final later = makeBill(id: 'l', due: DateTime(2026, 11, 30));
    final done = makeBill(id: 'p', due: DateTime(2026, 11, 1), paid: true);

    final state = BillsState(
      status: BillsStatus.loaded,
      all: [later, done, overdue, soon],
    );

    expect(state.countFor(BillFilter.overdue, now: now), 1);
    expect(state.countFor(BillFilter.upcoming, now: now), 2);
    expect(state.unpaidCents, 36000);
  });
}
