import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'screens/startup_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_screen.dart' as home;
import 'screens/chatbot_screen.dart';
import 'screens/medical_adherence.dart';
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
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartupPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const home.HomePage(),
        '/chatbot': (context) => const ChatbotScreen(),
        '/medical_adherence': (context) => const MedicalAdherencePage(),
        '/caregiver': (context) => const CaregiverScreen(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}