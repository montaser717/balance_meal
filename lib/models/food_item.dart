import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'food_item.freezed.dart';
part 'food_item.g.dart';

@freezed
@HiveType(typeId: 1)
class FoodItem with _$FoodItem {
  const factory FoodItem({
    @HiveField(0) required String name,
    @HiveField(1) required int calories,
    @HiveField(2) required int protein,
    @HiveField(3) required int fat,
    @HiveField(4) required int carbs,
    @HiveField(5) required int grams,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) => _$FoodItemFromJson(json);
}
