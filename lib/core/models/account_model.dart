abstract class AccountIds {
  static const main = 'main';
  static const guest = 'guest';
}

class AccountModel {
  final String id;
  final String name;
  final int openingBalanceCents;
  final String currency;

  const AccountModel({
    required this.id,
    required this.name,
    this.openingBalanceCents = 0,
    this.currency = 'USD',
  });

  AccountModel copyWith({
    String? name,
    int? openingBalanceCents,
    String? currency,
  }) => AccountModel(
    id: id,
    name: name ?? this.name,
    openingBalanceCents: openingBalanceCents ?? this.openingBalanceCents,
    currency: currency ?? this.currency,
  );
}