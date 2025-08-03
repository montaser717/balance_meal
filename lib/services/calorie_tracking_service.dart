
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../models/daily_calorie_entry.dart';

class CalorieTrackingService {
  final String _boxName = 'dailyCalories';
  static final ValueNotifier<bool> updated = ValueNotifier(false);

  Future<void> saveOrUpdateToday({
    required double consumed,
    required double goal,
  }) async {
    final box = await Hive.openBox<DailyCalorieEntry>(_boxName);
    final today = DateTime.now();
    final todayKey = today.toIso8601String().split('T').first;

    final entry = DailyCalorieEntry(
      date: DateTime(today.year, today.month, today.day),
      consumed: consumed,
      goal: goal,
    );

    await box.put(todayKey, entry);
    updated.value = !updated.value;

  }

  Future<List<DailyCalorieEntry>> loadHistory({int days = 90}) async {
    final box = await Hive.openBox<DailyCalorieEntry>(_boxName);
    final now = DateTime.now();
    final from = now.subtract(Duration(days: days));
    return box.values
        .where((e) => !e.date.isBefore(from))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}
