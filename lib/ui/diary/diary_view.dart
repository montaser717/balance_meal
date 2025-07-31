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
                      NutrientsCard(state: state, profile: profile,),

                    const SizedBox(height: AppTheme.spacing * 1.5),

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
