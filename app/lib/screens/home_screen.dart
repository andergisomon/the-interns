import 'package:flutter/material.dart';
import 'package:lebui_modsu/globals.dart';
import 'package:lebui_modsu/screens/patient_tracker_page.dart';
import '../services/auth.dart';
import 'chatbot_screen.dart';
import 'meds_tracker.dart'; // Correct import
import 'caregiver_page.dart'; // Correct import
import 'profile_page.dart'; // Correct import
import '../navigation_panel.dart'; // Import the NavigationPanel
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final AuthService _authService = AuthService();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Widget> _getPages() {
  return [
    HomeScreen(userNickname: 'Harold'),
    isDoctorGlobal
      ? PatientTrackerPage(clinicId: assignedClinicId ?? 'unknown')
      : MedsTrackerPage(clinicId: assignedClinicId ?? 'unknown'),
    CaregiverScreen(),
    ChatbotScreen(),
    ProfilePage(),
  ];
}


  List<String> get titles => <String>[
    AppLocalizations.of(context)!.navigationTitle1,
    AppLocalizations.of(context)!.navigationTitle2,
    AppLocalizations.of(context)!.navigationTitle3,
    AppLocalizations.of(context)!.navigationTitle4,
    AppLocalizations.of(context)!.navigationTitle5,
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
        title: Text(titles[_selectedIndex]), // Update the title dynamically
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
      body: _getPages()[_selectedIndex],
 // Use the selected index from HomePageState
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

  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return AppLocalizations.of(context)!.greetingsItem1;
    } else if (hour < 18) {
      return AppLocalizations.of(context)!.greetingsItem2;
    } else {
      return AppLocalizations.of(context)!.greetingsItem3;
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
                '${_getGreeting(context)}, $userNickname!',
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
                        AppLocalizations.of(context)!.homeStatsTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.homeSteps + '5,432'),
                          Text(AppLocalizations.of(context)!.homeCaloriesBurned + '320'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.homeSleep + '7h 30m'),
                          Text(AppLocalizations.of(context)!.homeSleepQuality + ' Great'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.homeQuickActions,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickAction(
                    context,
                    icon: Icons.local_hospital,
                    label: AppLocalizations.of(context)!.homeDoctor,
                    onTap: () {
                      // Navigate to doctor appointment page
                    },
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.medication,
                    label: AppLocalizations.of(context)!.homeMedications,
                    onTap: () {
                      // Navigate to medications page
                    },
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.fitness_center,
                    label: AppLocalizations.of(context)!.homeFitness,
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
                    AppLocalizations.of(context)!.homeQuote,
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
