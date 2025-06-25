import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/meal.dart';
import 'i_meal_service.dart';

class FakeMealService implements IMealService {
  final List<Meal> _meals = [];

  @override
  Future<List<Meal>> loadMeals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_meals);
  }

  @override
  Future<void> addMeal(Meal meal) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _meals.add(meal.copyWith(id: const Uuid().v4()));
  }

  @override
  Future<void> deleteMeal(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _meals.removeWhere((meal) => meal.id == id);
  }

  @override
  Future<void> updateMeal(Meal meal) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _meals.indexWhere((m) => m.id == meal.id);
    if (index != -1) {
      _meals[index] = meal;
    }
  }
}
