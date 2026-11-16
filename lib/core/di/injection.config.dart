// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;
import 'package:wallet_app/core/data/demo_seeder.dart' as _i658;
import 'package:wallet_app/core/data/settings_repository.dart' as _i220;
import 'package:wallet_app/core/di/register_module.dart' as _i478;
import 'package:wallet_app/core/settings/app_settings_cubit.dart' as _i823;
import 'package:wallet_app/features/accounts/data/account_repository_impl.dart'
    as _i913;
import 'package:wallet_app/features/accounts/domain/account_repository.dart'
    as _i248;
import 'package:wallet_app/features/accounts/domain/account_usecases.dart'
    as _i207;
import 'package:wallet_app/features/accounts/presentation/cubit/accounts_cubit.dart'
    as _i573;
import 'package:wallet_app/features/analytics/domain/analytics_usecases.dart'
    as _i1033;
import 'package:wallet_app/features/analytics/presentation/cubit/analytics_cubit.dart'
    as _i69;
import 'package:wallet_app/features/bills/data/bill_repository_impl.dart'
    as _i22;
import 'package:wallet_app/features/bills/domain/bill_repository.dart' as _i844;
import 'package:wallet_app/features/bills/domain/bill_usecases.dart' as _i75;
import 'package:wallet_app/features/bills/presentation/cubit/bills_cubit.dart'
    as _i851;
import 'package:wallet_app/features/home/domain/usecases.dart' as _i245;
import 'package:wallet_app/features/home/presentation/cubit/home_cubit.dart'
    as _i617;
import 'package:wallet_app/features/profile/domain/export_csv.dart' as _i734;
import 'package:wallet_app/features/profile/presentation/cubit/profile_cubit.dart'
    as _i327;
import 'package:wallet_app/features/transactions/data/transaction_local_data_source.dart'
    as _i26;
import 'package:wallet_app/features/transactions/data/transaction_repository_impl.dart'
    as _i265;
import 'package:wallet_app/features/transactions/domain/transaction_repository.dart'
    as _i281;
import 'package:wallet_app/features/transactions/presentation/cubit/transactions_cubit.dart'
    as _i1047;
import 'package:wallet_app/features/transactions/presentation/search/search_cubit.dart'
    as _i489;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.singletonAsync<_i986.Box<dynamic>>(
      () => registerModule.settingsBox,
      preResolve: true,
    );
    gh.lazySingleton<_i207.CalculateAccountBalances>(
      () => _i207.CalculateAccountBalances(),
    );
    gh.lazySingleton<_i1033.BuildAnalytics>(() => _i1033.BuildAnalytics());
    gh.lazySingleton<_i245.CalculateMonthlySummary>(
      () => _i245.CalculateMonthlySummary(),
    );
    gh.lazySingleton<_i245.CalculateBudget>(() => _i245.CalculateBudget());
    gh.lazySingleton<_i734.BuildTransactionsCsv>(
      () => _i734.BuildTransactionsCsv(),
    );
    await gh.singletonAsync<_i986.Box<Map<dynamic, dynamic>>>(
      () => registerModule.accountsBox,
      instanceName: 'accounts',
      preResolve: true,
    );
    await gh.singletonAsync<_i986.Box<Map<dynamic, dynamic>>>(
      () => registerModule.transactionsBox,
      instanceName: 'transactions',
      preResolve: true,
    );
    await gh.singletonAsync<_i986.Box<Map<dynamic, dynamic>>>(
      () => registerModule.billsBox,
      instanceName: 'bills',
      preResolve: true,
    );
    gh.lazySingleton<_i248.AccountRepository>(
      () => _i913.AccountRepositoryImpl(
        gh<_i979.Box<Map<dynamic, dynamic>>>(instanceName: 'accounts'),
      ),
    );
    gh.lazySingleton<_i220.SettingsRepository>(
      () => _i220.SettingsRepository(gh<_i979.Box<dynamic>>()),
    );
    gh.lazySingleton<_i26.TransactionLocalDataSource>(
      () => _i26.TransactionLocalDataSource(
        gh<_i979.Box<Map<dynamic, dynamic>>>(instanceName: 'transactions'),
      ),
    );
    gh.lazySingleton<_i844.BillRepository>(
      () => _i22.BillRepositoryImpl(
        gh<_i979.Box<Map<dynamic, dynamic>>>(instanceName: 'bills'),
      ),
    );
    gh.lazySingleton<_i823.AppSettingsCubit>(
      () => _i823.AppSettingsCubit(gh<_i220.SettingsRepository>()),
    );
    gh.lazySingleton<_i281.TransactionRepository>(
      () => _i265.TransactionRepositoryImpl(
        gh<_i26.TransactionLocalDataSource>(),
      ),
    );
    gh.factory<_i617.HomeCubit>(
      () => _i617.HomeCubit(
        transactions: gh<_i281.TransactionRepository>(),
        bills: gh<_i844.BillRepository>(),
        accounts: gh<_i248.AccountRepository>(),
        settings: gh<_i220.SettingsRepository>(),
        calculateBalances: gh<_i207.CalculateAccountBalances>(),
        calculateSummary: gh<_i245.CalculateMonthlySummary>(),
        calculateBudget: gh<_i245.CalculateBudget>(),
      ),
    );
    gh.factory<_i1047.TransactionsCubit>(
      () => _i1047.TransactionsCubit(gh<_i281.TransactionRepository>()),
    );
    gh.lazySingleton<_i658.DemoSeeder>(
      () => _i658.DemoSeeder(
        gh<_i281.TransactionRepository>(),
        gh<_i844.BillRepository>(),
        gh<_i248.AccountRepository>(),
        gh<_i220.SettingsRepository>(),
      ),
    );
    gh.factory<_i327.ProfileCubit>(
      () => _i327.ProfileCubit(
        gh<_i220.SettingsRepository>(),
        gh<_i281.TransactionRepository>(),
        gh<_i844.BillRepository>(),
        gh<_i248.AccountRepository>(),
        gh<_i734.BuildTransactionsCsv>(),
      ),
    );
    gh.factory<_i69.AnalyticsCubit>(
      () => _i69.AnalyticsCubit(
        gh<_i281.TransactionRepository>(),
        gh<_i1033.BuildAnalytics>(),
      ),
    );
    gh.factory<_i573.AccountsCubit>(
      () => _i573.AccountsCubit(
        gh<_i248.AccountRepository>(),
        gh<_i281.TransactionRepository>(),
        gh<_i207.CalculateAccountBalances>(),
      ),
    );
    gh.factory<_i489.SearchCubit>(
      () => _i489.SearchCubit(
        gh<_i281.TransactionRepository>(),
        gh<_i220.SettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i75.PayBill>(
      () => _i75.PayBill(
        gh<_i844.BillRepository>(),
        gh<_i281.TransactionRepository>(),
      ),
    );
    gh.factory<_i851.BillsCubit>(
      () => _i851.BillsCubit(gh<_i844.BillRepository>(), gh<_i75.PayBill>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i478.RegisterModule {}
