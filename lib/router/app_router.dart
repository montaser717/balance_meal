import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:balance_meal/ui/diary/diary_view.dart';
import 'package:balance_meal/ui/progress/progress_view.dart';
import 'package:balance_meal/ui/profile/profile_view.dart';
import 'package:balance_meal/ui/settings/settings_view.dart';
import 'package:balance_meal/ui/diary/meal_edit_view.dart';
import 'package:balance_meal/models/meal.dart';

import 'package:balance_meal/common/app_scaffold.dart';
import 'package:balance_meal/common/app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.diary,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.progress,
              builder: (context, state) => const ProgressView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.diary,
              builder: (context, state) => const DiaryView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsView(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileView(),
    ),
    GoRoute(
      path: AppRoutes.mealEdit,
      builder: (context, state) => MealEditView(
        existingMeal: state.extra is Meal ? state.extra as Meal : null,
      ),
    ),
  ],
);

// Typed route helpers

class ProfileRoute extends GoRouteData {
  const ProfileRoute();

  static const String path = AppRoutes.profile;

  @override
  Widget build(BuildContext context, GoRouterState state) => const ProfileView();
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  static const String path = AppRoutes.settings;

  @override
  Widget build(BuildContext context, GoRouterState state) => const SettingsView();
}

class MealEditRoute extends GoRouteData {
  const MealEditRoute({this.meal});

  final Meal? meal;

  static const String path = AppRoutes.mealEdit;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MealEditView(existingMeal: meal);
}

extension ProfileRouteNavigation on ProfileRoute {
  Future<T?> push<T extends Object?>(BuildContext context) =>
      context.push<T>(ProfileRoute.path);

  void go(BuildContext context) => context.go(ProfileRoute.path);
}

extension SettingsRouteNavigation on SettingsRoute {
  Future<T?> push<T extends Object?>(BuildContext context) =>
      context.push<T>(SettingsRoute.path);

  void go(BuildContext context) => context.go(SettingsRoute.path);
}

extension MealEditRouteNavigation on MealEditRoute {
  Future<T?> push<T extends Object?>(BuildContext context) =>
      context.push<T>(MealEditRoute.path, extra: meal);

  void go(BuildContext context) => context.go(MealEditRoute.path, extra: meal);
}
