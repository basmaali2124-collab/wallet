import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/core/models/bill_category.dart';
import 'package:wallet_app/core/models/bill_model.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/l10n_labels.dart';
import 'package:wallet_app/core/utils/money.dart';
import 'package:wallet_app/core/utils/pick_date.dart';
import 'package:wallet_app/core/utils/validators.dart';
import 'package:wallet_app/core/widgets/form_sheet.dart';
import 'package:wallet_app/core/widgets/primary_button.dart';
import 'package:wallet_app/features/bills/presentation/cubit/bills_cubit.dart';
import 'package:wallet_app/features/bills/presentation/widgets/repeat_toggle.dart';
import 'package:wallet_app/features/transactions/data/amount_input.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/amount_display.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/amount_keypad.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/category_date_pills.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/picker_sheet.dart';

class AddBillSheet extends StatefulWidget {
  const AddBillSheet({super.key, this.existing});

  final BillModel? existing;

  static Future<BillModel?> pick(BuildContext context, {BillModel? existing}) =>
      showFormSheet<BillModel>(context, child: AddBillSheet(existing: existing));

  static Future<void> show(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final cubit = context.read<BillsCubit>();

    final bill = await pick(context);
    if (bill == null) return;
    await cubit.add(bill);
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(l10n.billAdded)));
  }

  @override
  State<AddBillSheet> createState() => _AddBillSheetState();
}

class _AddBillSheetState extends State<AddBillSheet> {
  late final TextEditingController _name = TextEditingController(
    text: widget.existing?.name ?? '',
  );
  late final TextEditingController _note = TextEditingController(
    text: widget.existing?.note ?? '',
  );
  final FocusNode _nameFocus = FocusNode();

  late AmountInput _amount = widget.existing == null
      ? const AmountInput()
      : AmountInput(Money.toInput(widget.existing!.amountCents));
  late DateTime _due = DateUtils.dateOnly(
    widget.existing?.dueDate ?? DateTime.now(),
  );
  late BillCategory _category =
      widget.existing?.category ?? BillCategory.internet;
  late bool _recurring = widget.existing?.isRecurring ?? false;

  bool _nameTouched = false;
  bool _amountTouched = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus && !_nameTouched) {
        setState(() => _nameTouched = true);
      }
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _note.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  String? get _nameError =>
      _nameTouched ? Validators.name(context.l10n, _name.text) : null;

  String? get _amountError =>
      _amountTouched ? Validators.amount(context.l10n, _amount.cents) : null;

  bool get _valid =>
      Validators.name(context.l10n, _name.text) == null && !_amount.isZero;

  void _onAmount(AmountInput value) {
    FocusScope.of(context).unfocus();
    setState(() {
      _amount = value;
      _amountTouched = true;
    });
  }

  Future<void> _pickCategory() async {
    FocusScope.of(context).unfocus();
    final l10n = context.l10n;
    final picked = await showPickerSheet<BillCategory>(
      context,
      title: l10n.billType,
      selected: _category,
      items: [
        for (final c in BillCategory.values)
          PickerItem(
            value: c,
            label: c.localized(l10n),
            icon: c.icon,
            color: c.color,
          ),
      ],
    );
    if (picked != null) setState(() => _category = picked);
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();
    final picked = await pickAppDate(context, _due);
    if (picked != null) setState(() => _due = DateUtils.dateOnly(picked));
  }

  void _submit() {
    setState(() {
      _nameTouched = true;
      _amountTouched = true;
    });
    if (!_valid) return;

    final name = _name.text.trim();
    final note = _note.text.trim();
    final existing = widget.existing;

    final BillModel bill = existing == null
        ? BillModel(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            name: name,
            amountCents: _amount.cents,
            dueDate: _due,
            category: _category,
            isRecurring: _recurring,
            note: note.isEmpty ? null : note,
          )
        : existing.copyWith(
            name: name,
            amountCents: _amount.cents,
            dueDate: DateUtils.isSameDay(_due, existing.dueDate) ? null : _due,
            category: _category,
            isRecurring: _recurring,
            note: note,
            clearNote: note.isEmpty,
          );

    Navigator.of(context).pop(bill);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    return FormSheetShell(
      builder: (context, _) => _buildContent(context, keyboardOpen),
    );
  }

  List<Widget> _buildContent(BuildContext context, bool keyboardOpen) {
    final l10n = context.l10n;

    return [
      Text(
        _isEdit ? l10n.editBill : l10n.newBill,
        style: AppTextStyles.title,
      ),
      SizedBox(height: AppSpacing.lg),
      GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AmountDisplay(
          symbol: r'$',
          formatted: _amount.formatted,
          error: _amountError,
        ),
      ),
      SizedBox(height: AppSpacing.lg),
      TextField(
        controller: _name,
        focusNode: _nameFocus,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        inputFormatters: Validators.nameFormatters(),
        decoration: InputDecoration(
          labelText: l10n.billName,
          errorText: _nameError,
        ),
        onChanged: (_) => setState(() => _nameTouched = true),
      ),
      SizedBox(height: AppSpacing.md),
      CategoryDatePills(
        categoryIcon: _category.icon,
        categoryLabel: _category.localized(l10n),
        dateLabel: context.formatDate('d MMM yyyy', _due),
        onCategory: _pickCategory,
        onDate: _pickDate,
      ),
      SizedBox(height: AppSpacing.sm),
      RepeatToggle(
        label: l10n.repeatsMonthly,
        value: _recurring,
        onChanged: (v) => setState(() => _recurring = v),
      ),
      SizedBox(height: AppSpacing.md),
      TextField(
        controller: _note,
        textCapitalization: TextCapitalization.sentences,
        inputFormatters: Validators.noteFormatters(),
        maxLines: 2,
        minLines: 1,
        decoration: InputDecoration(labelText: l10n.noteOptional),
      ),
      SizedBox(height: AppSpacing.md),
      if (!keyboardOpen) ...[
        AmountKeypad(value: _amount, onChanged: _onAmount),
        SizedBox(height: AppSpacing.lg),
      ],
      PrimaryButton(
        label: _isEdit ? l10n.saveChanges : l10n.addBill,
        onPressed: _valid ? _submit : null,
      ),
    ];
  }
}