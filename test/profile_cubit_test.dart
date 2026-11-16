import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:wallet_app/core/data/settings_repository.dart';
import 'package:wallet_app/core/models/account_model.dart';
import 'package:wallet_app/core/models/bill_model.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/features/accounts/domain/account_repository.dart';
import 'package:wallet_app/features/bills/domain/bill_repository.dart';
import 'package:wallet_app/features/profile/domain/export_csv.dart';
import 'package:wallet_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:wallet_app/features/transactions/domain/transaction_repository.dart';

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

class FakeAccounts implements AccountRepository {
  final store = <String, AccountModel>{
    AccountIds.main: const AccountModel(id: AccountIds.main, name: 'Main'),
  };

  @override
  Stream<List<AccountModel>> watchAll() => Stream.value(store.values.toList());
  @override
  Future<void> put(AccountModel account) async => store[account.id] = account;
  @override
  Future<void> delete(String id) async => store.remove(id);
  @override
  Future<void> setOpeningBalance(String id, int cents) async {
    final account = store[id];
    if (account != null) {
      store[id] = account.copyWith(openingBalanceCents: cents);
    }
  }

  @override
  Future<void> resetOpeningBalances() async {
    for (final id in store.keys.toList()) {
      store[id] = store[id]!.copyWith(openingBalanceCents: 0);
    }
  }

  @override
  Future<void> ensureDefaults() async {}
}

void main() {
  late Directory dir;
  late Box box;
  late SettingsRepository settings;
  late FakeTx txs;
  late FakeBills bills;
  late FakeAccounts accounts;
  late ProfileCubit cubit;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('profile_test');
    Hive.init(dir.path);
    box = await Hive.openBox('settings');
    settings = SettingsRepository(box);
    txs = FakeTx();
    bills = FakeBills();
    accounts = FakeAccounts();
    cubit = ProfileCubit(
      settings,
      txs,
      bills,
      accounts,
      BuildTransactionsCsv(),
    );
  });

  tearDown(() async {
    await cubit.close();
    await box.close();
    await Hive.close();
    dir.deleteSync(recursive: true);
  });

  test('starts with default settings', () {
    expect(cubit.state.budgetCents, SettingsRepository.defaultBudgetCents);
    expect(cubit.state.openingBalanceCents, 0);
  });

  test('setBudget saves the budget', () async {
    await cubit.setBudget(500000);

    expect(settings.monthlyBudgetCents, 500000);
  });

  test('setOpeningBalance saves it on the main account', () async {
    await cubit.setOpeningBalance(123456);

    expect(accounts.store[AccountIds.main]!.openingBalanceCents, 123456);
  });

  test('updateProfile saves name and email', () async {
    await cubit.updateProfile('  Sara ', ' sara@mail.com ');

    expect(settings.profileName, 'Sara');
    expect(settings.profileEmail, 'sara@mail.com');
  });

  test('resetAll clears data and restores defaults', () async {
    await settings.markSeeded();
    await cubit.setBudget(999);
    await cubit.setOpeningBalance(5000);
    await txs.add(
      TransactionModel(
        id: 't',
        type: TransactionType.expense,
        amountCents: 100,
        category: TransactionCategory.others,
        title: 't',
        date: DateTime(2026, 11, 1),
      ),
    );
    await bills.put(
      BillModel(
        id: 'b',
        name: 'b',
        amountCents: 100,
        dueDate: DateTime(2026, 11, 20),
      ),
    );

    await cubit.resetAll();

    expect(txs.store, isEmpty);
    expect(bills.store, isEmpty);
    expect(settings.monthlyBudgetCents, SettingsRepository.defaultBudgetCents);
    expect(accounts.store[AccountIds.main]!.openingBalanceCents, 0);
    expect(settings.isSeeded, isTrue);
  });
}
