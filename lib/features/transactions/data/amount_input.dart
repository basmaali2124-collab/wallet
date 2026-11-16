import 'package:intl/intl.dart';

class AmountInput {
  static const int maxDigits = 9;
  static const int maxDecimals = 2;

  final String raw;
  const AmountInput([this.raw = '']);

  bool get hasDot => raw.contains('.');
  bool get isZero => cents == 0;

  int get _digitCount => raw.replaceAll('.', '').length;
  int get _decimalCount => hasDot ? raw.length - raw.indexOf('.') - 1 : 0;

  int get cents {
    if (raw.isEmpty) return 0;
    final parts = raw.split('.');
    final whole = int.parse(parts[0].isEmpty ? '0' : parts[0]);
    final fraction = parts.length > 1 ? parts[1].padRight(2, '0') : '00';
    return whole * 100 + int.parse(fraction);
  }

  String get formatted {
    final parts = raw.isEmpty ? ['0'] : raw.split('.');
    final whole = NumberFormat(
      '#,##0',
    ).format(int.parse(parts[0].isEmpty ? '0' : parts[0]));
    return hasDot ? '$whole.${parts.length > 1 ? parts[1] : ''}' : whole;
  }

  AmountInput press(String key) {
    if (key == '.') {
      if (hasDot) return this;
      return AmountInput(raw.isEmpty ? '0.' : '$raw.');
    }
    if (key.length != 1 || !'0123456789'.contains(key)) return this;
    if (hasDot && _decimalCount >= maxDecimals) return this;
    if (raw == '0') return AmountInput(key);
    if (_digitCount >= maxDigits) return this;
    return AmountInput('$raw$key');
  }

  AmountInput backspace() =>
      raw.isEmpty ? this : AmountInput(raw.substring(0, raw.length - 1));

  AmountInput clear() => const AmountInput();
}
