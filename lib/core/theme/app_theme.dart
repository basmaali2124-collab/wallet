import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/responsive/breakpoints.dart';

abstract class AppTheme {
  static ThemeData get light => _build(AppPalette.light, Brightness.light);
  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: brightness,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          surface: p.background,
          onSurface: p.textPrimary,
          outline: p.border,
          error: AppColors.expense,
        );

    final textTheme = AppTextStyles.textTheme
        .apply(bodyColor: p.textPrimary, displayColor: p.textPrimary)
        .copyWith(
          displayMedium: AppTextStyles.balance,
          bodySmall: AppTextStyles.caption,
          labelMedium: AppTextStyles.caption,
          labelSmall: AppTextStyles.caption,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [p],
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: p.background,
      textTheme: textTheme,
      dividerTheme: DividerThemeData(color: p.border),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.title.copyWith(color: p.textPrimary),
        iconTheme: IconThemeData(color: p.textPrimary),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: p.background,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardBorder,
          side: BorderSide(color: p.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.pillBorder),
          textStyle: AppTextStyles.body,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: Size(AppSpacing.minTapTarget, AppSpacing.minTapTarget),
          textStyle: AppTextStyles.body.copyWith(fontSize: 14),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.surface,
        selectedColor: p.chipSelected,
        disabledColor: p.surface,
        side: BorderSide.none,
        showCheckmark: false,
        elevation: 0,
        pressElevation: 0,
        labelStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        secondaryLabelStyle: AppTextStyles.body.copyWith(color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.pillBorder),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
        border: OutlineInputBorder(
          borderRadius: AppRadius.pillBorder,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.pillBorder,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.pillBorder,
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.pillBorder,
          borderSide: const BorderSide(color: AppColors.expense),
        ),
      ),
            bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        showDragHandle: true,
        dragHandleColor: p.border,
        constraints: const BoxConstraints(
          maxWidth: Breakpoints.narrowContentWidth,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.chipSelected,
        contentTextStyle: AppTextStyles.body.copyWith(color: Colors.white),
        actionTextColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.tileBorder),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTextStyles.title.copyWith(color: p.textPrimary),
        contentTextStyle: AppTextStyles.caption,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardBorder),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : p.border,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: p.surface,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.primary,
        titleTextStyle: AppTextStyles.body.copyWith(color: p.textPrimary),
        subtitleTextStyle: AppTextStyles.caption,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.tileBorder),
      ),
    );
  }
}