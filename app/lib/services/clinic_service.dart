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
        print('Doctor data: ${doctor.toMap()}');
      }
      return doctors.any((doctor) => doctor.ic == ic);
    } catch (e) {
      print('Error verifying doctor IC: $e');
      return false;
    }
  }

  /// Saves the user's role and clinic information in Firestore
  Future<void> saveUserRole(String userId, String role, String clinicId, {
    required String name,
    required String email,
    required int ic,
  }) async {
    try {
      final doctorData = {
        'doctorId': userId,
        'name': name,
        'email': email,
        'ic': ic,
      };

      await FirebaseFirestore.instance
          .collection('clinics')
          .doc(clinicId)
          .collection('doctors')
          .doc(userId) // Use UID as document ID
          .set(doctorData);
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

  /// Fetches all patients for a specific clinic
  Future<List<Patient>> fetchPatients(String clinicId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('clinics')
        .doc(clinicId)
        .collection('patients')
        .get();

    return snapshot.docs.map((doc) {
      return Patient.fromMap(doc.data(), doc.id); // ✅ pass doc.id as patientId
    }).toList();
  } catch (e) {
    print('Error fetching patients: $e');
    return [];
  }
  }


  /// Adds medication to a specific patient in a clinic
  Future<void> addMedicationToPatient(String clinicId, String patientId, MedicalAdherence medication) async {
    try {
      final patientRef = FirebaseFirestore.instance
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

  /// Finds the clinic ID of the currently signed-in doctor
  Future<String?> getAssignedClinicId(String userId) async {
    try {
      final query = await FirebaseFirestore.instance
          .collectionGroup('doctors')
          .where('doctorId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final path = query.docs.first.reference.path;
        // path = clinics/<clinicId>/doctors/<userId>
        final clinicId = path.split('/')[1]; // "clinics/CLINIC_ID/doctors/UID"
        return clinicId;
      }

      return null;
    } catch (e) {
      print('Error getting assigned clinic ID: $e');
      return null;
    }
  }

  Future<String?> getAssignedClinicIdForPatient(String userId) async {
  try {
    final query = await FirebaseFirestore.instance
        .collectionGroup('patients')
        .where('patientId', isEqualTo: userId)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final path = query.docs.first.reference.path;
      // path = clinics/<clinicId>/patients/<userId>
      final clinicId = path.split('/')[1];
      return clinicId;
    }

    return null;
  } catch (e) {
    print('Error getting patient clinic ID: $e');
    return null;
  }
  }

}
