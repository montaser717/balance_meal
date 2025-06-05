import 'package:flutter/material.dart';

class NutrientBar extends StatelessWidget {
  final String label;

  const NutrientBar({super.key, required this.label});

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
