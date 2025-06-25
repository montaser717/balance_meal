import 'package:balance_meal/UI/diary/calories_circle_indicator.dart';
import 'package:balance_meal/models/user_profile.dart';
import 'package:balance_meal/services/hive_meal_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/diary/diary_cubit.dart';
import '../../../bloc/diary/diary_state.dart';
import '../../../models/meal.dart';
import '../../bloc/profile/profile_cubit.dart';
import 'meal_card.dart';
import 'meal_edit_view.dart';
import 'nutrient_progress_bar.dart';

class DiaryView extends StatelessWidget {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiaryCubit(HiveMealService())..loadMeals(),
      child: BlocBuilder<DiaryCubit, DiaryState>(
        builder: (context, state) {
          final cubit = context.read<DiaryCubit>();
          final profile = context.read<ProfileCubit>().state.profile;

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
                    const SizedBox(height: 12),

                    // userprofile
                    Row(
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text("Tagebuch", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    /*
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    */
                    const SizedBox(height: 24),

                    if (state.isLoading)
                      const Center(child: CircularProgressIndicator()),

                    if (state.errorMessage != null)
                      Text(
                        "Fehler: ${state.errorMessage}",
                        style: const TextStyle(color: Colors.red),
                      ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Nährstoffe",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),

                          CaloriesCircleIndicator(
                            label: "Kalorien",
                            value: totalCalories,
                            goal: profile.calorieGoal,
                            color: Colors.lightGreen,
                          ),
                          const SizedBox(height: 16),
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
                                goal: profile.carbGoal,
                                color: Colors.cyan,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Mahlzeiten",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            final result = await Navigator.of(
                              context,
                            ).push<Meal>(
                              MaterialPageRoute(
                                builder: (_) => const MealEditView(),
                              ),
                            );

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
                            GestureDetector(
                              onTap: () async {
                                final updatedMeal = await Navigator.of(
                                  context,
                                ).push<Meal>(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => MealEditView(existingMeal: meal),
                                  ),
                                );

                                if (updatedMeal != null) {
                                  context.read<DiaryCubit>().updateMeal(
                                    updatedMeal,
                                  );
                                }
                              },
                              child: MealCard(
                                title: meal.name,
                                calories: meal.calories,
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
