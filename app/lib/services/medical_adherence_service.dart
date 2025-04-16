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

  Future<MedicalAdherence> getMedicalAdherence_demo(String userId) async {
    MedicalAdherence first_medication = (await getMedicalAdherence(userId))[0];
    return first_medication;
  }

  //   Future<MedicalAdherence> getMedicalAdherence_demo(String userId) async {
  //     final snapshot = await _firestore
  //         .collection('medicalTracker - users')
  //         .doc(userId)
  //         .collection('medications')
  //         .doc('8D5LiUpxr9ZnIILDuDPF') // Firestore will not accept this query
  //         .get();
      
  //     // Create a temporary map to hold all the pieces
  //     Map<String, dynamic> dataMap = {};

  //     dataMap.addAll(snapshot.data()!);

  //     return MedicalAdherence.fromMap(dataMap);
  // }

}