import 'package:lebui_modsu/dataframe/medical_adherence_df.dart';

import '../dataframe/clusterOfClinics_df.dart';
import '../dataframe/doctor_df.dart';
import '../dataframe/patient_df.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClinicService {
  final ClinicDatabase _clinicDatabase = ClinicDatabase();

  /// Verifies if the IC exists in the selected clinic's `doctors` subcollection
  Future<bool> verifyDoctorIC(String clinicId, int ic) async {
    try {
      final doctors = await _clinicDatabase.getDoctors(clinicId);
      for (var doctor in doctors) {
        print('Doctor data: ${doctor.toMap()}'); // Log raw doctor data
      }
      return doctors.any((doctor) {
        final doctorIC = doctor.ic;
        // Log doctor IC for debugging
        print('Doctor IC: $doctorIC');
        return doctorIC == ic;
      });
    } catch (e) {
      print('Error verifying doctor IC: $e');
      return false;
    }
  }

  /// Saves the user's role and clinic information in Firestore
  Future<void> saveUserRole(String userId, String role, String clinicId) async {
    try {
      await _clinicDatabase.addDoctor(
        clinicId,
        Doctor(
          doctorId: userId,
          name: 'Unknown', // Replace with actual name if available
          email: 'Unknown', // Replace with actual email if available
          ic: 1234, // Replace with actual IC if available
        ),
      );
    } catch (e) {
      print('Error saving user role: $e');
    }
  }
  

  
  /// Fetches the list of clinics from Firestore
  Future<List<Map<String, dynamic>>> fetchClinics() async {
    try {
      final clinics = await _clinicDatabase.getClinics();
      return clinics.map((clinic) => clinic.toMap()).toList();
    } catch (e) {
      print('Error fetching clinics: $e');
      return [];
    }
  }

  /// Adds a new patient to the specified clinic
  Future<void> addPatientToClinic(String clinicId, Patient patient) async {
    try {
      await _clinicDatabase.addPatient(clinicId, patient);
    } catch (e) {
      print('Error adding patient to clinic: $e');
    }
  }

  /// Fetches all patients for a specific clinic
  Future<List<Patient>> fetchPatients(String clinicId) async {
    try {
      return await _clinicDatabase.getPatients(clinicId);
    } catch (e) {
      print('Error fetching patients: $e');
      return [];
    }
  }

  /// Adds medication to a specific patient in a clinic
  Future<void> addMedicationToPatient(String clinicId, String patientId, MedicalAdherence medication) async {
  try {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final patientRef = _firestore
        .collection('clinics')
        .doc(clinicId)
        .collection('patients')
        .doc(patientId);

    await patientRef.update({
      'medications': FieldValue.arrayUnion([medication.toMap()]),
    });
  } catch (e) {
    print('Error adding medication to patient: $e');
  }
}
}