import 'medical_adherence_df.dart';

class Patient {
  final String patientId;
  final String name;
  final List<MedicalAdherence> medications;

  Patient({
    required this.patientId,
    required this.name,
    required this.medications,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'name': name,
      'medications': medications.map((med) => med.toMap()).toList(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map, String documentId) {
  return Patient(
    patientId: documentId, // Comes from doc.id, not map['patientId']
    name: map['name'] ?? 'Unnamed',
    medications: [], // 🔥 Don't parse from map anymore if using subcollection
    // Add more fields like age, gender, etc. with null safety
  );
  }


}