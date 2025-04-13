import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/services/chatbot_api_handler.dart';

class ReportBulletpoint {
  static const String sleep_quality = "";
  static const String heart_rate = "";
  static const String step_count = "";
  static const String calories_burned = "";
  static const String hydration = "";
  static const String meds_trackerinfo = "";
}

Future<String> generateReportBulletpoint(final String apiKey, String context, String message) async {
  String combinedMessage = '$context: $message';
  String apiResponse = await getGeminiResponseQuick(apiKey, combinedMessage);
  return apiResponse;
}

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
  final String _apiKey = dotenv.env["GEMINI_API_KEY"]!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Healthcare Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sleep Quality',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Average Sleep Quality: 85%'),
                    SizedBox(height: 4),
                    Text('Hours of Sleep (Last 7 Days): 7h, 6h, 8h, 7h, 6h, 7h, 8h'),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Heart Rate',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Resting Heart Rate: 72 bpm'),
                    SizedBox(height: 4),
                    Text('Average Heart Rate (Last 7 Days): 75 bpm'),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step Count',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Total Steps (Last 7 Days): 56,000 steps'),
                    SizedBox(height: 4),
                    Text('Daily Average: 8,000 steps'),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calories Burned',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Total Calories Burned (Last 7 Days): 14,000 kcal'),
                    SizedBox(height: 4),
                    Text('Daily Average: 2,000 kcal'),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hydration',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Average Water Intake (Last 7 Days): 2.5L/day'),
                    SizedBox(height: 4),
                    Text('Recommended: 3L/day'),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hydration',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    FutureBuilder<String>(
                      future: generateReportBulletpoint(_apiKey, ReportBulletpoint.meds_trackerinfo, "Prompt Gemini further"),
                      builder: (context, snapshot) { // actually ReportBulletpoint.meds_trackerinfo should not be static field, it should be assigned some value fetched by getMedicalAdherence from services/medical_adherence_service.dart
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text('Loading...');
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(snapshot.data ?? 'No data');
                        }
                      },
                    ),
                    SizedBox(height: 4),
                    Text('Recommended: 3L/day'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}