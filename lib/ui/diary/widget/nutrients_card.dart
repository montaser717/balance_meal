import 'package:balance_meal/ui/diary/daily_intace_model.dart';
import 'package:flutter/material.dart';

import '../../../bloc/diary/diary_state.dart';
import '../../../common/app_strings.dart';
import '../../../common/app_theme.dart';
import '../../../models/user_profile.dart';
import 'calories_circle_indicator.dart';
import 'nutrient_progress_bar.dart';

class NutrientsCard extends StatelessWidget {
  final DiaryState state;
  final UserProfile profile;

  const NutrientsCard({super.key, required this.state, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final intake = DailyIntake.fromMeals(state.meals);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: AppTheme.spacing,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  AppStrings.nutrients,
                  style: textTheme.titleLarge,
                ),
              ],
            ),

            CaloriesCircleIndicator(
              label: AppStrings.calories,
              value: intake.totalCalories,
              goal: profile.calorieGoal,
            ),
            const SizedBox(height: AppTheme.spacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NutrientProgressBar(
                  label: AppStrings.proteins,
                  value: intake.totalProtein,
                  goal: profile.proteinGoal,
                  color: AppTheme.proteinProgress,
                ),
                NutrientProgressBar(
                  label: AppStrings.fats,
                  value: intake.totalFats,
                  goal: profile.fatGoal,
                  color: AppTheme.fatProgress,
                ),
                NutrientProgressBar(
                  label: AppStrings.carbs,
                  value: intake.totalCarbs,
                  goal: profile.carbGoal,
                  color: AppTheme.carbProgress,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}