import 'package:balance_meal/ui/diary/calories_circle_indicator.dart';
import 'package:balance_meal/models/user_profile.dart';
import 'package:balance_meal/services/hive_meal_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_meal/bloc/diary/diary_cubit.dart';
import 'package:balance_meal/bloc/diary/diary_state.dart';
import 'package:balance_meal/models/meal.dart';
import 'package:balance_meal/bloc/profile/profile_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../common/app_routes.dart';
import 'meal_card.dart';
import 'nutrient_progress_bar.dart';
import 'package:balance_meal/common/app_theme.dart';
import 'package:balance_meal/common/app_strings.dart';

class DiaryView extends StatelessWidget {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiaryCubit(HiveMealService())..loadMeals(),
      child: BlocBuilder<DiaryCubit, DiaryState>(
        builder: (context, state) {
          final cubit = context.read<DiaryCubit>();
          final profileState = context.watch<ProfileCubit>().state;
          final profile = profileState.profile;

          final totalCalories = state.meals.fold<int>(
            0,
            (sum, m) => sum + m.calories,
          );
          final totalProteins = state.meals.fold<int>(
            0,
            (sum, m) => sum + m.protein,
          );
          final totalFats = state.meals.fold<int>(0, (sum, m) => sum + m.fat);
          final totalCarbs = state.meals.fold<int>(
            0,
            (sum, m) => sum + m.carbs,
          );

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(AppStrings.diary, style: AppTheme.pageTitle),

                    const SizedBox(height: AppTheme.spacing * 1.5),

                    if (state.isLoading)
                      const Center(child: CircularProgressIndicator()),

                    if (state.errorMessage != null)
                      Text(
                        "${AppStrings.error}: ${state.errorMessage}",
                        style: TextStyle(color: AppTheme.errorColor),
                      ),

                    if (profileState.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          AppStrings.addProfilePrompt,
                          style: TextStyle(color: AppTheme.errorColor),
                        ),
                      ),

                    if (profileState.errorMessage == null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: AppTheme.spacing,
                        ),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                AppStrings.nutrients,
                                style: AppTheme.sectionTitle,
                              ),
                            ],
                          ),

                          CaloriesCircleIndicator(
                            label: AppStrings.calories,
                            value: totalCalories,
                            goal: profile.calorieGoal,
                            color: AppTheme.primaryLight,
                          ),
                          const SizedBox(height: AppTheme.spacing),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              NutrientProgressBar(
                                label: "Proteine",
                                value: totalProteins,
                                goal: profile.proteinGoal,
                                color: Colors.amber,
                              ),
                              NutrientProgressBar(
                                label: "Fette",
                                value: totalFats,
                                goal: profile.fatGoal,
                                color: Colors.deepPurple,
                              ),
                              NutrientProgressBar(
                                label: "Kohlenhydr",
                                value: totalCarbs,
                                goal: profile.carbGoal.clamp(200, 10000),
                                color: Colors.cyan,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacing * 1.5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.meals,
                          style: AppTheme.sectionTitle,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: ()
                          async {
                            final result =
                              await context.push<Meal>(AppRoutes.mealEdit);

                            if (result != null) {
                              cubit.addMeal(
                                result,
                              ); // wird gespeichert & Liste aktualisiert
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.meals.length,
                      itemBuilder: (context, index) {
                        final meal = state.meals[index];
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.cardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        final updatedMeal = await context.push<Meal>(
                                          AppRoutes.mealEdit,
                                          extra: meal,
                                        );

                                        if (updatedMeal != null) {
                                          context.read<DiaryCubit>().updateMeal(updatedMeal);
                                        }
                                      },
                                      child: MealCard(
                                        title: meal.name,
                                        calories: meal.calories,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: AppTheme.errorColor),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(AppStrings.deleteMeal),
                                          content: Text(AppStrings.confirmDeleteMeal),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: Text(AppStrings.cancel),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => Navigator.of(context).pop(true),
                                              child: Text(AppStrings.delete),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        context.read<DiaryCubit>().deleteMeal(meal.id);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
