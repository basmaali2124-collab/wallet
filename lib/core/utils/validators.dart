import 'package:flutter/services.dart';
import 'package:wallet_app/l10n/app_localizations.dart';

abstract class Validators {
  static const int nameMin = 2;
  static const int nameMax = 40;
  static const int noteMax = 120;

  static final RegExp _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  static String? name(AppLocalizations l10n, String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return l10n.fieldRequired;
    if (v.length < nameMin) return l10n.nameTooShort;
    return null;
  }

  static String? email(AppLocalizations l10n, String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return l10n.fieldRequired;
    return _email.hasMatch(v) ? null : l10n.invalidEmail;
  }

  static String? amount(AppLocalizations l10n, int cents) =>
      cents > 0 ? null : l10n.amountMustBePositive;

  static List<TextInputFormatter> nameFormatters([int max = nameMax]) => [
    FilteringTextInputFormatter.deny(RegExp(r'^\s')),
    LengthLimitingTextInputFormatter(max),
  ];

  static List<TextInputFormatter> emailFormatters() => [
    FilteringTextInputFormatter.deny(RegExp(r'\s')),
    LengthLimitingTextInputFormatter(60),
  ];

  static List<TextInputFormatter> noteFormatters([int max = noteMax]) => [
    LengthLimitingTextInputFormatter(max),
  ];
}