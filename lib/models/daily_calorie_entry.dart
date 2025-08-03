import 'package:hive/hive.dart';

part "daily_calorie_entry.g.dart";

@HiveType(typeId: 6)
class DailyCalorieEntry extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double consumed;

  @HiveField(2)
  final double goal;

  DailyCalorieEntry({
    required this.date,
    required this.consumed,
    required this.goal,
  });
}