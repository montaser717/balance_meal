import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiaryView extends StatelessWidget {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  CircleAvatar(radius: 24, child: Icon(Icons.person)),
                  SizedBox(width: 12),
                  Text("Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 24),

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
                      children: [
                        _NutrientBar(label: "Proteine"),
                        _NutrientBar(label: "Fette"),
                        _NutrientBar(label: "Kohlenhydr"),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.grey, thickness: 2),
                    const Text("Kalorien"),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Mahlzeiten", style: TextStyle(fontWeight: FontWeight.bold)),
                  Icon(Icons.add),
                ],
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView(
                  children: const [
                    _MealCard(title: "Frühstück", calories: 531),
                    SizedBox(height: 8),
                    _MealCard(title: "Mittagessen", calories: 1024),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) context.go('/progress');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Tagebuch'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Fortschritt'),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final String title;
  final int calories;

  const _MealCard({required this.title, required this.calories});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            "$calories Cal",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _NutrientBar extends StatelessWidget {
  final String label;

  const _NutrientBar({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }
}
