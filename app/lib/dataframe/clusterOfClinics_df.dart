import 'package:cloud_firestore/cloud_firestore.dart';
import '../dataframe/doctor_df.dart';
import '../dataframe/patient_df.dart';

class ClinicDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDoctor(String clinicId, Doctor doctor) async {
    await _firestore
        .collection('clinics')
        .doc(clinicId)
        .collection('doctors')
        .doc(doctor.doctorId)
        .set(doctor.toMap());
  }

  Future<void> addPatient(String clinicId, Patient patient) async {
    await _firestore
        .collection('clinics')
        .doc(clinicId)
        .collection('patients')
        .doc(patient.patientId)
        .set(patient.toMap());
  }

  Future<List<Doctor>> getDoctors(String clinicId) async {
    final querySnapshot = await _firestore
        .collection('clinics')
        .doc(clinicId)
        .collection('doctors')
        .get();

    return querySnapshot.docs
        .map((doc) => Doctor.fromMap(doc.data()))
        .toList();
  }

  Future<List<Patient>> getPatients(String clinicId) async {
    final querySnapshot = await _firestore
        .collection('clinics')
        .doc(clinicId)
        .collection('patients')
        .get();

    return querySnapshot.docs
        .map((doc) => Patient.fromMap(doc.data()))
        .toList();
  }

  Future<List<Clinic>> getClinics() async {
    try {
      final querySnapshot = await _firestore.collection('clinics').get();
      return querySnapshot.docs.map((doc) => Clinic.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error fetching clinics: $e');
      return [];
    }
  }
}

class Clinic {
  final String id;
  final String name;

  Clinic({required this.id, required this.name});

  factory Clinic.fromMap(Map<String, dynamic> map) {
    return Clinic(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}