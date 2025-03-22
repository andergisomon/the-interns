import 'package:flutter/material.dart';
import 'second_route.dart';
import 'chatbot_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        const Icon(Icons.lightbulb, size: 40, color: Colors.amber),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Smart Ideas',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Explore innovative concepts.',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'This card showcases some smart ideas and innovative concepts that can improve your daily life. Learn more about how to implement them.',
                      style: TextStyle(fontSize: 14, fontFamily: 'Work Sans'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
           Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        const Icon(Icons.medication_liquid, size: 40, color: Colors.blue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Track your medication',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Free the hassle of remembering.',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Use our Tracker feature to track medicines you're on. Tracker helps you organize dosage, frequencies, and reminders easily.",
                      style: TextStyle(fontSize: 14, fontFamily: 'Work Sans'),
                    ),
                    const SizedBox(height: 16), // Add some space before the button
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: FilledButton(
                        onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const ChatbotScreen()),
                            ); // Go to tracker
                        },
                        child: const Text('Track Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Add more widgets here if needed
            const Text('Additional home screen content'),
          ],
        ),
      ),
    );
  }
}
