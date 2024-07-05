import 'package:flutter/foundation.dart' show immutable;
import 'package:go_router/go_router.dart';
import 'package:todo_app/data/backend/authenticator.dart';

import '../presentation/screens/create_task_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/view_task_screen.dart';

@immutable
class AppRoutes {
  const AppRoutes._();

  static const _authenticator = Authenticator();

  static final router = GoRouter(
    initialLocation: _authenticator.isAlreadyLoggedIn ? HomeScreen.routeName : LoginScreen.routeName,
    redirect: (context, state) {
      final isLoggedIn = _authenticator.isAlreadyLoggedIn;
      final isLoggingIn = state.uri.toString() == LoginScreen.routeName;

      if (!isLoggedIn && !isLoggingIn) {
        return LoginScreen.routeName;
      }
      if (isLoggedIn && isLoggingIn) {
        return HomeScreen.routeName;
      }
      return null;
    },
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
