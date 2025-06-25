import 'package:hive/hive.dart';

import '../models/meal.dart';
import 'i_meal_service.dart';

class HiveMealService implements IMealService {
  final Box<Meal> _box = Hive.box<Meal>('meals');

  @override
  Future<List<Meal>> loadMeals() async {
    return _box.values.toList();
  }

  @override
  Future<void> addMeal(Meal meal) async {
    await _box.put(meal.id, meal);
  }

  @override
  Future<void> deleteMeal(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> updateMeal(Meal meal) async {
    await _box.put(meal.id, meal);
  }
}
