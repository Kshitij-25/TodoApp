import 'package:flutter/foundation.dart' show immutable;
import 'package:go_router/go_router.dart';

import '../presentation/screens/create_task_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/view_task_screen.dart';

@immutable
class AppRoutes {
  const AppRoutes._();

  static final router = GoRouter(
    initialLocation: LoginScreen.routeName,
    routes: [
      GoRoute(
        name: LoginScreen.routeName,
        path: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: HomeScreen.routeName,
        path: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: CreateTaskScreen.routeName,
        path: CreateTaskScreen.routeName,
        builder: (context, state) => CreateTaskScreen(),
      ),
      GoRoute(
        name: ViewTaskScreen.routeName,
        path: ViewTaskScreen.routeName,
        builder: (context, state) => const ViewTaskScreen(),
      ),
    ],
  );
}
