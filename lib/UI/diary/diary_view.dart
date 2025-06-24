import 'package:balance_meal/models/user_profile.dart';
import 'package:balance_meal/services/hive_meal_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../bloc/diary/diary_cubit.dart';
import '../../../bloc/diary/diary_state.dart';
import '../../../blocs/profile/profile_cubit.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../../models/meal.dart';
import '../../../services/fake_meal_service.dart';
import '../meal/meal_detail_view.dart';

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

          final totalCalories = state.meals.fold<int>(0, (sum, m) => sum + m.calories);
          final totalProteins = state.meals.fold<int>(0, (sum, m) => sum + m.protein);
          final totalFats = state.meals.fold<int>(0, (sum, m) => sum + m.fat);
          final totalCarbs = state.meals.fold<int>(0, (sum, m) => sum + m.carbs);
          
          final totalCalories2 = state.meals.fold(0.0, (sum, meal) => sum + meal.ingredients.fold(0.0, (s, i) => s + i.calories));
          final totalProtein2 = state.meals.fold(0.0, (sum, meal) => sum + meal.ingredients.fold(0.0, (s, i) => s + i.protein));
          final totalFat2 = state.meals.fold(0.0, (sum, meal) => sum + meal.ingredients.fold(0.0, (s, i) => s + i.fat));
          final totalCarbs2 = state.meals.fold(0.0, (sum, meal) => sum + meal.ingredients.fold(0.0, (s, i) => s + i.carbs));

          final profile = context.watch<ProfileCubit>().state.profile;
          final targetCalories = profile.dailyCalorieTarget;
          final progress = (totalCalories / targetCalories).clamp(0.0, 1.0);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 6,
                radius: const Radius.circular(8),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text("Tagebuch", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    const _ProfileHeader(),
                    const SizedBox(height: 24),

                    if (state.isLoading)
                      const Center(child: CircularProgressIndicator()),

                    if (state.errorMessage != null)
                      Text("Fehler: ${state.errorMessage}", style: const TextStyle(color: Colors.red)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            NutrientProgressBar(label: "Proteine", value: totalProteins, goal: 100, color: Colors.amber),
                            NutrientProgressBar(label: "Fette", value: totalFats, goal: 70, color: Colors.deepPurple),
                            NutrientProgressBar(label: "Kohlenhydr", value: totalCarbs, goal: 200, color: Colors.cyan),
                          ],
                        ),
                        NutrientProgressBar(label: "Kalorien", value: totalCalories, goal: 2000, color: Colors.lightGreen),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ✅ Mahlzeitenliste + Hinzufügen-Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Mahlzeiten", style: TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          final result = await Navigator.of(context).push<Meal>(
                            MaterialPageRoute(builder: (_) => const MealEditView()),
                          );

                          if (result != null) {
                            cubit.addMeal(result); // wird gespeichert & Liste aktualisiert
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ✅ Liste der Mahlzeiten
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.meals.length,
                      itemBuilder: (context, index) {
                        final meal = state.meals[index];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final updatedMeal = await Navigator.of(context).push<Meal>(
                                  MaterialPageRoute(
                                    builder: (_) => MealEditView(existingMeal: meal),
                                  ),
                                );

                                if (updatedMeal != null) {
                                  context.read<DiaryCubit>().updateMeal(updatedMeal);
                                }
                              },
                              child: MealCard(title: meal.name, calories: meal.calories),
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    _MealListHeader(onAddMeal: () async {
                      final newMeal = Meal(
                        id: const Uuid().v4(),
                        name: "",
                        date: DateTime.now(),
                        ingredients: [],
                      );
                      final result = await Navigator.push<Meal>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealDetailView(initialMeal: newMeal),
                        ),
                      );
                      if (result != null) cubit.addMeal(result);
                    }),

                    const SizedBox(height: 12),

                    ...state.meals.map((meal) {
                      final calories = meal.ingredients.fold(0.0, (sum, ing) => sum + ing.calories).round();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Dismissible(
                          key: ValueKey(meal.id),
                          background: Container(
                            decoration: BoxDecoration(
                              color: Colors.red.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            child: const Icon(Icons.delete_forever, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => cubit.deleteMeal(meal.id),
                          child: GestureDetector(
                            onTap: () async {
                              final updatedMeal = await Navigator.push<Meal>(
                                context,
                                MaterialPageRoute(builder: (_) => MealDetailView(initialMeal: meal)),
                              );
                              if (updatedMeal != null) {
                                cubit.updateMeal(updatedMeal);
                              }
                            },
                            child: MealCard(title: meal.name, calories: calories),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          );
        },

    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileCubit>().state.profile;

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.account_circle, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Text(profile.name.isEmpty ? "Name" : profile.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _NutrientBox extends StatelessWidget {
  final double calories, protein, fat, carbs, progress, targetCalories;

  const _NutrientBox({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.progress,
    required this.targetCalories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nährstoffe", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NutrientBar(label: "Proteine: ${protein.toStringAsFixed(1)}g"),
                  NutrientBar(label: "Fette: ${fat.toStringAsFixed(1)}g"),
                  NutrientBar(label: "Kohlenhydr: ${carbs.toStringAsFixed(1)}g"),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey.shade300,
                color: progress >= 1
                    ? Colors.red
                    : (progress > 0.8 ? Colors.orange : Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              Text("Kalorien: ${calories.toStringAsFixed(1)} / ${targetCalories.toStringAsFixed(1)} kcal",
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _MealListHeader extends StatelessWidget {
  final VoidCallback onAddMeal;

  const _MealListHeader({required this.onAddMeal});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Mahlzeiten", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          color: Theme.of(context).colorScheme.primary,
          onPressed: onAddMeal,
          tooltip: 'Mahlzeit hinzufügen',
        ),
      ],
    );
  }
}
