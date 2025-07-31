import 'package:flutter/material.dart';
import 'package:balance_meal/common/app_theme.dart';

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
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.18,
              height: 6,
              decoration: BoxDecoration(
                color: AppTheme.progressBarBackground,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.18 * percentage,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text("($value/$goal)", style: textTheme.titleSmall),
        Text(label, style: textTheme.titleSmall),
      ],
    );
  }
}
