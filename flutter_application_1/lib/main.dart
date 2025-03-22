// For merging with Mc, this main file should be integrated into his, or vice versa

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'chatbot_screen.dart';
import 'second_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  OverlayEntry? overlayEntry;

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Tracker(),
    ChatbotScreen(),
    // Add more screens here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
          bodyMedium: TextStyle(fontFamily: 'Work Sans Medium'),
          bodyLarge: TextStyle(fontFamily: 'Work Sans Medium'),
          headlineLarge: TextStyle(fontFamily: 'Work Sans Medium'),
          titleLarge: TextStyle(fontFamily: 'Work Sans Semibold'),
        ),
      ),
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.fact_check),
              label: 'Tracker',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat),
              label: 'Chatbot',
            ),
            // Add more destinations here
          ],
        ),
      ),
    );
  }
}
