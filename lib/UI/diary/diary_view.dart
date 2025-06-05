import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/diary/diary_cubit.dart';
import '../../../bloc/diary/diary_state.dart';
import '../../../models/meal.dart';
import '../../../services/fake_meal_service.dart';
import 'meal_card.dart';
import 'nutrient_bar.dart';

class DiaryView extends StatelessWidget {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiaryCubit(FakeMealService())..loadMeals(),
      child: BlocBuilder<DiaryCubit, DiaryState>(
        builder: (context, state) {
          final cubit = context.read<DiaryCubit>();

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tagebuch", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  // ✅ Benutzerprofil-Bereich
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Text("Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ✅ Fehler oder Ladezustand
                  if (state.isLoading)
                    const Center(child: CircularProgressIndicator()),

                  if (state.errorMessage != null)
                    Text("Fehler: ${state.errorMessage}", style: const TextStyle(color: Colors.red)),

                  // ✅ Nährstoffanzeige
                  const Text("Nährstoffe", style: TextStyle(fontWeight: FontWeight.bold)),
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
                          children: const [
                            NutrientBar(label: "Proteine"),
                            NutrientBar(label: "Fette"),
                            NutrientBar(label: "Kohlenhydr"),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Colors.grey, thickness: 2),
                        const Text("Kalorien"),
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
                        onPressed: () {
                          final meal = Meal(
                            id: '',
                            name: 'Neue Mahlzeit',
                            calories: 300,
                            date: DateTime.now(),
                          );
                          cubit.addMeal(meal);
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
                            MealCard(title: meal.name, calories: meal.calories),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
