import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lebui_modsu/services/health_stats_service.dart';
import '/services/chatbot_api_handler.dart';
import '/services/medical_adherence_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_markdown/flutter_markdown.dart';



class ReportBulletpoint {
  static const String sleep_quality = "Generate a brief description of a user's sleep quality. You may refer to the user using a second person pronoun. Provide any reasonable sleep quality score that the user had.";
  static const String heart_rate = "Generate a brief description of the heart rate history of a user in the past few weeks. You may refer to the user using a second person pronoun. Provide any reasonable number.";
  static const String step_count = "Generate a brief description of a user's total number of steps. You may refer to the user using a second person pronoun. Provide any number.";
  static const String calories_burned = "Generate a brief description of the total amount of calories burned by the user. You may refer to the user using a second person pronoun. Provide any number.";
  static const String hydration = "Generate a brief description of how hydrated the user had been. You may refer to the user using a second person pronoun. Provide any reasonable hydration score that the user had.";
  static const String meds_info = "Generate a brief description of the tracked medications the user is on. You may refer to the user using a second person pronoun. Simply describe the information into easily understandable language.\n";
}
final user = FirebaseAuth.instance.currentUser!;
final HealthStatsService health_stats_service = HealthStatsService();
final MedicalAdherenceService medical_adherence_service = MedicalAdherenceService();

Future<String> generateReportBulletpoint(final String apiKey, String context) async {
  String message = "";

  switch (context) {
    case ReportBulletpoint.meds_info:
      final length = await medical_adherence_service.howLong(user.uid);
      int i = 0;
      while (i < length) {
        final medication = await medical_adherence_service.getMedicalAdherence_demo(user.uid, i);
        String _message = '\nMedication ${i} name is ${medication.medicationName}, the dosage is ${medication.dosage}, with unit: ${medication.unit}, taken x${medication.timesPerDay} times a day.';
        message = message + _message;
        i = i + 1;
      }
      break;

    case ReportBulletpoint.sleep_quality:
      final healthStats = await health_stats_service.getHealthStats(user.uid);
      message = 'Sleep quality score is ${healthStats.sleepQuality.toString()}';
      break;

    case ReportBulletpoint.heart_rate:
      final healthStats = await health_stats_service.getHealthStats(user.uid);
      message = 'Heart rate is ${healthStats.heartRate.toString()}';
      break;

    case ReportBulletpoint.step_count:
      final healthStats = await health_stats_service.getHealthStats(user.uid);
      message = 'Number of steps is ${healthStats.stepCount.toString()}';
      break;

    case ReportBulletpoint.calories_burned:
      final healthStats = await health_stats_service.getHealthStats(user.uid);
      message = 'Amount of calories burned is ${healthStats.caloriesBurned.toString()}';
      break;

    case ReportBulletpoint.hydration:
      final healthStats = await health_stats_service.getHealthStats(user.uid);
      message = 'Level of hydration is ${healthStats.hydration.toString()}';
      break;
  }

  final combinedMessage = '$context: $message';
  final apiResponse = await getGeminiResponseQuick(apiKey, combinedMessage);
  return apiResponse;
}

class WellnessReportScreen extends StatelessWidget {
  const WellnessReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wellness report'),
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
        title: Text('Wellness report'),
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
                    FutureBuilder<String>(
                      future: generateReportBulletpoint(_apiKey, ReportBulletpoint.sleep_quality),
                      builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return MarkdownBody(data: snapshot.data ?? 'No data');
                      }
                      },
                    ),
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
                    FutureBuilder<String>(
                      future: generateReportBulletpoint(_apiKey, ReportBulletpoint.heart_rate),
                      builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return MarkdownBody(data: snapshot.data ?? 'No data');
                      }
                      },
                    ),
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
                    FutureBuilder<String>(
                      future: generateReportBulletpoint(_apiKey, ReportBulletpoint.step_count),
                      builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return MarkdownBody(data: snapshot.data ?? 'No data');
                      }
                      },
                    ),
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
                    FutureBuilder<String>(
                      future: generateReportBulletpoint(_apiKey, ReportBulletpoint.calories_burned),
                      builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return MarkdownBody(data: snapshot.data ?? 'No data');
                      }
                      },
                    ),
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
                      future: generateReportBulletpoint(_apiKey, ReportBulletpoint.hydration),
                      builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return MarkdownBody(data: snapshot.data ?? 'No data');
                      }
                      },
                    ),
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
                      'Current medication',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    FutureBuilder<String>(
                      future: generateReportBulletpoint(_apiKey, ReportBulletpoint.meds_info),
                      builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return MarkdownBody(data: snapshot.data ?? 'No data');
                      }
                      },
                    ),
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