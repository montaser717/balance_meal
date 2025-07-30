import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../common/app_strings.dart';

class SettingsState {
  final ThemeMode themeMode;
  final Locale locale;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('de'),
  });

  SettingsState copyWith({ThemeMode? themeMode, Locale? locale}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final Box _box;

  SettingsCubit(this._box) : super(const SettingsState()) {
    _load();
  }

  void _load() {
    final themeIndex = _box.get('themeMode', defaultValue: ThemeMode.system.index) as int;
    final localeCode = _box.get('locale', defaultValue: 'de') as String;
    final locale = Locale(localeCode);
    AppStrings.updateLocale(locale);
    emit(SettingsState(themeMode: ThemeMode.values[themeIndex], locale: locale));
  }

  void updateThemeMode(ThemeMode mode) {
    _box.put('themeMode', mode.index);
    emit(state.copyWith(themeMode: mode));
  }

  void updateLocale(Locale locale) {
    _box.put('locale', locale.languageCode);
    AppStrings.updateLocale(locale);
    emit(state.copyWith(locale: locale));
  }
}
