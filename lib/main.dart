import 'package:balance_meal/models/food_item.dart';
import 'package:balance_meal/models/user_profile.dart';
import 'package:balance_meal/services/hive_meal_service.dart';
import 'package:balance_meal/services/hive_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:balance_meal/router/app_router.dart';
import 'package:balance_meal/common/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bloc/diary/diary_cubit.dart';
import 'bloc/profile/profile_cubit.dart';
import 'bloc/profile/profile_state.dart';
import 'bloc/settings/settings_cubit.dart';
import 'common/app_theme.dart';
import 'common/app_strings.dart';
import 'models/daily_calorie_entry.dart';
import 'models/meal.dart';
import 'models/weight_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(WeightEntryAdapter());
  await Hive.openBox<WeightEntry>('weightBox');
  Hive.registerAdapter(MealAdapter());
  Hive.registerAdapter(FoodItemAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(DailyCalorieEntryAdapter());
  await Hive.openBox<UserProfile>('profileBox');
  await Hive.openBox<Meal>('meals');
  await Hive.openBox('settingsBox');


  final mealService = HiveMealService();
  final diaryCubit = DiaryCubit(mealService);
  await diaryCubit.resetIfNewDay();

  runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => DiaryCubit(HiveMealService())..loadMeals()),
          BlocProvider(create: (_) => ProfileCubit(HiveProfileService())..loadProfile()),
          BlocProvider(create: (_) => SettingsCubit(Hive.box('settingsBox'))),
        ],
        child: const CalorieTrackerApp(),
      ),
      // const CalorieTrackerApp()
      );
}

class CalorieTrackerApp extends StatelessWidget {
  const CalorieTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) =>
          prev.profile != curr.profile || prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        final loc = appRouter.state.matchedLocation;
        final shouldRedirect =
            loc != AppRoutes.profile && loc != AppRoutes.mealEdit;
        if (!state.isLoading &&
            state.profile.name.isEmpty &&
            shouldRedirect) {
          appRouter.go(AppRoutes.profile);
        }
      },
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'Calorin Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            locale: settings.locale,
            supportedLocales: AppStrings.locales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
