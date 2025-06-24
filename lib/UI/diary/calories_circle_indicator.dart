import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CaloriesCircleIndicator extends StatelessWidget {
  final String label;
  final int value;
  final int goal;
  final Color color;

  const CaloriesCircleIndicator({
    super.key,
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (value / goal).clamp(0.0, 1.0);
    int remaining = goal - value;
    if (remaining < 0) {
      remaining = 0;
    }

    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Column(
              children: [
                Text("$goal", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Ziel", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 60,
                  lineWidth: 12.0,
                  percent: percent,
                  progressColor: color,
                  backgroundColor: Colors.grey.shade200,
                  circularStrokeCap: CircularStrokeCap.round,
                  startAngle: 210,
                  arcType: ArcType.FULL,
                  arcBackgroundColor: Colors.grey.shade200,
                ),
                Column(
                  children: [
                    Text(
                      "$value",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "verbraucht",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Text("$remaining", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("übrig", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
          ],
        ),
        Text("Kalorien", style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
