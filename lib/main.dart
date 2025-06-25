import 'package:balance_meal/models/food_item.dart';
import 'package:balance_meal/models/user_profile.dart';
import 'package:balance_meal/services/hive_meal_service.dart';
import 'package:balance_meal/services/hive_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:balance_meal/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'bloc/diary/diary_cubit.dart';
import 'bloc/profile/profile_cubit.dart';
import 'common/app_theme.dart';
import 'models/meal.dart';
import 'models/weight_entry.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(WeightEntryAdapter());
  await Hive.openBox<WeightEntry>('weightBox');
  Hive.registerAdapter(MealAdapter());
  Hive.registerAdapter(FoodItemAdapter());
  Hive.registerAdapter(UserProfileAdapter());

  await Hive.openBox<UserProfile>('profileBox');
  await Hive.openBox<Meal>('meals');

  runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => DiaryCubit(HiveMealService())..loadMeals()),
          BlocProvider(create: (_) => ProfileCubit(HiveProfileService())..loadProfile()),
        ],
        child: const CalorinTrackerApp(),
      ),
      //const CalorinTrackerApp()
      );
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
