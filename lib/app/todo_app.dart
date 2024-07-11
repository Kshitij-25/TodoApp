import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/constants/app_routes.dart';

import '../constants/theme/theme.dart';
import '../constants/theme/util.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "TaskTrackr",
      themeMode: ThemeMode.system,
      darkTheme: theme.dark(),
      theme: theme.light(),
      routeInformationParser: AppRoutes.router.routeInformationParser,
      routerDelegate: AppRoutes.router.routerDelegate,
      routeInformationProvider: AppRoutes.router.routeInformationProvider,
    );
  }
}
