import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet_app/core/di/injection.dart';
import 'package:wallet_app/core/widgets/main_shell.dart';
import 'package:wallet_app/features/analytics/presentation/analytics.dart';
import 'package:wallet_app/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:wallet_app/features/bills/presentation/bills.dart';
import 'package:wallet_app/features/home/presentation/home.dart';
import 'package:wallet_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:wallet_app/features/profile/presentation/profile.dart';
import 'package:wallet_app/features/transactions/presentation/search/search_cubit.dart';
import 'package:wallet_app/features/transactions/presentation/search/search_screen.dart';
import 'package:wallet_app/features/transactions/presentation/transaction/transaction.dart';
import 'package:wallet_app/core/responsive/breakpoints.dart';
import 'package:wallet_app/core/responsive/content_width.dart';

abstract class AppRoutes {
  static const home = '/';
  static const transaction = '/transaction';
  static const analytics = '/analytics';
  static const profile = '/profile';
  static const bills = '/bills';
  static const search = '/search';
}

abstract class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const Home(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.transaction,
                builder: (context, state) => const Transaction(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.analytics,
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<AnalyticsCubit>(),
                  child: const Analytics(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<ProfileCubit>(),
                  child: const Profile(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.bills,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ContentWidth(child: Bills()),
      ),
      GoRoute(
        path: AppRoutes.search,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<SearchCubit>(),
          child: const ContentWidth(
            maxWidth: Breakpoints.narrowContentWidth,
            child: SearchScreen(),
          ),
        ),
      ),
    ],
  );
}