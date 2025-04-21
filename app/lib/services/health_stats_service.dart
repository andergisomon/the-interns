import 'package:cloud_firestore/cloud_firestore.dart';

class HealthStats {
  final double sleepQuality;
  final double heartRate;
  final int stepCount;
  final double caloriesBurned;
  final double hydration;

  HealthStats({
    required this.sleepQuality,
    required this.heartRate,
    required this.stepCount,
    required this.caloriesBurned,
    required this.hydration,
  });

  factory HealthStats.fromMap(Map<String, dynamic> data) {
    return HealthStats(
      sleepQuality: data['sleep_quality']?.toDouble() ?? 0.0,
      heartRate: data['heart_rate']?.toDouble() ?? 0.0,
      stepCount: data['step_count']?.toInt() ?? 0,
      caloriesBurned: data['calories_burned']?.toDouble() ?? 0.0,
      hydration: data['hydration']?.toDouble() ?? 0.0,
    );
  }
}

class HealthStatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<HealthStats> getHealthStats(String userId) async {
    final snapshot = await _firestore
        .collection('medicalTracker - users')
        .doc(userId)
        .collection('healthStats')
        .get();

    // Create a temporary map to hold all the pieces
    Map<String, dynamic> dataMap = {};

    for (var doc in snapshot.docs) {
      dataMap.addAll(doc.data());
    }

    return HealthStats.fromMap(dataMap);
  }
}
