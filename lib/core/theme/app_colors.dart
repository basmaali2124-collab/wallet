import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color(0xFF4338F5);
  static const Color cardGradientStart = Color(0xFF0A0F2C);
  static const Color cardGradientEnd = Color(0xFF2B3FD6);
  static const Color chipSelected = Color(0xFF1C1C1E);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F7);
  static const Color border = Color(0xFFEDEDF0);
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF8A8A8E);
  static const Color income = Color(0xFF3DAA6E);
  static const Color expense = Color(0xFFE5533D);
  static const Color info = Color(0xFF5AB4F0);
  static const Color shopping = Color(0xFF3B5BDB);
  static const Color foodAndDrink = Color(0xFF5BAE7F);
  static const Color subscription = Color(0xFFF5C451);
  static const Color education = Color(0xFFE8603C);
  static const Color others = Color(0xFFD1D5DB);
  static const Color bills = Color(0xFF8E5BD9);
  static const Color darkBackground = Color(0xFF0E0E10);
static const Color darkSurface = Color(0xFF1C1C1E);
static const Color darkBorder = Color(0xFF2C2C2E);
static const Color darkTextPrimary = Color(0xFFF2F2F7);
static const Color darkChipSelected = Color(0xFF3A3A3C);
  static const onCard = Color(0xFFFFFFFF);
  static const onCardMuted = Color(0xB3FFFFFF);
  static const onCardDivider = Color(0x33FFFFFF); 
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardGradientStart, cardGradientEnd],
  );
}
