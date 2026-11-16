import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet_app/core/theme/app_colors.dart';

abstract class AppTextStyles {
  static const String fontFamily = 'Inter';

  static TextStyle get display =>
      GoogleFonts.inter(fontSize: 48.sp, fontWeight: FontWeight.w700);

  static TextStyle get balance => GoogleFonts.inter(
    fontSize: 40.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get title =>
      GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w600);

  static TextStyle get body =>
      GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500);

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: display,
    displayMedium: balance,
    titleLarge: title,
    titleMedium: body,
    bodyLarge: body,
    bodyMedium: body,
    bodySmall: caption,
    labelLarge: body,
    labelMedium: caption,
    labelSmall: caption,
  );
}