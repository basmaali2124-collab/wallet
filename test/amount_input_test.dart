import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_app/features/transactions/data/amount_input.dart';

AmountInput typeKeys(String keys) {
  var input = const AmountInput();
  for (final key in keys.split('')) {
    input = input.press(key);
  }
  return input;
}

void main() {
  test('empty input is zero', () {
    expect(const AmountInput().cents, 0);
  });

  test('whole number to cents', () {
    expect(typeKeys('12').cents, 1200);
  });

  test('decimal to cents', () {
    expect(typeKeys('12.5').cents, 1250);
    expect(typeKeys('12.05').cents, 1205);
  });

  test('leading dot becomes 0.', () {
    expect(typeKeys('.5').cents, 50);
  });

  test('max 2 decimals', () {
    expect(typeKeys('1.234').raw, '1.23');
  });

  test('max 9 digits', () {
    expect(typeKeys('1234567890').raw, '123456789');
  });

  test('second dot is ignored', () {
    expect(typeKeys('1.2.3').raw, '1.23');
  });

  test('no leading zeros', () {
    expect(typeKeys('007').raw, '7');
  });

  test('backspace removes last digit', () {
    expect(typeKeys('12').backspace().raw, '1');
  });

  test('clear empties the input', () {
    expect(typeKeys('12').clear().raw, '');
  });

  test('formatted adds commas', () {
    expect(typeKeys('1234567').formatted, '1,234,567');
  });
}
