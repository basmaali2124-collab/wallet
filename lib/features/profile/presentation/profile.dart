import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/core/responsive/breakpoints.dart';
import 'package:wallet_app/core/responsive/content_width.dart';
import 'package:wallet_app/core/responsive/responsive_two_pane.dart';
import 'package:wallet_app/core/settings/app_settings_cubit.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/money.dart';
import 'package:wallet_app/core/widgets/amount_dialog.dart';
import 'package:wallet_app/core/widgets/app_dialog.dart';
import 'package:wallet_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:wallet_app/features/profile/presentation/cubit/profile_state.dart';
import 'package:wallet_app/features/profile/presentation/widgets/categories_sheet.dart';
import 'package:wallet_app/features/profile/presentation/widgets/edit_profile_dialog.dart';
import 'package:wallet_app/features/profile/presentation/widgets/profile_card.dart';
import 'package:wallet_app/features/profile/presentation/widgets/settings_group.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  Future<void> _editBudget(BuildContext context, ProfileState s) =>
      editMonthlyBudget(
        context,
        currentCents: s.budgetCents,
        onSave: context.read<ProfileCubit>().setBudget,
      );

  Future<void> _editInitialBalance(BuildContext context, ProfileState s) async {
    final cubit = context.read<ProfileCubit>();
    final cents = await showAmountDialog(
      context,
      title: context.l10n.initialBalance,
      initialCents: s.openingBalanceCents,
      allowZero: true,
    );
    if (cents != null) await cubit.setOpeningBalance(cents);
  }

  Future<void> _editProfile(BuildContext context, ProfileState s) async {
    final cubit = context.read<ProfileCubit>();
    final result = await showEditProfileDialog(
      context,
      name: s.name,
      email: s.email,
    );
    if (result != null) await cubit.updateProfile(result.name, result.email);
  }

  Future<void> _pickLanguage(BuildContext context) async {
    final settings = context.read<AppSettingsCubit>();
    final code = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () => Navigator.pop(ctx, 'en'),
            ),
            ListTile(
              title: const Text('العربية'),
              onTap: () => Navigator.pop(ctx, 'ar'),
            ),
          ],
        ),
      ),
    );
    if (code != null) await settings.setLanguage(code);
  }

  Future<void> _export(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final result = await cubit.exportCsv();
    await Clipboard.setData(ClipboardData(text: result.csv));
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(l10n.csvCopied(result.count))));
  }

  Future<void> _reset(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: l10n.resetDialogTitle,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.reset,
              style: const TextStyle(color: AppColors.expense),
            ),
          ),
        ],
        children: [Text(l10n.resetDialogBody)],
      ),
    );
    if (confirmed != true) return;
    await cubit.resetAll();
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(l10n.allDataCleared)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = context.watch<AppSettingsCubit>().state;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, s) {
            final symbol = Money.symbolFor(s.currency);
            return ContentWidth(
              maxWidth: Breakpoints.maxContentWidth,
              child: ListView(
                padding: AppSpacing.screenHorizontal.copyWith(
                  bottom: AppSpacing.xxxl * 3,
                ),
                children: [
                  SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.profile,
                    style: AppTextStyles.display.copyWith(fontSize: 28),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  ProfileCard(
                    name: s.name,
                    email: s.email,
                    onEdit: () => _editProfile(context, s),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  ResponsiveTwoPane(
                    primaryFlex: 1,
                    secondaryFlex: 1,
                    stackedGap: AppSpacing.lg,
                    primary: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SettingsSectionLabel(l10n.sectionMoney),
                        SettingsGroup(
                          children: [
                            SettingsRow(
                              icon: Icons.credit_card_outlined,
                              label: l10n.accounts,
                              value: '${s.accountCount}  ',
                              showChevron: false,
                            ),
                            SettingsRow(
                              icon: Icons.grid_view_rounded,
                              label: l10n.categories,
                              onTap: () => showCategoriesSheet(context),
                            ),
                            SettingsRow(
                              icon: Icons.schedule_rounded,
                              label: l10n.monthlyBudget,
                              value: Money.format(
                                s.budgetCents,
                                symbol: symbol,
                              ),
                              onTap: () => _editBudget(context, s),
                            ),
                            SettingsRow(
                              icon: Icons.account_balance_wallet_outlined,
                              label: l10n.initialBalance,
                              value: Money.format(
                                s.openingBalanceCents,
                                symbol: symbol,
                              ),
                              onTap: () => _editInitialBalance(context, s),
                            ),
                            SettingsRow(
                              icon: Icons.attach_money_rounded,
                              label: l10n.currency,
                              value: '${s.currency} ',
                              showChevron: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                    secondary: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SettingsSectionLabel(l10n.sectionApp),
                        SettingsGroup(
                          children: [
                            SettingsRow(
                              icon: Icons.dark_mode_outlined,
                              label: l10n.darkMode,
                              trailing: Switch(
                                value: settings.themeMode == ThemeMode.dark,
                                onChanged: context
                                    .read<AppSettingsCubit>()
                                    .setDarkMode,
                              ),
                            ),
                            SettingsRow(
                              icon: Icons.language_rounded,
                              label: l10n.language,
                              value: settings.locale.languageCode == 'ar'
                                  ? 'العربية'
                                  : 'English',
                              onTap: () => _pickLanguage(context),
                            ),
                            SettingsRow(
                              icon: Icons.download_rounded,
                              label: l10n.exportCsv,
                              onTap: () => _export(context),
                            ),
                            SettingsRow(
                              icon: Icons.delete_outline_rounded,
                              label: l10n.resetData,
                              color: AppColors.expense,
                              showChevron: false,
                              onTap: () => _reset(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
