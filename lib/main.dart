import 'package:balance_meal/models/food_item.dart';
import 'package:flutter/material.dart';
import 'package:balance_meal/router/app_router.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'common/app_theme.dart';
import 'models/meal.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  Hive.registerAdapter(MealAdapter());
  Hive.registerAdapter(FoodItemAdapter());

  await Hive.openBox<Meal>('meals');

  runApp(const CalorinTrackerApp());
}

class CalorinTrackerApp extends StatelessWidget {
  const CalorinTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Calorin Tracker',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
