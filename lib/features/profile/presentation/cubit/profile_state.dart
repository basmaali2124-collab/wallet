import 'package:wallet_app/core/data/settings_repository.dart';
import 'package:wallet_app/core/models/account_model.dart';

class ProfileState {
  final int budgetCents;
  final int openingBalanceCents; 
  final int accountCount;
  final String currency;
  final String name;
  final String email;

  const ProfileState({
    required this.budgetCents,
    required this.openingBalanceCents,
    required this.accountCount,
    required this.currency,
    required this.name,
    required this.email,
  });

  factory ProfileState.from(SettingsRepository s, List<AccountModel> accounts) {
    AccountModel? main;
    for (final a in accounts) {
      if (a.id == AccountIds.main) main = a;
    }
    return ProfileState(
      budgetCents: s.monthlyBudgetCents,
      openingBalanceCents: main?.openingBalanceCents ?? 0,
      accountCount: accounts.length,
      currency: main?.currency ?? 'USD',
      name: s.profileName,
      email: s.profileEmail,
    );
  }
}