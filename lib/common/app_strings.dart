import 'package:flutter/material.dart';

class AppStrings {
  static const locales = [Locale('de'), Locale('en')];

  static Locale _locale = const Locale('de');

  static final Map<String, Map<String, String>> _values = {
    'de': {
      'menu': 'Menü',
      'profile': 'Profil',
      'settings': 'Einstellungen',
      'diary': 'Tagebuch',
      'progress': 'Fortschritt',
      'newMeal': 'Neue Mahlzeit',
      'deleteMeal': 'Mahlzeit löschen',
      'confirmDeleteMeal': 'Willst du diese Mahlzeit wirklich löschen?',
      'deleteIngredient': 'Zutat löschen',
      'confirmDeleteIngredient': 'Willst du diese Zutat wirklich löschen?',
      'addIngredient': 'Zutat hinzufügen',
      'editIngredient': 'Zutat bearbeiten',
      'nutrients': 'Nährstoffe',
      'calories': 'Kalorien',
      'meals': 'Mahlzeiten',
      'delete': 'Löschen',
      'cancel': 'Abbrechen',
      'save': 'Speichern',
      'error': 'Fehler',
      'addProfilePrompt': 'Kein Profil gefunden. Bitte lege eines an.',
      'noWeights': 'Keine Gewichtsaufzeichnungen',
      'noCalorieData': 'Keine Kaloriendaten',
      'language': 'Sprache',
      'theme': 'Design',
      'dark': 'Dunkel',
      'light': 'Hell',
      'system': 'System',
    },
    'en': {
      'menu': 'Menu',
      'profile': 'Profile',
      'settings': 'Settings',
      'diary': 'Diary',
      'progress': 'Progress',
      'newMeal': 'New Meal',
      'deleteMeal': 'Delete Meal',
      'confirmDeleteMeal': 'Do you really want to delete this meal?',
      'deleteIngredient': 'Delete ingredient',
      'confirmDeleteIngredient': 'Do you really want to delete this ingredient?',
      'addIngredient': 'Add ingredient',
      'editIngredient': 'Edit ingredient',
      'nutrients': 'Nutrients',
      'calories': 'Calories',
      'meals': 'Meals',
      'delete': 'Delete',
      'cancel': 'Cancel',
      'save': 'Save',
      'error': 'Error',
      'addProfilePrompt': 'No profile found. Please create one.',
      'noWeights': 'No weight records',
      'noCalorieData': 'No calorie data',
      'language': 'Language',
      'theme': 'Theme',
      'dark': 'Dark',
      'light': 'Light',
      'system': 'System',
    }
  };

  static void updateLocale(Locale locale) {
    if (_values.containsKey(locale.languageCode)) {
      _locale = locale;
    }
  }

  static String _t(String key) =>
      _values[_locale.languageCode]?[key] ?? _values['de']![key]!;

  static String get menu => _t('menu');
  static String get profile => _t('profile');
  static String get settings => _t('settings');
  static String get diary => _t('diary');
  static String get progress => _t('progress');
  static String get newMeal => _t('newMeal');
  static String get deleteMeal => _t('deleteMeal');
  static String get confirmDeleteMeal => _t('confirmDeleteMeal');
  static String get deleteIngredient => _t('deleteIngredient');
  static String get confirmDeleteIngredient => _t('confirmDeleteIngredient');
  static String get addIngredient => _t('addIngredient');
  static String get editIngredient => _t('editIngredient');
  static String get nutrients => _t('nutrients');
  static String get calories => _t('calories');
  static String get meals => _t('meals');
  static String get delete => _t('delete');
  static String get cancel => _t('cancel');
  static String get save => _t('save');
  static String get error => _t('error');
  static String get addProfilePrompt => _t('addProfilePrompt');
  static String get noWeights => _t('noWeights');
  static String get noCalorieData => _t('noCalorieData');
  static String get language => _t('language');
  static String get theme => _t('theme');
  static String get dark => _t('dark');
  static String get light => _t('light');
  static String get system => _t('system');
}
