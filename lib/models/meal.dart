import 'package:balance_meal/models/food_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'meal.freezed.dart';

part 'meal.g.dart';

@freezed
@HiveType(typeId: 0)
class Meal with _$Meal {
  const factory Meal({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required int calories,
    @HiveField(3) required int protein,
    @HiveField(4) required int fat,
    @HiveField(5) required int carbs,
    @HiveField(6) required DateTime date,
    @HiveField(7) @Default([]) List<FoodItem> items,
  }) = _Meal;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
}
