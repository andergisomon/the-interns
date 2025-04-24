import 'medical_adherence_df.dart';

class Patient {
  final String patientId;
  final String name;
  final String email;
  final List<MedicalAdherence> medications;

  Patient({
    required this.patientId,
    required this.name,
    required this.email,
    required this.medications,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'name': name,
      'email': email,
      'medications': medications.map((med) => med.toMap()).toList(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      patientId: map['patientId'],
      name: map['name'],
      email: map['email'],
      medications: (map['medications'] as List<dynamic>)
          .map((medMap) => MedicalAdherence.fromMap(medMap))
          .toList(),
    );
  }
}