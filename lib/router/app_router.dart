import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/diary/diary_view.dart';
import '../ui/progress/progress_view.dart';

import '../common/app_scaffold.dart';
import '../common/app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.diary,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.diary,
              builder: (context, state) => const DiaryView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.progress,
              builder: (context, state) => const ProgressView(),
            ),
          ],
        ),
      ],
    ),
  ],
);
