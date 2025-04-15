import 'package:cloud_firestore/cloud_firestore.dart';
import '../dataframe/medical_adherence_df.dart';

class MedicalAdherenceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMedicalAdherence(MedicalAdherence adherence) async {
    await _firestore
        .collection('medicalTracker - users')
        .doc(adherence.userId)
        .collection('medications')
        .add(adherence.toMap());
  }

  Future<List<MedicalAdherence>> getMedicalAdherence(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('medicalTracker - users')
        .doc(userId)
        .collection('medications')
        .get();
    return querySnapshot.docs
        .map((doc) => MedicalAdherence.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

    Future<MedicalAdherence> getMedicalAdherence_simple(String userId) async {
      final snapshot = await _firestore
          .collection('medicalTracker - users')
          .doc(userId)
          .collection('medications')
          .get();
      
      // Create a temporary map to hold all the pieces
      Map<String, dynamic> dataMap = {};

      for (var doc in snapshot.docs) {
        dataMap.addAll(doc.data());
      }

      return MedicalAdherence.fromMap(dataMap);
  }

}