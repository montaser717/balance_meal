import 'dart:io';
import 'package:hive/hive.dart';
import 'package:balance_meal/models/meal.dart';
import 'package:balance_meal/models/food_item.dart';
import 'package:balance_meal/models/user_profile.dart';
import 'package:balance_meal/models/weight_entry.dart';

Future<void> setUpHive() async {
  final dir = await Directory.systemTemp.createTemp('hive_test');
  Hive.init(dir.path);
  Hive.registerAdapter(MealAdapter());
  Hive.registerAdapter(FoodItemAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(WeightEntryAdapter());
  await Hive.openBox<Meal>('meals');
  await Hive.openBox<UserProfile>('profileBox');
  await Hive.openBox<WeightEntry>('weightBox');
}

Future<void> tearDownHive() async {
  await Hive.deleteBoxFromDisk('meals');
  await Hive.deleteBoxFromDisk('profileBox');
  await Hive.deleteBoxFromDisk('weightBox');
}
