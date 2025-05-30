import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  ///
  /// Signup and saved user data in collection against [userId]
  ///
  Future<Map<String, dynamic>> signUpWithEmail({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
    required String collectionName,
  }) async {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

    final uid = userCredential.user!.uid;
    final data = {
      'uid': uid,
      'email': email,
      ...userData,
    };

    await FirebaseFirestore.instance.collection(collectionName).doc(uid).set(data);

    return data;
  }
}
