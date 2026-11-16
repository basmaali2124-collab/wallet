import 'package:wallet_app/core/models/account_model.dart';

abstract class AccountRepository {
  Stream<List<AccountModel>> watchAll();
  Future<void> put(AccountModel account);
  Future<void> delete(String id);
  Future<void> setOpeningBalance(String id, int cents);
  Future<void> resetOpeningBalances();
  Future<void> ensureDefaults();
}