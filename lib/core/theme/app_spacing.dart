import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';

abstract class AppScale {
  static double w(num v) => v.w;
  static double r(num v) => v.r;
  static double h(num v) => v.h;
}

abstract class AppSpacing {
  static double get xs => AppScale.w(4);
  static double get sm => AppScale.w(8);
  static double get md => AppScale.w(12);
  static double get lg => AppScale.w(16);
  static double get xl => AppScale.w(20);
  static double get xxl => AppScale.w(24);
  static double get xxxl => AppScale.w(32);

  static EdgeInsets get screenPadding =>
      EdgeInsets.symmetric(horizontal: xl, vertical: xl);

  static EdgeInsets get screenHorizontal =>
      EdgeInsets.symmetric(horizontal: xl);

  static double get minTapTarget => AppScale.r(44);

  static double get badge => AppScale.r(8);
}

abstract class AppRadius {
  static BorderRadius get pillBorder =>
      BorderRadius.circular(AppScale.r(28));
  static BorderRadius get cardBorder =>
      BorderRadius.circular(AppScale.r(20));
  static BorderRadius get tileBorder =>
      BorderRadius.circular(AppScale.r(16));
}

abstract class AppBorders {
  static BorderSide side(BuildContext context) =>
      BorderSide(color: context.palette.border);

  static Border all(BuildContext context) =>
      Border.all(color: context.palette.border);
}

abstract class AppShadows {
  static List<BoxShadow> soft(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.2),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get balanceCard => soft(AppColors.cardGradientEnd);
  static List<BoxShadow> get fab => soft(AppColors.primary);
}