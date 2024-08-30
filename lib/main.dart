import 'package:flutter/material.dart';

import 'speedometer/speed_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepOrange,
      ),
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.orange,
      ),
      themeMode: ThemeMode.system,
      home: const LocationServiceWidget(),
    );
  }
}
