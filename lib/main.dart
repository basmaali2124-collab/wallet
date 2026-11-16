import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:wallet_app/core/data/demo_seeder.dart';
import 'package:wallet_app/core/di/injection.dart';
import 'package:wallet_app/core/responsive/breakpoints.dart';
import 'package:wallet_app/core/responsive/content_width.dart';
import 'package:wallet_app/core/responsive/responsive_scope.dart';
import 'package:wallet_app/core/router/app_router.dart';
import 'package:wallet_app/core/settings/app_settings_cubit.dart';
import 'package:wallet_app/core/theme/app_theme.dart';
import 'package:wallet_app/features/accounts/domain/account_repository.dart';
import 'package:wallet_app/features/accounts/presentation/cubit/accounts_cubit.dart';
import 'package:wallet_app/features/bills/presentation/cubit/bills_cubit.dart';
import 'package:wallet_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:wallet_app/features/transactions/presentation/cubit/transactions_cubit.dart';
import 'package:wallet_app/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Hive.initFlutter();
  await configureDependencies();
  await getIt<DemoSeeder>().seedIfNeeded();
  await getIt<AccountRepository>().ensureDefaults();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<TransactionsCubit>()),
        BlocProvider(create: (_) => getIt<HomeCubit>()),
        BlocProvider(create: (_) => getIt<AccountsCubit>()),
        BlocProvider(create: (_) => getIt<BillsCubit>()),
        BlocProvider(create: (_) => getIt<AppSettingsCubit>()),
      ],
      child: ResponsiveScope(
        builder: (context, designSize) => ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: false,
          builder: (context, child) =>
              BlocBuilder<AppSettingsCubit, AppSettingsState>(
                builder: (context, s) {
                  Intl.defaultLocale = s.locale.languageCode;
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    routerConfig: AppRouter.router,
                    theme: AppTheme.light,
                    darkTheme: AppTheme.dark,
                    themeMode: s.themeMode,
                    builder: (context, child) => ContentWidth(
                      maxWidth: Breakpoints.appMaxWidth,
                      child: child ?? const SizedBox.shrink(),
                    ),
                    locale: s.locale,
                    supportedLocales: AppLocalizations.supportedLocales,
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                  );
                },
              ),
        ),
      ),
    );
  }
}