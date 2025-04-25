import 'package:cloud_firestore/cloud_firestore.dart';
import '../dataframe/medical_adherence_df.dart';

class MedicalAdherenceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save a medication record under the correct clinic and patient
  Future<void> saveMedicalAdherence(String clinicId, MedicalAdherence adherence) async {
    final adherenceMap = adherence.toMap();

    // Ensure reminderTimes is stored as List<Map<String, int>>
    adherenceMap['reminderTimes'] = adherence.reminderTimes
        .map((time) => {
              'hour': time['hour'] as int,
              'minute': time['minute'] as int,
            })
        .toList();

    await _firestore
        .collection('clinics')
        .doc(clinicId)
        .collection('patients')
        .doc(adherence.userId)
        .collection('medications')
        .add(adherenceMap);
  }

  /// Fetch all medication adherence entries for a specific user
  Future<List<MedicalAdherence>> getMedicalAdherence(String clinicId, String userId) async {
    final List<MedicalAdherence> adherenceList = [];
    try {
      final querySnapshot = await _firestore
          .collection('clinics')
          .doc(clinicId)
          .collection('patients')
          .doc(userId)
          .collection('medications')
          .get();

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        adherenceList.add(MedicalAdherence(
          userId: userId,
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

  /// Return one medication by index
  Future<MedicalAdherence> getMedicalAdherence_demo(String clinicId, String userId, int index) async {
    MedicalAdherence med = (await getMedicalAdherence(clinicId, userId))[index];
    return med;
  }

  /// Return how many medications a user has
  Future<int> howLong(String clinicId, String userId) async {
    List<MedicalAdherence> list = await getMedicalAdherence(clinicId, userId);
    return list.length;
  }
}
