import 'package:flutter/widgets.dart';

abstract class Breakpoints {
  static const double designWidth = 390;
  static const double maxScaleWidth = 430;
  static const double twoPane = 720;
  static const double sideNav = 900;
  static const double appMaxWidth = 1200;
  static const double maxContentWidth = 1100;
  static const double narrowContentWidth = 640;

  static bool useSideNav(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= sideNav;

  static int columnsFor(double availableWidth, {int maxColumns = 2}) {
    final cols = availableWidth >= twoPane ? 2 : 1;
    return cols > maxColumns ? maxColumns : cols;
  }
}
