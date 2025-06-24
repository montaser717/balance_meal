import 'package:flutter/material.dart';

class NutrientProgressBar extends StatelessWidget {
  final String label;
  final int value;
  final int goal;
  final Color color;

  const NutrientProgressBar({
    super.key,
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = goal == 0 ? 0.0 : (value / goal).clamp(0.0, 1.0);

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 70,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Container(
              width: 70 * percentage,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text("($value/$goal)"),
        Text("$label "),
      ],
    );
  }
}
