import '../models/meal.dart';

abstract class IMealService {
  Future<List<Meal>> loadMeals();
  Future<void> addMeal(Meal meal);
  Future<void> deleteMeal(String id);
}
