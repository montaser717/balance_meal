import '../../models/meal.dart';

class DailyIntake {
  final List<Meal> meals;

  DailyIntake(this.meals);

  int get totalCalories =>
      meals.fold(0, (sum, m) => sum + m.calories);

  int get totalProtein =>
      meals.fold(0, (sum, m) => sum + m.protein);

  int get totalFats =>
      meals.fold(0, (sum, m) => sum + m.fat);

  int get totalCarbs =>
      meals.fold(0, (sum, m) => sum + m.carbs);

  factory DailyIntake.fromMeals(List<Meal> meals) => DailyIntake(meals);
}
