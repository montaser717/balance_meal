import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:balance_meal/common/app_strings.dart';
import 'package:balance_meal/common/app_theme.dart';

import 'package:balance_meal/models/food_item.dart';
import 'package:balance_meal/models/meal.dart';

class MealEditView extends StatefulWidget {
  final Meal? existingMeal;

  const MealEditView({super.key, this.existingMeal});

  @override
  State<MealEditView> createState() => _MealEditViewState();
}

class _MealEditViewState extends State<MealEditView> {
  final List<FoodItem> foodItems = [];
  late final TextEditingController nameController;
  final String mealId = const Uuid().v4();
  final _formKey = GlobalKey<FormState>();

  int totalCalories = 0;
  int totalProteins = 0;
  int totalFats = 0;
  int totalCarbs = 0;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.existingMeal?.name ?? '',
    );
    if (widget.existingMeal != null) {
      totalCalories = widget.existingMeal!.calories;
      totalProteins = widget.existingMeal!.protein;
      totalFats = widget.existingMeal!.fat;
      totalCarbs = widget.existingMeal!.carbs;
      foodItems.addAll(widget.existingMeal!.items);
    }
  }

  Future<void> showFoodItemDialog({FoodItem? existingItem, int? index}) async {
    final nameController = TextEditingController(text: existingItem?.name);
    final calController = TextEditingController(
      text: existingItem?.calories.toString(),
    );
    final protController = TextEditingController(
      text: existingItem?.protein.toString(),
    );
    final fatController = TextEditingController(
      text: existingItem?.fat.toString(),
    );
    final carbController = TextEditingController(
      text: existingItem?.carbs.toString(),
    );
    final gramsController = TextEditingController(
      text: existingItem?.grams.toString(),
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            existingItem == null
                ? AppStrings.addIngredient
                : AppStrings.editIngredient,
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: Column(
                  children: [
                    _buildTextField("Name", nameController, isNumeric: false),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField("Kalorien", calController),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTextField("Proteine", protController),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField("Fette", fatController),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTextField(
                            "Kohlenhydrate",
                            carbController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField("Menge (g)", gramsController),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final name = nameController.text.trim();
                  final ing = FoodItem(
                    name: name,
                    calories: int.parse(calController.text),
                    protein: int.parse(protController.text),
                    fat: int.parse(fatController.text),
                    carbs: int.parse(carbController.text),
                    grams: int.parse(gramsController.text),
                  );
                  Navigator.pop(context, ing);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Bitte alle Felder korrekt ausfüllen"),
                    ),
                  );
                }
              },
              child: Text(AppStrings.save),
            ),
          ],
        );
      },
    ).then((result) {
      if (result != null && result is FoodItem) {
        setState(() {
          if (index != null) {
            final oldItem = foodItems[index];
            totalCalories -= oldItem.calories;
            totalProteins -= oldItem.protein;
            totalFats -= oldItem.fat;
            totalCarbs -= oldItem.carbs;
            foodItems[index] = result;
          } else {
            foodItems.add(result);
          }
          totalCalories += result.calories;
          totalProteins += result.protein;
          totalFats += result.fat;
          totalCarbs += result.carbs;
        });
      }
    });
  }

  void removeItem(int index) {
    final item = foodItems[index];
    setState(() {
      totalCalories -= item.calories;
      totalProteins -= item.protein;
      totalFats -= item.fat;
      totalCarbs -= item.carbs;
      foodItems.removeAt(index);
    });
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumeric = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType:
          isNumeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
      inputFormatters:
          isNumeric
              ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))]
              : null,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Pflichtfeld';
        }
        if (isNumeric &&
            (double.tryParse(value) == null || double.parse(value) < 0)) {
          return 'Ungültige Zahl';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: isNumeric ? "z. B. 100" : "z. B. Apfel",
        filled: true,
        fillColor: AppTheme.cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        isDense: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.newMeal),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.edit),
                labelText: "Mahlzeitname",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing * 1.5),

            // Nährwerte
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NutrientBox(label: "Proteine", value: totalProteins),
                _NutrientBox(label: "Fette", value: totalFats),
                _NutrientBox(label: "Kohlenhydr", value: totalCarbs),
              ],
            ),
            const SizedBox(height: 12),
            Center(child: Text("${totalCalories.toStringAsFixed(1)} kcal")),

            const SizedBox(height: AppTheme.spacing * 1.5),

            // Zutatenliste mit Löschen
            Expanded(
              child: ListView.separated(
                itemCount: foodItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = foodItems[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: AppTheme.spacing,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap:
                                () => showFoodItemDialog(
                                  existingItem: item,
                                  index: index,
                                ),
                            child: Text(item.name),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "${item.calories} kcal",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.delete, color: AppTheme.errorColor),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text(AppStrings.deleteIngredient),
                                        content: Text(
                                          AppStrings.confirmDeleteIngredient,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(false),
                                            child: Text(AppStrings.cancel),
                                          ),
                                          ElevatedButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(true),
                                            child: Text(AppStrings.delete),
                                          ),
                                        ],
                                      ),
                                );

                                if (confirm == true) {
                                  removeItem(index);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppTheme.spacing),

            // + Zutat hinzufügen
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => showFoodItemDialog(),
                icon: const Icon(Icons.add),
                label: Text(AppStrings.addIngredient),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppTheme.primaryDark,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing / 2),

            // Speichern
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final meal = Meal(
                    id: widget.existingMeal?.id ?? mealId,
                    name:
                        nameController.text.isEmpty
                            ? 'Mahlzeit'
                            : nameController.text,
                    calories: totalCalories,
                    protein: totalProteins,
                    fat: totalFats,
                    carbs: totalCarbs,
                    date: DateTime.now(),
                    items: foodItems,
                  );
                  Navigator.of(context).pop(meal);
                },
                icon: const Icon(Icons.save),
                label: Text(AppStrings.save),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppTheme.primaryLight,
                  foregroundColor: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutrientBox extends StatelessWidget {
  final String label;
  final int value;

  const _NutrientBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text("$value g"),
      ],
    );
  }
}
