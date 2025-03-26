import 'package:flutter/material.dart';
import '../services/auth.dart';
import 'chatbot_screen.dart';
import 'meds_tracker.dart'; // Correct import
import 'caregiver_page.dart'; // Correct import
import 'profile_page.dart'; // Correct import
import '../navigation_panel.dart'; // Import the NavigationPanel
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

final AuthService _authService = AuthService();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  static final List<Widget> _pages = <Widget>[
    Center(child: Text('Welcome to the Home Page!')),
    MedsTrackerPage(), // Correct method
    CaregiverScreen(), // Correct method
    ChatbotScreen(), // Add ChatbotScreen to the pages list
    ProfilePage(), // Correct method
  ];

  static final List<String> _titles = <String>[
    'Home Page',
    'Medical Tracker',
    'Caregiver',
    'Chatbot',
    'Profile', // Add title for Chatbot
  ];

  int _selectedIndex = 0; // Add selectedIndex to HomePageState

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]), // Update the title dynamically
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Use the selected index from HomePageState
      bottomNavigationBar: NavigationPanel(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ), // Use the NavigationPanel widget
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String userNickname;

  const HomeScreen({super.key, required this.userNickname});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),  
        ],
      ),
      body: Center(
        child: Text('${_getGreeting()}, $userNickname!'),
      ),
    );
  }
}
