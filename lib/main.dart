import 'package:flutter/material.dart';
import 'routing/app_router.dart';

//Parse Server Configuration
const applicationId = 'ozyaudIHwYKHh1dfumoA6aEbNPTOFkgg8KTIYCBO';
const clientKey = 'yS6fWX5Vu3vtlqEs1YBW6BSxS9T48I5FdBLUg64A';
const parseURL = 'https://parseapi.back4app.com';

/// The main entry point of the application.
void main() {
  runApp(MyApp(router: AppRouter()));
}

/// The root widget of the application, sets up routing and app-wide configuration.
class MyApp extends StatelessWidget {
  final AppRouter router;

  const MyApp({super.key, required this.router});

  /// Builds the MaterialApp with routing and configuration.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDoApp',
      onGenerateRoute: router.generateRoute,
      routes: router.routes,
    );
  }
}
