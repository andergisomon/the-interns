import 'package:cloud_firestore/cloud_firestore.dart';
import '../dataframe/medical_adherence_df.dart';

class MedicalAdherenceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMedicalAdherence(MedicalAdherence adherence) async {
    final adherenceMap = adherence.toMap();

    // Ensure reminderTimes is stored as List<Map<String, int>>
    adherenceMap['reminderTimes'] = adherence.reminderTimes
        .map((time) => {
              'hour': time['hour'] as int,
              'minute': time['minute'] as int,
            })
        .toList();

    await _firestore
        .collection('medicalTracker - users')
        .doc(adherence.userId)
        .collection('medications')
        .add(adherenceMap);
  }

  Future<List<MedicalAdherence>> getMedicalAdherence(String userId) async {
    final List<MedicalAdherence> adherenceList = [];
    try {
      // Query the medications subcollection for the specific user
      final querySnapshot = await _firestore
          .collection('medicalTracker - users')
          .doc(userId)
          .collection('medications')
          .get();

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        adherenceList.add(MedicalAdherence(
          userId: data['userId'],
          medicationName: data['medicationName'],
          dosage: data['dosage'],
          unit: data['unit'],
          startDate: DateTime.parse(data['startDate']),
          endDate: DateTime.parse(data['endDate']),
          frequency: data['frequency'],
          timesPerDay: data['timesPerDay'],
          reminderTimes: (data['reminderTimes'] as List<dynamic>)
              .map((time) => {
                    'hour': time['hour'] as int,
                    'minute': time['minute'] as int,
                  })
              .toList(),
        ));
      }
    } catch (e) {
      print('Error fetching medical adherence: $e');
    }
    return adherenceList;
  }

  Future<MedicalAdherence> getMedicalAdherence_demo(String userId, int index) async {
    MedicalAdherence first_medication = (await getMedicalAdherence(userId))[index];
    return first_medication;
  }

  Future<int> howLong(String userId) async {
    List<MedicalAdherence> list = await getMedicalAdherence(userId);
    return list.length;
  }

}
