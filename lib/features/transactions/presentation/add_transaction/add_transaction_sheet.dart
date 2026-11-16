import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/core/models/account_model.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/l10n_labels.dart';
import 'package:wallet_app/core/utils/money.dart';
import 'package:wallet_app/core/utils/pick_date.dart';
import 'package:wallet_app/core/widgets/form_sheet.dart';
import 'package:wallet_app/core/widgets/primary_button.dart';
import 'package:wallet_app/core/widgets/segmented_tabs.dart';
import 'package:wallet_app/features/accounts/presentation/cubit/accounts_cubit.dart';
import 'package:wallet_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:wallet_app/features/transactions/data/amount_input.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/categories_for.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/transfer_accounts.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/amount_display.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/amount_keypad.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/budget_alert_slot.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/category_date_pills.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/picker_sheet.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/transfer_pills.dart';
import 'package:wallet_app/features/transactions/presentation/cubit/transactions_cubit.dart';

class AddTransactionSheet extends StatefulWidget {
  final int budgetUsedPercent;
  final List<AccountModel> accounts;
  final Map<String, int> balances;

  const AddTransactionSheet({
    super.key,
    required this.accounts,
    this.balances = const {},
    this.budgetUsedPercent = 0,
  });

  static Future<void> show(
    BuildContext context, {
    int? budgetUsedPercent,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final cubit = context.read<TransactionsCubit>();
    final accountsState = context.read<AccountsCubit>().state;
    final accounts = accountsState.accounts;
    if (accounts.isEmpty) return;
    final usedPercent =
        budgetUsedPercent ??
        context.read<HomeCubit>().state.budgetPercent.round();

    final tx = await showFormSheet<TransactionModel>(
      context,
      child: AddTransactionSheet(
        accounts: accounts,
        balances: accountsState.balances,
        budgetUsedPercent: usedPercent,
      ),
    );

    if (tx == null) return;
    await cubit.add(tx);
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(l10n.transactionAdded)));
  }

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  int _tab = 1;
  AmountInput _amount = const AmountInput();
  late TransactionCategory _category = categoriesFor(_type).first;
  late String _fromId = widget.accounts.first.id;
  late String _toId = widget.accounts.length > 1
      ? widget.accounts[1].id
      : widget.accounts.first.id;
  late String _accountId = _defaultAccountId;
  DateTime _date = DateTime.now();
  bool _alertDismissed = false;

  TransactionType get _type => TransactionType.values[_tab];
  bool get _isTransfer => _type == TransactionType.transfer;
  bool get _showAlert =>
      _type == TransactionType.expense &&
      widget.budgetUsedPercent >= 50 &&
      !_alertDismissed;

  String get _sourceId => _isTransfer ? _fromId : _accountId;

  String get _symbol {
    for (final a in widget.accounts) {
      if (a.id == _sourceId) return Money.symbolFor(a.currency);
    }
    return r'$';
  }

  String? get _error {
    if (_isTransfer && _fromId == _toId) {
      return context.l10n.chooseDifferentAccounts;
    }
    final spends = _type == TransactionType.expense || _isTransfer;
    if (spends && _amount.cents > (widget.balances[_sourceId] ?? 0)) {
      return context.l10n.insufficientBalance;
    }
    return null;
  }

  bool get _canSubmit => !_amount.isZero && _error == null;

  String _nameOf(String id) {
    for (final a in widget.accounts) {
      if (a.id == id) return accountName(context.l10n, a);
    }
    return context.l10n.accountUnknown;
  }

  String get _defaultAccountId =>
      widget.accounts.any((a) => a.id == AccountIds.main)
      ? AccountIds.main
      : widget.accounts.first.id;

  void _onTab(int index) {
    setState(() {
      _tab = index;
      final options = categoriesFor(_type);
      if (options.isNotEmpty && !options.contains(_category)) {
        _category = options.first;
      }
    });
  }

  Future<void> _pickCategory() async {
    final l10n = context.l10n;
    final picked = await showPickerSheet<TransactionCategory>(
      context,
      title: l10n.category,
      selected: _category,
      items: [
        for (final c in categoriesFor(_type))
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

  Future<String?> _pickAccount(String title, String selectedId) {
    final l10n = context.l10n;
    return showPickerSheet<String>(
      context,
      title: title,
      selected: selectedId,
      items: [
        for (final a in widget.accounts)
          PickerItem(
            value: a.id,
            label: accountName(l10n, a),
            icon: Icons.account_balance_wallet_outlined,
          ),
      ],
    );
  }

  Future<void> _pickTransferAccount({required bool from}) async {
    final l10n = context.l10n;
    final picked = await _pickAccount(
      from ? l10n.fromAccount : l10n.toAccount,
      from ? _fromId : _toId,
    );
    if (picked == null) return;
    final result = applyTransferPick(
      from: from,
      picked: picked,
      fromId: _fromId,
      toId: _toId,
    );
    setState(() {
      _fromId = result.from;
      _toId = result.to;
    });
  }

  Future<void> _pickDate() async {
    final picked = await pickAppDate(context, _date);
    if (picked != null) {
      setState(() => _date = _date.withDate(picked));
    }
  }

  void _submit() {
    final l10n = context.l10n;
    final transfer = _isTransfer;
    final tx = TransactionModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: _type,
      amountCents: _amount.cents,
      category: transfer ? TransactionCategory.transfer : _category,
      title: transfer
          ? l10n.transferTo(_nameOf(_toId))
          : _category.localized(l10n),
      note: transfer
          ? l10n.transferFromTo(_nameOf(_fromId), _nameOf(_toId))
          : null,
      date: _date,
      accountId: transfer ? _fromId : _accountId,
      toAccountId: transfer ? _toId : null,
      createdAt: DateTime.now(),
    );
    Navigator.of(context).pop(tx);
  }

  @override
  Widget build(BuildContext context) =>
      FormSheetShell(builder: _buildContent);

  List<Widget> _buildContent(BuildContext context, double availableHeight) {
    final l10n = context.l10n;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final error = _error;

    final reserved =
        340.0 +
        (_showAlert ? 76 : 0) +
        (_isTransfer ? 56 : 0) +
        bottomInset;
    final keyHeight = ((availableHeight - reserved) / 4 - AppSpacing.sm)
        .clamp(48.0, 68.0);

    final dateLabel = context.formatDate('d MMM yyyy', _date);

    return [
      SegmentedTabs(
        labels: [for (final t in TransactionType.values) t.localized(l10n)],
        selectedIndex: _tab,
        onChanged: _onTab,
      ),
      BudgetAlertSlot(
        visible: _showAlert,
        percent: widget.budgetUsedPercent,
        onDismiss: () => setState(() => _alertDismissed = true),
      ),
      SizedBox(height: AppSpacing.lg),
      AmountDisplay(
        symbol: _symbol,
        formatted: _amount.formatted,
        error: error,
      ),
      SizedBox(height: AppSpacing.lg),
      if (_isTransfer)
        TransferPills(
          fromName: _nameOf(_fromId),
          toName: _nameOf(_toId),
          dateLabel: dateLabel,
          onFrom: () => _pickTransferAccount(from: true),
          onTo: () => _pickTransferAccount(from: false),
          onDate: _pickDate,
        )
      else
        CategoryDatePills(
          categoryIcon: _category.icon,
          categoryLabel: _category.localized(l10n),
          dateLabel: dateLabel,
          onCategory: _pickCategory,
          onDate: _pickDate,
        ),
      SizedBox(height: AppSpacing.md),
      AmountKeypad(
        value: _amount,
        keyHeight: keyHeight,
        onChanged: (v) => setState(() => _amount = v),
      ),
      SizedBox(height: AppSpacing.lg),
      PrimaryButton(
        label: l10n.addTransaction,
        onPressed: _canSubmit ? _submit : null,
      ),
    ];
  }
}