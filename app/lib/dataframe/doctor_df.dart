class Doctor {
  final String doctorId;
  final String name;
  final String email;
  final int? ic; // Make ic nullable

  Doctor({
    required this.doctorId,
    required this.name,
    required this.email,
    this.ic,
  });

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      doctorId: map['doctorId'] ?? 'Unknown', // Provide default value
      name: map['name'] ?? 'Unknown',
      email: map['email'] ?? 'Unknown',
      ic: map['ic'], // Allow null values
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'name': name,
      'email': email,
      'ic': ic,
    };
  }
}