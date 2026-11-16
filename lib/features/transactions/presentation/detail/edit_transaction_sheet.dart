import 'package:flutter/material.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/l10n_labels.dart';
import 'package:wallet_app/core/utils/money.dart';
import 'package:wallet_app/core/utils/pick_date.dart';
import 'package:wallet_app/core/utils/validators.dart';
import 'package:wallet_app/core/widgets/amount_field.dart';
import 'package:wallet_app/core/widgets/app_sheet.dart';
import 'package:wallet_app/core/widgets/category_chip.dart';
import 'package:wallet_app/core/widgets/field_row.dart';
import 'package:wallet_app/core/widgets/primary_button.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/dropdown_pill.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/categories_for.dart';
Future<TransactionModel?> showEditTransactionSheet(
  BuildContext context,
  TransactionModel tx,
) => showAppSheet<TransactionModel>(
  context,
  builder: (_) => _EditTransactionSheet(tx: tx),
);

class _EditTransactionSheet extends StatefulWidget {
  const _EditTransactionSheet({required this.tx});
  final TransactionModel tx;

  @override
  State<_EditTransactionSheet> createState() => _EditTransactionSheetState();
}

class _EditTransactionSheetState extends State<_EditTransactionSheet> {
  late final TextEditingController _title = TextEditingController(
    text: widget.tx.title,
  );
  late final TextEditingController _amount = TextEditingController(
    text: Money.toInput(widget.tx.amountCents),
  );
  late final TextEditingController _note = TextEditingController(
    text: widget.tx.note ?? '',
  );
  late DateTime _date = widget.tx.date;
  late TransactionCategory _category = widget.tx.category;

  late final List<TransactionCategory> _options = () {
    final base = categoriesFor(widget.tx.type);
    if (base.isEmpty) return const <TransactionCategory>[];
    return base.contains(widget.tx.category)
        ? base
        : [widget.tx.category, ...base];
  }();

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  int get _cents => Money.parse(_amount.text);

  bool get _valid =>
      Validators.name(context.l10n, _title.text) == null && _cents > 0;

  Future<void> _pickDate() async {
    final picked = await pickAppDate(context, _date);
    if (picked == null) return;
    setState(() => _date = _date.withDate(picked));
  }

  void _submit() {
    final note = _note.text.trim();
    Navigator.of(context).pop(
      widget.tx.copyWith(
        title: _title.text.trim(),
        amountCents: _cents,
        category: _category,
        date: _date,
        note: note,
        clearNote: note.isEmpty,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppSheetBody(
      children: [
        Text(l10n.editTransactionTitle, style: AppTextStyles.title),
        SizedBox(height: AppSpacing.lg),
        FieldRow(
          flex: const [3, 2],
          children: [
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: Validators.nameFormatters(),
              decoration: InputDecoration(
                labelText: l10n.titleLabel,
                errorText: Validators.name(l10n, _title.text),
              ),
              onChanged: (_) => setState(() {}),
            ),
            AmountField(
              controller: _amount,
              label: l10n.amount,
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        DropdownPill(
          icon: Icons.calendar_today_outlined,
          label: context.formatDate('d MMM yyyy', _date),
          onTap: _pickDate,
        ),
        SizedBox(height: AppSpacing.md),
        TextField(
          controller: _note,
          textCapitalization: TextCapitalization.sentences,
          inputFormatters: Validators.noteFormatters(),
          maxLines: 2,
          decoration: InputDecoration(labelText: l10n.noteOptional),
        ),
        if (_options.isNotEmpty) ...[
          SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final c in _options)
                CategoryChip(
                  label: c.localized(l10n),
                  icon: c.icon,
                  color: c.color,
                  selected: _category == c,
                  onTap: () => setState(() => _category = c),
                ),
            ],
          ),
        ],
        SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          label: l10n.saveChanges,
          onPressed: _valid ? _submit : null,
        ),
      ],
    );
  }
}
