import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet_app/core/data/settings_repository.dart';

class AppSettingsState {
  final ThemeMode themeMode;
  final Locale locale;
  const AppSettingsState({required this.themeMode, required this.locale});
}

@lazySingleton
class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit(this._settings)
    : super(AppSettingsState(
        themeMode: _settings.darkMode ? ThemeMode.dark : ThemeMode.light,
        locale: Locale(_settings.languageCode),
      ));

  final SettingsRepository _settings;

  Future<void> setDarkMode(bool on) async {
    await _settings.setDarkMode(on);
    emit(AppSettingsState(
      themeMode: on ? ThemeMode.dark : ThemeMode.light,
      locale: state.locale,
    ));
  }

  Future<void> setLanguage(String code) async {
    await _settings.setLanguageCode(code);
    emit(AppSettingsState(themeMode: state.themeMode, locale: Locale(code)));
  }
}