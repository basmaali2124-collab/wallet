import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/data/hive_boxes.dart';

@module
abstract class RegisterModule {
  @preResolve
  @singleton
  @Named('transactions')
  Future<Box<Map>> get transactionsBox =>
      Hive.openBox<Map>(HiveBoxes.transactions);

  @preResolve
  @singleton
  @Named('bills')
  Future<Box<Map>> get billsBox => Hive.openBox<Map>(HiveBoxes.bills);

  @preResolve
  @singleton
  Future<Box> get settingsBox => Hive.openBox(HiveBoxes.settings);
  
  @preResolve
@singleton
@Named('accounts')
Future<Box<Map>> get accountsBox => Hive.openBox<Map>(HiveBoxes.accounts);

}
