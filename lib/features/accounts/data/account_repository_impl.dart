import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/models/account_model.dart';
import 'package:wallet_app/features/accounts/domain/account_repository.dart';

@LazySingleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(@Named('accounts') this._box);
  final Box<Map> _box;

  Map<String, dynamic> _toMap(AccountModel a) => {
    'id': a.id,
    'name': a.name,
    'openingBalanceCents': a.openingBalanceCents,
    'currency': a.currency,
  };

  AccountModel _fromMap(Map m) => AccountModel(
    id: m['id'] as String,
    name: m['name'] as String,
    openingBalanceCents: m['openingBalanceCents'] as int,
    currency: (m['currency'] as String?) ?? 'USD',
  );

  static int _order(AccountModel a, AccountModel b) {
    if (a.id == AccountIds.main) return -1;
    if (b.id == AccountIds.main) return 1;
    return a.name.compareTo(b.name);
  }

  List<AccountModel> _all() =>
      _box.values.map(_fromMap).toList()..sort(_order);

  @override
  Stream<List<AccountModel>> watchAll() async* {
    yield _all();
    yield* _box.watch().map((_) => _all());
  }

  @override
  Future<void> put(AccountModel a) => _box.put(a.id, _toMap(a));

  @override
  Future<void> delete(String id) => _box.delete(id);

  @override
  Future<void> setOpeningBalance(String id, int cents) async {
    final raw = _box.get(id);
    if (raw == null) return;
    await put(_fromMap(raw).copyWith(openingBalanceCents: cents));
  }

  @override
  Future<void> resetOpeningBalances() async {
    for (final a in _all()) {
      if (a.openingBalanceCents != 0) {
        await put(a.copyWith(openingBalanceCents: 0));
      }
    }
  }

   @override
  Future<void> ensureDefaults() async {
    if (_box.isNotEmpty) return;
    await put(const AccountModel(id: AccountIds.main, name: 'Main Account'));
    await put(const AccountModel(id: AccountIds.guest, name: 'Guest Account'));
  }
}