import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/diary/diary_view.dart';
import '../ui/diary/progress_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/diary',
  routes: [
    GoRoute(
      path: '/diary',
      builder: (context, state) => const DiaryView(),
    ),
    GoRoute(
      path: '/progress',
      builder: (context, state) => const ProgressView(),
    ),
  ],
);
