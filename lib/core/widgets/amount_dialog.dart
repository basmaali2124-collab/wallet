import 'package:flutter/material.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/money.dart';
import 'package:wallet_app/core/widgets/amount_field.dart';
import 'package:wallet_app/core/widgets/app_dialog.dart';

Future<int?> showAmountDialog(
  BuildContext context, {
  required String title,
  required int initialCents,
  bool allowZero = false,
}) => showDialog<int>(
  context: context,
  builder: (_) => _AmountDialog(
    title: title,
    initialCents: initialCents,
    allowZero: allowZero,
  ),
);

Future<void> editMonthlyBudget(
  BuildContext context, {
  required int currentCents,
  required Future<void> Function(int cents) onSave,
}) async {
  final cents = await showAmountDialog(
    context,
    title: context.l10n.monthlyBudget,
    initialCents: currentCents,
  );
  if (cents != null) await onSave(cents);
}

class _AmountDialog extends StatefulWidget {
  const _AmountDialog({
    required this.title,
    required this.initialCents,
    required this.allowZero,
  });

  final String title;
  final int initialCents;
  final bool allowZero;

  @override
  State<_AmountDialog> createState() => _AmountDialogState();
}

class _AmountDialogState extends State<_AmountDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: Money.toInput(widget.initialCents),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _cents => Money.parse(_controller.text);
  bool get _valid => widget.allowZero || _cents > 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppDialog(
      title: widget.title,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: _valid ? () => Navigator.of(context).pop(_cents) : null,
          child: Text(l10n.save),
        ),
      ],
      children: [
        AmountField(
          controller: _controller,
          autofocus: true,
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }
}