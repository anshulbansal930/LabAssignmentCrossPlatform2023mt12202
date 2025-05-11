import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../main.dart';

/// The Home screen widget that determines the initial navigation based on user authentication.
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

/// State class for Home, checks user authentication and navigates accordingly.
class _HomeState extends State<Home> {
  /// Loads the current user and navigates to the appropriate screen.
  Future<void> load() async {
    await Parse().initialize(applicationId, parseURL,
        clientKey: clientKey, autoSendSessionId: true);
    ParseUser.currentUser().then((value) {
      if (value == null) {
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        Navigator.of(context).pushReplacementNamed('/tasks');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('Loading...'),
    ));
  }
}
