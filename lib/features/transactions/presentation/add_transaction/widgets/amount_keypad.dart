import 'package:flutter/material.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/features/transactions/data/amount_input.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/numeric_keypad.dart';

class AmountKeypad extends StatelessWidget {
  const AmountKeypad({
    super.key,
    required this.value,
    required this.onChanged,
    this.keyHeight = 52,
  });

  final AmountInput value;
  final ValueChanged<AmountInput> onChanged;
  final double keyHeight;

  static double heightFor(double keyHeight) =>
      4 * keyHeight + 3 * AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: heightFor(keyHeight),
      child: NumericKeypad(
        onKeyPressed: (k) => onChanged(value.press(k)),
        onBackspace: () => onChanged(value.backspace()),
        onClear: () => onChanged(value.clear()),
      ),
    );
  }
}