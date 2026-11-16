import 'package:flutter/material.dart';
import 'package:wallet_app/core/utils/money.dart';

class AmountField extends StatelessWidget {
  const AmountField({
    super.key,
    required this.controller,
    this.label,
    this.onChanged,
    this.autofocus = false,
    this.symbol = r'$',
  });

  final TextEditingController controller;
  final String? label;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: Money.inputFormatters,
      decoration: InputDecoration(labelText: label, prefixText: '$symbol '),
      onChanged: onChanged,
    );
  }
}