import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:balance_meal/common/app_strings.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          if (index != navigationShell.currentIndex) {
            navigationShell.goBranch(index);
          }
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.bar_chart), label: AppStrings.progress),
          BottomNavigationBarItem(icon: const Icon(Icons.book), label: AppStrings.diary),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: AppStrings.settings),
        ],
      ),
    );
  }
}
