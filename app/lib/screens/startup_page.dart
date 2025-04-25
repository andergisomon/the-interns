import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lebui_modsu/main.dart';
import 'package:lebui_modsu/screens/home_screen.dart';
import 'package:lebui_modsu/services/clinic_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lebui_modsu/globals.dart';


class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  _StartupPageState createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController icController = TextEditingController(); // Moved here
  String? selectedClinic; // Moved here
  bool _rememberMe = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Locale _selectedLocale = const Locale('en', ''); // Default locale


    Future<void> _signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final User? user = userCredential.user;
      if (user != null) {
        await _verifyDoctorFromFirestore(user.uid); // ✅ Auto check
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print('Error during sign-in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during sign-in: $e')),
      );
    }
  }


  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Error during Google Sign-In: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null, // const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Text(
                AppLocalizations.of(context)!.homeWelcomeMessage,
                style: const TextStyle(
                  fontFamily: 'Work Sans Black',
                  color: Colors.black,
                  fontSize: 38,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.loginEmailPlaceholder,
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.loginPasswordPlaceholder,
              ),
              obscureText: true,
            ),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                Text(AppLocalizations.of(context)!.loginRememberMe),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: Text(AppLocalizations.of(context)!.loginButton),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgot_password');
              },
              child: Text(AppLocalizations.of(context)!.loginForgotPassword),
            ),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.loginNewUser),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text(AppLocalizations.of(context)!.loginSignupNow),
            ),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.loginSignupWith),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
              User? user = await _signInWithGoogle();

                    if( isDoctorGlobal = false)
                    {

                      assignedClinicId = await ClinicService().getAssignedClinicIdForPatient(user!.uid);
                    }

              if (user != null) {
                await _verifyDoctorFromFirestore(user.uid); // ✅ Auto check
                Navigator.pushReplacementNamed(context, '/firstForm');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.loginGoogleSignInError),
                  ),
                );
              }
            },

              child: Image.asset(
                'assets/signin-assets/Android/png@1x/light/android_light_rd_na@1x.png',
                height: 50.0,
              ), // Ensure you have the Google sign-in button asset
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            // Row for Language Dropdown and Verify Role Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
              children: [
                // Language Dropdown
                DropdownButton<Locale>(
                  value: _selectedLocale,
                  icon: const Icon(Icons.language),
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      setState(() {
                        _selectedLocale = newLocale;
                      });
                      
                      // Update the app's locale
                      MyApp.setLocale(context, newLocale);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: Locale('en', ''),
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: Locale('zh', ''),
                      child: Text('中文'),
                    ),
                    DropdownMenuItem(
                      value: Locale('my', ''),
                      child: Text('Malay'),
                    ),
                    DropdownMenuItem(
                      value: Locale('th', ''),
                      child: Text('ภาษาไทย'),
                    ),
                  ],
                ),
                const SizedBox(width: 20), // Add spacing between the buttons

                // Verify Role Button
                ElevatedButton(
                  onPressed: () async {
                    // Show a dialog to prompt the user for IC and clinic selection
                    await _showVerifyRoleDialog();
                  },
                  child: const Text('Verify Role'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Shows a dialog to prompt the user for IC and clinic selection
  Future<void> _showVerifyRoleDialog() async {
    List<DropdownMenuItem<String>> clinicItems = [];

    // Fetch clinic names from Firestore
    try {
      print('Fetching clinics from Firestore...');
      final clinics = await FirebaseFirestore.instance.collection('clinics').get();
      clinicItems = clinics.docs.map((doc) {
        print('Fetched clinic: ${doc['name']} (ID: ${doc.id})'); // Log each clinic
        return DropdownMenuItem(
          value: doc.id, // Use the document ID as the value
          child: Text(doc['name']), // Use the 'name' field for display
        );
      }).toList();
      print('Clinics fetched successfully.');
    } catch (e) {
      print('Error fetching clinics: $e'); // Log the error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load clinics')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verify Role'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dropdown for selecting a clinic
              DropdownButton<String>(
                value: selectedClinic,
                hint: const Text('Select Clinic'),
                items: clinicItems,
                onChanged: (String? value) {
                  setState(() {
                    selectedClinic = value;
                    print('Selected clinic updated to: $selectedClinic'); // Log selected clinic
                  });
                },
              ),
              const SizedBox(height: 10),

              // TextField for entering IC
              TextField(
                controller: icController,
                decoration: const InputDecoration(
                  labelText: 'Enter IC Number',
                ),
                onChanged: (value) {
                  print('IC entered: $value'); // Log IC input
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                print('Dialog canceled.'); // Log cancel action
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                print('Verify button clicked.'); // Log verify button click
                if (selectedClinic == null || icController.text.isEmpty) {
                  print('Validation failed: Missing clinic or IC.'); // Log validation failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                await _verifyDoctorRole();
                Navigator.pop(context);
              },
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );
  }



  bool _isDoctorTrue(bool isDoctor) {
    isDoctorGlobal = isDoctor;
    return isDoctor;
  }




  Future<void> _verifyDoctorRole() async {
    final clinicService = ClinicService();
    final isValid = await clinicService.verifyDoctorIC(selectedClinic!, int.parse(icController.text));

    if (isValid) {
      _isDoctorTrue(true); // Pass true for doctors
      print('IC verification successful.'); // Log successful verification
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
      await clinicService.saveUserRole(
      userId,
      'doctor',
      selectedClinic!,
      name: 'Unknown',  // You can replace this with actual value
      email: 'Unknown',
      ic: int.parse(icController.text),
    );

    } else {
      print('IC verification failed.'); // Log failed verification
      _isDoctorTrue(false); // Pass false for non-doctors
    }
  }

  Future<void> _verifyDoctorFromFirestore(String userId) async {
  try {
    final docSnapshot = await FirebaseFirestore.instance
        .collectionGroup('doctors')
        .where('doctorId', isEqualTo: userId)
        .get();

    final clinicService = ClinicService();
    if (docSnapshot.docs.isNotEmpty) {
      isDoctorGlobal = true;
      assignedClinicId = await clinicService.getAssignedClinicId(userId);
      print('✅ Doctor verified from Firestore: clinicId = $assignedClinicId');
    } else {
      isDoctorGlobal = false;
      print('❌ User is not a doctor');
    }
  } catch (e) {
    print('Error checking doctor role from Firestore: $e');
  }
  }


}
