import 'package:flutter/material.dart';

class WellnessReportScreen extends StatelessWidget {
  const WellnessReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wellness Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  child: Image(image: AssetImage('assets/images/wellness_report/wellness_generate.png')
                ),
              ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                      Text(
                          'At a glance',
                          style: TextStyle(fontSize: 24, fontFamily: 'Work Sans Black'),
                          textAlign: TextAlign.center,
                        )
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                child:
                Text(
                  'Generate a brief report of your wellness based on relevant data. Track your health and find actionable steps to improve.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                )
              ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GeneratedReportScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8A2BE2),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16, fontFamily: 'Work Sans Semibold'),
                ),
              child: const Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }
}

class GeneratedReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.primaries[index % Colors.primaries.length],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title ${index + 1}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Subtitle ${index + 1}',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}