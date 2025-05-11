import 'package:flutter/material.dart';

import 'package:flutter_demo/screens/home.dart';
import 'package:flutter_demo/screens/login.dart';
import 'package:flutter_demo/screens/task_details.dart';
import 'package:flutter_demo/screens/task_list.dart';
import 'routes.dart';

/// Handles route generation and provides route mappings for the application.
class AppRouter {
  /// Generates a route based on the given [RouteSettings].
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const Login(),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const Home(),
        );
      case Routes.taskDetailsScreen:
        return MaterialPageRoute(
          builder: (_) => const TaskDetails(),
        );
      case Routes.taskScreen:
        return MaterialPageRoute(
          builder: (_) => const TaskList(),
        );
    }
    return null;
  }

  /// Returns a map of route names to their corresponding widget builders.
  Map<String, WidgetBuilder> get routes {
    return {
      '/': (context) => const Home(),
      '/login': (context) => const Login(),
      '/tasks': (context) => const TaskList(),
      '/view-details': (context) => const TaskDetails(),
    };
  }
}
