class FirstTimeLogin {
  final String userId;
  final String nickname;
  final DateTime dateOfBirth;
  final String gender;
  final String preExistingConditions;
  final String regularMedication;
  final String disability;
  final double height;
  final double weight;
  final double bmi;

  FirstTimeLogin({
    required this.userId,
    required this.nickname,
    required this.dateOfBirth,
    required this.gender,
    required this.preExistingConditions,
    required this.regularMedication,
    required this.disability,
    required this.height,
    required this.weight,
    required this.bmi,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nickname': nickname,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'preExistingConditions': preExistingConditions,
      'regularMedication': regularMedication,
      'disability': disability,
      'height': height,
      'weight': weight,
      'bmi': bmi,
    };
  }

  factory FirstTimeLogin.fromMap(Map<String, dynamic> map) {
    return FirstTimeLogin(
      userId: map['userId'],
      nickname: map['nickname'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      gender: map['gender'],
      preExistingConditions: map['preExistingConditions'],
      regularMedication: map['regularMedication'],
      disability: map['disability'],
      height: map['height'],
      weight: map['weight'],
      bmi: map['bmi'],
    );
  }
}