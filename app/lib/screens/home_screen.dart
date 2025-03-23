import 'package:flutter/material.dart';
import '../services/auth.dart';
import 'chatbot_screen.dart';
import 'medical_adherence.dart'; // Correct import
import 'caregiver_page.dart'; // Correct import
import 'profile_page.dart'; // Correct import
import '../navigation_panel.dart'; // Import the NavigationPanel

final AuthService _authService = AuthService();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Offset _offset = Offset(100, 100);

  static final List<Widget> _pages = <Widget>[
    Center(child: Text('Welcome to the Home Page!')),
    MedicationAdherenceScreen(), // Correct method
    CaregiverPage(), // Correct method
    ProfilePage(), // Correct method
  ];

  static final List<String> _titles = <String>[
    'Home Page',
    'Medical Adherence',
    'Caregiver',
    'Profile',
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
      body: Stack(
        children: [
          _pages[_selectedIndex], // Use the selected index from HomePageState
          Positioned(
            left: _offset.dx,
            top: _offset.dy,
            child: Draggable(
              feedback: _buildChatBubble(),
              childWhenDragging: Container(),
              onDragEnd: (details) {
                setState(() {
                  _offset = details.offset;
                });
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatbotScreen()),
                  );
                },
                child: _buildChatBubble(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationPanel(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ), // Use the NavigationPanel widget
    );
  }

  Widget _buildChatBubble() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.chat, color: Colors.white),
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
