// lib/features/settings/providers/settings_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_constants.dart';

class SettingsState {
  final Locale locale;
  final ThemeMode themeMode;
  final String currency;
  const SettingsState({this.locale = const Locale('fr'), this.themeMode = ThemeMode.light, this.currency = 'TND'});
  SettingsState copyWith({Locale? locale, ThemeMode? themeMode, String? currency}) =>
      SettingsState(locale: locale ?? this.locale, themeMode: themeMode ?? this.themeMode, currency: currency ?? this.currency);
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) { _load(); }

  Future<void> _load() async {
    final box = await Hive.openBox(AppConstants.settingsBox);
    final lang = box.get(AppConstants.keyLanguage, defaultValue: 'fr') as String;
    final dark = box.get(AppConstants.keyTheme, defaultValue: false) as bool;
    final currency = box.get(AppConstants.keyCurrency, defaultValue: 'TND') as String;
    state = SettingsState(locale: Locale(lang), themeMode: dark ? ThemeMode.dark : ThemeMode.light, currency: currency);
  }

  Future<void> setLanguage(String lang) async {
    final box = await Hive.openBox(AppConstants.settingsBox);
    await box.put(AppConstants.keyLanguage, lang);
    state = state.copyWith(locale: Locale(lang));
  }

  Future<void> setDarkMode(bool dark) async {
    final box = await Hive.openBox(AppConstants.settingsBox);
    await box.put(AppConstants.keyTheme, dark);
    state = state.copyWith(themeMode: dark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setCurrency(String currency) async {
    final box = await Hive.openBox(AppConstants.settingsBox);
    await box.put(AppConstants.keyCurrency, currency);
    state = state.copyWith(currency: currency);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((_) => SettingsNotifier());
