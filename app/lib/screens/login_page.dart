import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth.dart';
import '../services/first_time_login_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _checkFirstTimeLogin(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firstTimeLoginService = FirstTimeLoginService();
      final firstTimeLogin = await firstTimeLoginService.getFirstTimeLogin(user.uid);
      if (firstTimeLogin == null) {
        Navigator.pushReplacementNamed(context, '/first_time_login');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final User? user = await authService.signInWithGoogle();
              if (user != null) {
                _checkFirstTimeLogin(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to sign in with Google')),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error during sign-in: $e')),
              );
            }
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}