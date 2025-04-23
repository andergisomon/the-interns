import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lebui_modsu/main.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  _StartupPageState createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
                if (user != null) {
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
          ],
        ),
      ),
    );
  }
}
