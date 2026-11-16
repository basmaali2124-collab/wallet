import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SettingsRepository {
  SettingsRepository(this._box);
  final Box _box;

  static const defaultBudgetCents = 250000;
  static const defaultName = 'Garcia';
  static const defaultEmail = 'garcia@email.com';

  Stream<void> get changes => _box.watch().map((_) {});

  bool get isSeeded => _box.get('seeded', defaultValue: false) as bool;
  Future<void> markSeeded() => _box.put('seeded', true);

  int get monthlyBudgetCents =>
      _box.get('budget', defaultValue: defaultBudgetCents) as int;
  Future<void> setMonthlyBudget(int cents) => _box.put('budget', cents);

  bool get hideBalance => _box.get('hideBalance', defaultValue: false) as bool;
  Future<void> setHideBalance(bool v) => _box.put('hideBalance', v);

  bool get darkMode => _box.get('darkMode', defaultValue: false) as bool;
  Future<void> setDarkMode(bool v) => _box.put('darkMode', v);

  String get languageCode => _box.get('lang', defaultValue: 'en') as String;
  Future<void> setLanguageCode(String c) => _box.put('lang', c);

  String get profileName =>
      _box.get('profileName', defaultValue: defaultName) as String;
  String get profileEmail =>
      _box.get('profileEmail', defaultValue: defaultEmail) as String;
  Future<void> setProfile(String name, String email) =>
      _box.putAll({'profileName': name, 'profileEmail': email});

  List<String> get recentSearches =>
      (_box.get('recentSearches', defaultValue: const <String>[]) as List)
          .cast<String>();
  Future<void> setRecentSearches(List<String> values) =>
      _box.put('recentSearches', values);

   Future<void> resetPreferences() => _box.putAll({
    'budget': defaultBudgetCents,
    'hideBalance': false,
    'recentSearches': <String>[],
  });
}