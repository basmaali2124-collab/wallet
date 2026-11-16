import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet_app/core/responsive/breakpoints.dart';
import 'package:wallet_app/core/responsive/content_width.dart';
import 'package:wallet_app/core/widgets/app_bottom_nav.dart';
import 'package:wallet_app/core/widgets/app_side_nav.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/add_transaction_sheet.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  void _onTap(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    void onAdd() => AddTransactionSheet.show(context);

    if (!Breakpoints.useSideNav(context)) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.narrowContentWidth,
            ),
            child: AppBottomNavBar(
              currentIndex: navigationShell.currentIndex,
              onTap: _onTap,
              onAddPressed: onAdd,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          AppSideNav(
            currentIndex: navigationShell.currentIndex,
            onTap: _onTap,
            onAddPressed: onAdd,
          ),
          Expanded(child: ContentWidth(child: navigationShell)),
        ],
      ),
    );
  }
}