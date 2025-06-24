import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/food_item.dart';
import '../../models/meal.dart';

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
    final calController = TextEditingController(text: existingItem?.calories.toString());
    final protController = TextEditingController(text: existingItem?.protein.toString());
    final fatController = TextEditingController(text: existingItem?.fat.toString());
    final carbController = TextEditingController(text: existingItem?.carbs.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existingItem == null ? "Lebensmittel hinzufügen" : "Lebensmittel bearbeiten"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
                TextField(controller: calController, decoration: const InputDecoration(labelText: "Kalorien"), keyboardType: TextInputType.number),
                TextField(controller: protController, decoration: const InputDecoration(labelText: "Proteine (g)"), keyboardType: TextInputType.number),
                TextField(controller: fatController, decoration: const InputDecoration(labelText: "Fette (g)"), keyboardType: TextInputType.number),
                TextField(controller: carbController, decoration: const InputDecoration(labelText: "Kohlenhydrate (g)"), keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Abbrechen")),
            ElevatedButton(
              onPressed: () {
                final newItem = FoodItem(
                  name: nameController.text,
                  calories: int.tryParse(calController.text) ?? 0,
                  protein: int.tryParse(protController.text) ?? 0,
                  fat: int.tryParse(fatController.text) ?? 0,
                  carbs: int.tryParse(carbController.text) ?? 0,
                  grams: 0,
                );

                setState(() {
                  if (index != null) {
                    foodItems[index] = newItem;
                  } else {
                    foodItems.add(newItem);
                  }

                  // neu berechnen
                  totalCalories = foodItems.fold(0, (sum, item) => sum + item.calories);
                  totalProteins = foodItems.fold(0, (sum, item) => sum + item.protein);
                  totalFats = foodItems.fold(0, (sum, item) => sum + item.fat);
                  totalCarbs = foodItems.fold(0, (sum, item) => sum + item.carbs);
                });

                Navigator.of(context).pop();
              },
              child: const Text("Speichern"),
            ),
          ],
        );
      },
    );
  }


  void addItemDialog() async {
    final nameController = TextEditingController();
    final calController = TextEditingController();
    final protController = TextEditingController();
    final fatController = TextEditingController();
    final carbController = TextEditingController();
    final gramController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Lebensmittel hinzufügen"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
                TextField(controller: calController, decoration: const InputDecoration(labelText: "Kalorien"), keyboardType: TextInputType.number),
                TextField(controller: protController, decoration: const InputDecoration(labelText: "Proteine (g)"), keyboardType: TextInputType.number),
                TextField(controller: fatController, decoration: const InputDecoration(labelText: "Fette (g)"), keyboardType: TextInputType.number),
                TextField(controller: carbController, decoration: const InputDecoration(labelText: "Kohlenhydrate (g)"), keyboardType: TextInputType.number),
                TextField(controller: gramController, decoration: const InputDecoration(labelText: "Gewicht (g)"), keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Abbrechen")),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final cal = int.tryParse(calController.text) ?? 0;
                final prot = int.tryParse(protController.text) ?? 0;
                final fat = int.tryParse(fatController.text) ?? 0;
                final carb = int.tryParse(carbController.text) ?? 0;
                final grams = int.tryParse(gramController.text) ?? 0;

                setState(() {
                  foodItems.add(FoodItem(
                    name: name,
                    calories: cal,
                    protein: prot,
                    fat: fat,
                    carbs: carb,
                    grams: grams,
                  ));
                  totalCalories += cal;
                  totalProteins += prot;
                  totalFats += fat;
                  totalCarbs += carb;
                });

                Navigator.of(context).pop();
              },
              child: const Text("Hinzufügen"),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: "Mahlzeitname",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(onPressed: showFoodItemDialog, icon: const Icon(Icons.add)),     // Popup aufrufen
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔢 Nährwert-Zeile
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NutrientValue(label: "Kalorien", value: totalCalories),
                _NutrientValue(label: "Proteine", value: totalProteins),
                _NutrientValue(label: "Fette", value: totalFats),
                _NutrientValue(label: "Kohlenhydr.", value: totalCarbs),
              ],
            ),
            const SizedBox(height: 24),

            // 🧾 Liste der Einträge
            Expanded(
              child: ListView.separated(
                itemCount: foodItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = foodItems[index];

                  return GestureDetector(
                    onTap: () => showFoodItemDialog(existingItem: item, index: index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.name),
                          Text("${item.calories} kcal", style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // 💾 Speichern
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final meal = Meal(
                    id: widget.existingMeal?.id ?? mealId,
                    name: nameController.text.isEmpty ? 'Mahlzeit' : nameController.text,
                    calories: totalCalories,
                    protein: totalProteins,
                    fat: totalFats,
                    carbs: totalCarbs,
                    date: DateTime.now(),
                    items: foodItems,
                  );
                  Navigator.of(context).pop(meal);
                },
                child: const Text("Speichern"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutrientValue extends StatelessWidget {
  final String label;
  final int value;

  const _NutrientValue({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$value",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
