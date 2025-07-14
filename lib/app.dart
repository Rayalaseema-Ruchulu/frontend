import 'package:common/network.dart';
import 'package:flutter/material.dart';
import 'package:rr_app/pages/navigation.dart';

class App extends StatelessWidget {
  const App({super.key});

  static final apiClient = ApiClient.init();

  @override
  Widget build(BuildContext context) {
    final lightThemeData = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    );
    final darkThemeData = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'Restaurant App',
      theme: lightThemeData,
      darkTheme: darkThemeData,
      home: const Navigation(),
    );
  }
}
