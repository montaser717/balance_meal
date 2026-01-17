import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:balance_meal/common/app_theme.dart';
import 'package:balance_meal/common/app_strings.dart';

class CaloriesCircleIndicator extends StatelessWidget {
  final String label;
  final int value;
  final int goal;

  const CaloriesCircleIndicator({
    super.key,
    required this.label,
    required this.value,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (value / goal).clamp(0.0, 1.0);
    final remaining = (goal - value).clamp(0, goal);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Column(
              children: [
                Text(
                  "$goal",
                  style: textTheme.titleMedium
                ),
                Text(
                  AppStrings.goal,
                  style: textTheme.titleMedium
                ),
              ],
            ),
            const Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                CircularPercentIndicator(
                  radius: MediaQuery.of(context).size.width * 0.15,
                  lineWidth: 12.0,
                  percent: percent,
                  progressColor: AppTheme.calorieProgress,
                  circularStrokeCap: CircularStrokeCap.round,
                  startAngle: 210,
                  arcType: ArcType.FULL,
                  arcBackgroundColor: AppTheme.progressBarBackground,
                ),
                Column(
                  children: [
                    Text(
                      "$value",
                      style: textTheme.titleLarge
                    ),
                    Text(
                      AppStrings.consumed,
                      style: textTheme.titleMedium
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  "$remaining",
                  style: textTheme.titleMedium
                ),
                Text(
                  AppStrings.left,
                  style: textTheme.titleMedium
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
        Text(AppStrings.calories, style: textTheme.titleMedium),
      ],
    );
  }
}
