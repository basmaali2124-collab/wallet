import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wallet_app/core/models/transaction_model.dart';

abstract class Money {
  static final NumberFormat _whole = NumberFormat('#,##0', 'en_US');

  static const Map<String, String> _symbols = {
    'USD': r'$',
    'EUR': '€',
    'GBP': '£',
    'EGP': 'E£',
    'SAR': 'SAR ',
    'AED': 'AED ',
  };

  static String symbolFor(String currency) =>
      _symbols[currency] ?? '$currency ';

  static ({String main, String cents}) parts(
    int cents, {
    String symbol = r'$',
  }) {
    final abs = cents.abs();
    final fraction = (abs % 100).toString().padLeft(2, '0');
    final sign = cents < 0 ? '\u2212' : '';
    return (
      main: '$sign$symbol${_whole.format(abs ~/ 100)}',
      cents: '.$fraction',
    );
  }

  static String format(int cents, {String symbol = r'$'}) {
    final p = parts(cents, symbol: symbol);
    return '${p.main}${p.cents}';
  }

  static String signed(
    int cents,
    TransactionType type, {
    String symbol = r'$',
  }) => switch (type) {
    TransactionType.income => '+${format(cents, symbol: symbol)}',
    TransactionType.expense => '\u2212${format(cents, symbol: symbol)}',
    TransactionType.transfer => format(cents, symbol: symbol),
  };

  static String plain(int cents) {
    final abs = cents.abs();
    final sign = cents < 0 ? '-' : '';
    return '$sign${abs ~/ 100}.${(abs % 100).toString().padLeft(2, '0')}';
  }

  static String toInput(int cents) =>
      cents % 100 == 0 ? '${cents ~/ 100}' : plain(cents);

  static int parse(String text) {
    final clean = text.replaceAll(',', '').trim();
    if (clean.isEmpty) return 0;
    final parts = clean.split('.');
    final whole = int.tryParse(parts[0].isEmpty ? '0' : parts[0]) ?? 0;
    final fraction = parts.length > 1
        ? int.tryParse(parts[1].padRight(2, '0').substring(0, 2)) ?? 0
        : 0;
    return whole * 100 + fraction;
  }

  static List<TextInputFormatter> get inputFormatters => [
    FilteringTextInputFormatter.allow(RegExp(r'^\d{0,9}\.?\d{0,2}')),
  ];
}