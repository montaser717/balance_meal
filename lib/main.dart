import 'package:balance_meal/router/app_router.dart';
import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'common/app_theme.dart'; //
void main() {
  runApp(const CalorinTrackerApp());
}

class CalorinTrackerApp extends StatelessWidget {
  const CalorinTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Calorin Tracker',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
