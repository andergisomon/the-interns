import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lebui_modsu/screens/first_time_login.dart';
import 'package:logging/logging.dart';
import 'screens/startup_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_screen.dart' as home;
import 'screens/chatbot_screen.dart';
import 'screens/meds_tracker.dart';
import 'screens/caregiver_page.dart';
import 'screens/profile_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  _setupLogging();
  runApp(MyApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // Use logging framework instead of print
    Logger('MyApp').info('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        textTheme: const TextTheme(
          labelSmall: TextStyle(fontFamily: 'Work Sans Medium'),
          labelMedium: TextStyle(fontFamily: 'Work Sans Medium'),
          labelLarge: TextStyle(fontFamily: 'Work Sans Medium'),
          bodySmall: TextStyle(fontFamily: 'Work Sans'),
          bodyMedium: TextStyle(fontFamily: 'Work Sans Medium'),
          bodyLarge: TextStyle(fontFamily: 'Work Sans Medium'),
          headlineLarge: TextStyle(fontFamily: 'Work Sans Medium'),
          headlineSmall: TextStyle(fontFamily: 'Work Sans Medium'),
          titleLarge: TextStyle(fontFamily: 'Work Sans Semibold'),
          titleMedium: TextStyle(fontFamily: 'Work Sans Semibold'),
          titleSmall: TextStyle(fontFamily: 'Work Sans Medium'),
        ),
      ),
      initialRoute: '/', // originally just '/',
      routes: {
        '/': (context) => const StartupPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/firstForm': (context) => const FirstTimeLoginPage(),
        '/home': (context) => const home.HomePage(),
        '/chatbot': (context) => const ChatbotScreen(),
        '/meds_tracker': (context) => const MedsTrackerPage(),
        '/caregiver': (context) => const CaregiverScreen(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}