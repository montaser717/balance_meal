import 'package:hive/hive.dart';

import 'package:balance_meal/models/meal.dart';
import 'i_meal_service.dart';
import 'storage_exception.dart';

class HiveMealService implements IMealService {
  final Box<Meal> _box = Hive.box<Meal>('meals');

  @override
  Future<List<Meal>> loadMeals() async {
    try {
      return _box.values.toList();
    } catch (e) {
      throw StorageException('Fehler beim Laden der Mahlzeiten');
    }
  }

  @override
  Future<void> addMeal(Meal meal) async {
    try {
      await _box.put(meal.id, meal);
    } catch (e) {
      throw StorageException('Fehler beim Speichern der Mahlzeit');
    }
  }

  @override
  Future<void> deleteMeal(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      throw StorageException('Fehler beim Löschen der Mahlzeit');
    }
  }

  @override
  Future<void> updateMeal(Meal meal) async {
    try {
      await _box.put(meal.id, meal);
    } catch (e) {
      throw StorageException('Fehler beim Aktualisieren der Mahlzeit');
    }
  }
}
