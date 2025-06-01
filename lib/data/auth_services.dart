import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  /// Fetches the current logged-in user's data from the given collection
  Future<Map<String, dynamic>> getCurrentUserData(String collectionName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("No authenticated user found.");

    final doc = await FirebaseFirestore.instance.collection(collectionName).doc(user.uid).get();

    if (!doc.exists) {
      throw Exception("User document not found in collection '$collectionName'.");
    }

    return doc.data()!;
  }

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
      'id': '${uid}',
      ...userData,
    };
    await FirebaseFirestore.instance.collection(collectionName).doc(uid).set(data);
    return data;
  }

  ///
  /// Sign in and return Firestore user data
  ///
  Future<Map<String, dynamic>> signInWithEmail({
    required String email,
    required String password,
    required String collectionName,
  }) async {
    UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

    final uid = credential.user?.uid;
    if (uid == null) throw Exception("User ID is null after login.");

    final doc = await FirebaseFirestore.instance.collection(collectionName).doc(uid).get();

    if (!doc.exists) {
      throw Exception("User document not found in Firestore.");
    }

    return doc.data()!;
  }
}
