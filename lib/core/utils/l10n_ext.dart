import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:wallet_app/l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

 String formatDate(String pattern, DateTime date) => DateFormat(
    pattern,
    Localizations.localeOf(this).languageCode,
  ).format(date);
}