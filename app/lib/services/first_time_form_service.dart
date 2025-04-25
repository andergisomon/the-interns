import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lebui_modsu/globals.dart';
import '../dataframe/first_time_form_df.dart';  

class FirstTimeLoginService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveFirstTimeLogin(FirstTimeLogin firstTimeLogin, String userId) async {
        await FirebaseFirestore.instance
        .collection('clinics')
        .doc(assignedClinicId)
        .collection('patients')
        .doc(userId)

        .set(firstTimeLogin.toMap());
  }

  Future<FirstTimeLogin?> getFirstTimeFormData(String userId) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return FirstTimeLogin.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}