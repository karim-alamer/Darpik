// services/firebase_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User Registration
  Future<void> registerUser(String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'role': 'user', // تحديد دور المستخدم كـ user بشكل افتراضي
        'avatarPath':
            '', // مسار الصورة الافتراضي (يمكنك وضع رابط صورة افتراضية هنا)
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // User Login
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      throw FirebaseAuthException(code: e.toString());
    }
  }

  // User Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get Current User Data
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      return doc.data() as Map<String, dynamic>?;
    }
    return null;
  }
}
