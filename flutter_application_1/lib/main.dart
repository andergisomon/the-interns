// For merging with Mc, this main file should be integrated into his, or vice versa

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'chatbot_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: ChatMessage.navigatorKey,
      title: 'Suau',
      theme: ThemeData(
        textTheme: const TextTheme(
          labelSmall: TextStyle(fontFamily: 'Work Sans Medium'),
          labelMedium: TextStyle(fontFamily: 'Work Sans Medium'),
          labelLarge: TextStyle(fontFamily: 'Work Sans Medium'),
          bodySmall: TextStyle(fontFamily: 'Work Sans Medium'),
          bodyMedium: TextStyle(fontFamily: 'Work Sans Medium'), // Set default font here
          bodyLarge: TextStyle(fontFamily: 'Work Sans Medium'),
          headlineLarge: TextStyle(fontFamily: 'Work Sans Medium'), // You can set different fonts for different text styles.
          titleLarge: TextStyle(fontFamily: 'Work Sans Semibold'),
        ),
      ),
      home: FirstRoute(),
    );
  }
}

