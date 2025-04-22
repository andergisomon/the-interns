import 'package:flutter/material.dart';
import '../services/auth.dart';
import 'chatbot_screen.dart';
import 'meds_tracker.dart'; // Correct import
import 'caregiver_page.dart'; // Correct import
import 'profile_page.dart'; // Correct import
import '../navigation_panel.dart'; // Import the NavigationPanel
<<<<<<< HEAD

=======
// import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences; Not needed anymore
>>>>>>> e9039281b89ac1a45faadd47484394a3aa946e89

final AuthService _authService = AuthService();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static final List<Widget> _pages = <Widget>[
    HomeScreen(userNickname: 'Harold'), // Updated to use HomeScreen
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

  String _getPathToSplash() { // yes i know i should just make a method that returns both but this works doesnt it
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'assets/images/home_morning.jpg';
    } else if (hour < 18) {
      return 'assets/images/home_afternoon.jpg';
    } else {
      return 'assets/images/home_evening_2.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
            height: 225,
            child: Image(
              image: AssetImage(_getPathToSplash()),
            )
              ),
              SizedBox(height: 12.0,),
              Text(
                '${_getGreeting()}, $userNickname!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's stats🎯",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Steps🏃: 5,432'),
                          Text('Calories burned🔥: 320'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Sleep: 7h 30m'),
                          Text('Sleep quality: Great'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickAction(
                    context,
                    icon: Icons.local_hospital,
                    label: 'Doctor',
                    onTap: () {
                      // Navigate to doctor appointment page
                    },
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.medication,
                    label: 'Medications',
                    onTap: () {
                      // Navigate to medications page
                    },
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.fitness_center,
                    label: 'Fitness',
                    onTap: () {
                      // Navigate to fitness tracker
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '"Take care of your body. It’s the only place you have to live." - Jim Rohn',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(icon, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
