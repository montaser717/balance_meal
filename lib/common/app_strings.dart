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
      'goal': 'Ziel',
      'consumed': 'verbraucht',
      'left': 'übrig',
      'proteins': 'Proteine',
      'fats': 'Fette',
      'carbs': 'Kohlenhydr',
      'mealName': 'Mahlzeitname',
      'name': 'Name',
      'amount': 'Menge (g)',
      'fieldHint': 'Bitte alle Felder korrekt ausfüllen',
      'requiredField': 'Pflichtfeld',
      'invalidNumber': 'ungültige Zahl',
      'weight': 'Gewicht',
      'Months': 'Monate',
      'tracking' : 'Gewicht tracken',
      'week' : '1 Woche',
      'all': 'Alle',
      'enter weight' : 'Gewicht eingeben',
      'for example' : 'z.B. 75',
      'are you sure that you want to delete all the meals' : 'Bist du sicher, dass du alle heutigen Mahlzeiten löschen möchtest?"',
      'hight':'Größe',
      'Sex':'Geschlecht',
      'female':'weiblich',
      'male':'mänlich',
      'low':'gering',
      'middel':'mittel',
      'high':'hoch',
      'hold weight':'halten',
      'gain weight':'zunehmen',
      'lose weight':'abnehmen',
      'Body deatils':'Körperdaten',
      'Life style':'Lebensstil',



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
      'goal': 'Goal',
      'consumed': 'consumed',
      'left': 'left',
      'proteins': 'Proteins',
      'fats': 'Fats',
      'carbs': 'Carbs',
      'mealName': 'meal name',
      'name': 'name',
      'amount': 'amount (g)',
      'fieldHint': 'Please fill in all fields correctly.',
      'requiredField': 'Required field',
      'invalidNumber': 'invalid number',
      'weight': 'weight',
      'Months': 'Months',
      'tracking' : 'tracking',
      'week' : '1 week',
      'all' : 'all',
      'enter weight' : 'enter weight',
      'for example' : 'for example 75',
      'are you sure that you want to delete all the meals' :'are you sure that you want to delete all the meals',
      'age':'age',
      'hight':'hight',
      'Sex':'Sex',
      'female':'female',
      'male':'male',
      'low':'low',
      'middel':'middel',
      'high':'high',
      'hold weight':'hold weight',
      'gain weight':'gain weight',
      'lose weight':'lose weight',
      'Body deatils':'Body deatils',
      'Life style':'Life style',



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
  static String get goal => _t('goal');
  static String get consumed => _t('consumed');
  static String get left => _t('left');
  static String get proteins => _t('proteins');
  static String get fats => _t('fats');
  static String get carbs => _t('carbs');
  static String get mealName => _t('mealName');
  static String get name => _t('name');
  static String get amount => _t('amount');
  static String get fieldHint => _t('fieldHint');
  static String get requiredField => _t('requiredField');
  static String get invalidNumber => _t('invalidNumber');
  static String get weight => _t('weight');
  static String get months => _t('Months');
  static String get tracking => _t('tracking');
  static String get week => _t('week');
  static String get all => _t('all');
  static String get example => _t('for example');
  static String get entrWeight => _t('enter weight');
  static String get warining => _t('are you sure that you want to delete all the meals');
  static String get hight => _t('hight');
  static String get Sex => _t('Sex');
  static String get female => _t('female');
  static String get male => _t('male');
  static String get low => _t('low');
  static String get middel => _t('middel');
  static String get high => _t('high');
  static String get holdWeight => _t('hold weight');
  static String get gainWeight => _t('gain weight');
  static String get loseWeight => _t('lose weight');
  static String get age => _t('age');
  static String get details => _t('Body deatils');
  static String get lifestyle => _t('Life style');
}
