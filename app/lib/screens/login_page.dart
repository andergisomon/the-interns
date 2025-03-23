import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              print('Sign in button pressed');
              User? user = await _authService.signInWithGoogle();
              if (user != null) {
                print('Sign in successful: ${user.email}');
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                print('Sign in failed');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to sign in with Google')),
                );
              }
            } catch (e) {
              print('Error during sign-in: $e');
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