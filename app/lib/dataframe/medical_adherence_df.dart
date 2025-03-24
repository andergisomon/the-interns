class MedicalAdherence {
  final String userId;
  final String medicationName;
  final String dosage;
  final String unit;
  final DateTime startDate;
  final DateTime endDate;
  final String frequency;
  final int timesPerDay;

  MedicalAdherence({
    required this.userId,
    required this.medicationName,
    required this.dosage,
    required this.unit,
    required this.startDate,
    required this.endDate,
    required this.frequency,
    required this.timesPerDay,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'medicationName': medicationName,
      'dosage': dosage,
      'unit': unit,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'frequency': frequency,
      'timesPerDay': timesPerDay,
    };
  }

  factory MedicalAdherence.fromMap(Map<String, dynamic> map) {
    return MedicalAdherence(
      userId: map['userId'],
      medicationName: map['medicationName'],
      dosage: map['dosage'],
      unit: map['unit'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      frequency: map['frequency'],
      timesPerDay: map['timesPerDay'],
    );
  }
}