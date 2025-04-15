import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lebui_modsu/services/health_stats_service.dart';
import '/services/chatbot_api_handler.dart';
import '/services/medical_adherence_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ReportBulletpoint {
  static const String sleep_quality = "Generate a brief description of a user's sleep quality. Provide any reasonable sleep quality score that the user had.";
  static const String heart_rate = "Generate a brief description of the heart rate history of a user in the past few weeks. Provide any reasonable number.";
  static const String step_count = "Generate a brief description of a user's total number of steps. Provide any number.";
  static const String calories_burned = "Generate a brief description of the total amount of calories burned by the user. Provide any number.";
  static const String hydration = "Generate a brief description of how hydrated the user had been. Provide any reasonable hydration score that the user had.";
  static const String meds_info_medication_name = "";  
  static const String meds_info_dosage = "Generate a brief description of the tracked medications the user is on. Simply describe the information into easily understandable language.";
  static const String meds_info_unit = "";
  static const String meds_info_start_date = "";
  static const String meds_info_end_date = "";
  static const String meds_info_frequency = "";
  static const String meds_info_times_per_day = "";
}
final user = FirebaseAuth.instance.currentUser!;
final HealthStatsService health_stats_service = HealthStatsService();
final MedicalAdherenceService medical_adherence_service = MedicalAdherenceService();

Future<String> generateReportBulletpoint(final String apiKey, String context) async {
  String message = "";

  switch (context) {
    case ReportBulletpoint.meds_info_dosage:
      message = (await medical_adherence_service.getMedicalAdherence_simple(user.uid)).dosage;
      break;

    case ReportBulletpoint.sleep_quality:
      message = (await health_stats_service.getHealthStats(user.uid)).sleepQuality as String;
      break;

    case ReportBulletpoint.heart_rate:
      message = (await health_stats_service.getHealthStats(user.uid)).heartRate as String;
      break;

    case ReportBulletpoint.step_count:
      message = (await health_stats_service.getHealthStats(user.uid)).stepCount as String;
      break;

    case ReportBulletpoint.calories_burned:
      message = (await health_stats_service.getHealthStats(user.uid)).caloriesBurned as String;
      break;

    case ReportBulletpoint.hydration:
      message = (await health_stats_service.getHealthStats(user.uid)).hydration as String;
      break;
  }

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
                      future: generateReportBulletpoint(_apiKey, ReportBulletpoint.meds_info_dosage),
                      builder: (context, snapshot) {
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