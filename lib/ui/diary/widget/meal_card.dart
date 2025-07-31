import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/diary/diary_cubit.dart';
import '../../../common/app_routes.dart';
import '../../../common/app_strings.dart';
import '../../../models/meal.dart';

class MealCard extends StatelessWidget {
  final String title;
  final Meal meal;

  const MealCard({super.key, required this.title, required this.meal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: colorScheme.surface,
        child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          final updatedMeal = await context.push<Meal>(
            AppRoutes.mealEdit,
            extra: meal,
          );

          if (!context.mounted) return;

          if (updatedMeal != null) {
            context.read<DiaryCubit>().updateMeal(updatedMeal);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  meal.name,
                  style: textTheme.titleMedium
                ),
              ),
              Text(
                "${meal.calories.toStringAsFixed(0)} kcal",
                style: textTheme.titleMedium
              ),
              IconButton(
                icon: Icon(Icons.delete, color: colorScheme.error),
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

                  if (!context.mounted) return;

                  if (confirm == true) {
                    context.read<DiaryCubit>().deleteMeal(meal.id);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
