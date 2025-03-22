import 'package:flutter/material.dart';
import 'home_screen.dart';

class Tracker extends StatelessWidget {
  const Tracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medication Tracker')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}