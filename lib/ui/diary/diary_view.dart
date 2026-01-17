import 'package:balance_meal/models/user_profile.dart';
import 'package:balance_meal/services/hive_meal_service.dart';
import 'package:balance_meal/ui/diary/widget/nutrients_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_meal/bloc/diary/diary_cubit.dart';
import 'package:balance_meal/bloc/diary/diary_state.dart';
import 'package:balance_meal/models/meal.dart';
import 'package:balance_meal/bloc/profile/profile_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../common/app_routes.dart';
import '../../services/calorie_tracking_service.dart';
import 'widget/meal_card.dart';
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
          final textTheme = Theme.of(context).textTheme;

          final totalCalories = state.meals.fold<int>(
            0,
                (sum, m) => sum + m.calories,
          );

          if (!state.isLoading &&
              state.errorMessage == null) {
            CalorieTrackingService().saveOrUpdateToday(
              consumed: totalCalories.toDouble(),
              goal: profile.calorieGoal.toDouble(),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.diary, style: textTheme.titleLarge),
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
                      NutrientsCard(state: state, profile: profile),
                    const SizedBox(height: AppTheme.spacing * 1.5),


                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: const Text("Reset"),
                              content: Text(AppStrings.warining,style: textTheme.titleSmall),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text(AppStrings.cancel),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.error,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text("Reset"),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            cubit.resetDay();
                          }
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("Reset"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          elevation: 2,
                          shadowColor: Theme.of(context).shadowColor,
                          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),


                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.meals, style: textTheme.titleLarge),
                        IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            final result = await context.push<Meal>(
                              AppRoutes.mealEdit,
                            );

                            if (result != null) {
                              cubit.addMeal(result);
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
                            MealCard(title: meal.name, meal: meal),
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
