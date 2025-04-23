import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lebui_modsu/services/notifications.dart';
import 'package:logging/logging.dart';
import 'screens/startup_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/first_time_login.dart'; // Ensure this file exists and contains the class FirstTimeLoginPage
import 'screens/home_screen.dart' as home;
import 'screens/chatbot_screen.dart';
import 'screens/meds_tracker.dart';
import 'screens/caregiver_page.dart';
import 'screens/profile_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  _setupLogging();

  // Initialize flutter_local_notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  NotificationsService().initNotification();


  runApp(MyApp());
  await dotenv.load(fileName: ".env");

}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // Use logging framework instead of print
    Logger('MyApp').info('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = navigatorKey.currentState?.context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      title: 'Suaunaau',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('zh', ''), // Mandarin
        Locale('my', ''), // Malay
        Locale('th', ''), // Thai
      ],
      locale: _locale,
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
      initialRoute: '/', // Default route
      routes: {
        '/': (context) {
         
          if (AppLocalizations.of(context) == null) {
            return const Center(child: Text('Localization not loaded'));
          }
          return const StartupPage();
        },
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