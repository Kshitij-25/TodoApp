import 'package:flutter/foundation.dart' show immutable;
import 'package:go_router/go_router.dart';

import '../screens/create_task_screen.dart';
import '../screens/home_screen.dart';

@immutable
class AppRoutes {
  const AppRoutes._();

  static final router = GoRouter(
    initialLocation: HomeScreen.routeName,
    routes: [
      GoRoute(
        path: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: CreateTaskScreen.routeName,
        builder: (context, state) => CreateTaskScreen(),
      ),
    ],
  );
}
