import 'package:cloud_firestore/cloud_firestore.dart';
import '../dataframe/first_time_login_df.dart';  

class FirstTimeLoginService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveFirstTimeLogin(FirstTimeLogin firstTimeLogin) async {
    await _firestore
        .collection('users')
        .doc(firstTimeLogin.userId)
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