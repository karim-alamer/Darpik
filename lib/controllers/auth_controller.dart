import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darpik/routes/app_pages.dart';
import 'package:darpik/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> register() async {
    isLoading.value = true;
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Create user document with server timestamp
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid);
      await userDoc.set({
        'name': nameController.text,
        'email': emailController.text,
        'role': 'user',
        'password': passwordController.text,
        'avatarPath': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Retrieve the actual timestamp from Firestore
      final docSnapshot = await userDoc.get();
      final userData = docSnapshot.data() as Map<String, dynamic>;

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('name', userData['name']);
      await prefs.setString('email', userData['email']);
      await prefs.setString('role', userData['role']);

      // Handle timestamp conversion
      final Timestamp createdAt = userData['createdAt'] as Timestamp;
      await prefs.setString(
          'createdAt', createdAt.toDate().millisecondsSinceEpoch.toString());

      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', _parseFirebaseError(e.code));
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole') ?? 'user';
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      await _firebaseService.loginUser(
        emailController.text,
        passwordController.text,
      );

      final user = await _getCurrentUserData();
      print('User Data: $user');

      if (user != null) {
        await _saveUserDataToPrefs(user);
      }

      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      Get.snackbar('خطأ', _parseFirebaseError(e.code),
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print('Error during login: $e');
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع أثناء تسجيل الدخول',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>?> _getCurrentUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      // 1. تسجيل خروج المستخدم من Firebase
      await FirebaseAuth.instance.signOut();

      // 2. حذف بيانات المستخدم من SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // لحذف كل البيانات

      // 3. الانتقال إلى شاشة تسجيل الدخول
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('Error during logout: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء تسجيل الخروج',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> uploadProfileImage() async {
    try {
      // Request permissions
      if (await Permission.photos.request().isDenied) {
        throw Exception('Permission denied');
      }
      // Pick image
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
      );
      if (image == null) return;
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');
      // Upload to Firebase Storage
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('user_avatars')
          .child('${user.uid}.jpg');

      await storageRef.putFile(File(image.path));
      final String downloadUrl = await storageRef.getDownloadURL();
      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'avatarPath': downloadUrl});
      // Update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatarPath', downloadUrl);
      // Update local controller state
      nameController.text = prefs.getString('name') ?? '';
      emailController.text = prefs.getString('email') ?? '';
      Get.snackbar('Success', 'Profile image updated!');
    } on PlatformException catch (e) {
      Get.snackbar('Error', 'Gallery access error: ${e.message}');
    } on FirebaseException catch (e) {
      Get.snackbar('Upload Failed', e.message ?? 'Firebase error');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile image');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveUserDataToPrefs(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final Timestamp? createdAt = userData['createdAt'] as Timestamp?;
    final createdAtMillis =
        createdAt?.toDate().millisecondsSinceEpoch.toString() ??
            DateTime.now().millisecondsSinceEpoch.toString();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userRole', userData['role'] ?? 'user');
    await prefs.setString('avatarPath', userData['avatarPath'] ?? '');
    await prefs.setString('email', userData['email'] ?? '');
    await prefs.setString('name', userData['name'] ?? '');
    await prefs.setString('createdAt', createdAtMillis);
  }

  String _parseFirebaseError(String code) {
    switch (code) {
      case 'weak-password':
        return 'كلمة المرور ضعيفة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم مسبقاً';
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور خاطئة';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}

 // Future<void> register() async {
  //   isLoading.value = true;
  //   try {
  //     // 1. تسجيل المستخدم الجديد
  //     await _firebaseService.registerUser(
  //       nameController.text,
  //       emailController.text,
  //       passwordController.text,
  //     );

  //     // 2. الحصول على بيانات المستخدم بعد التسجيل
  //     final user = await _getCurrentUserData();

  //     // 3. حفظ البيانات في SharedPreferences
  //     if (user != null) {
  //       await _saveUserDataToPrefs(user);
  //     }

  //     Get.offAllNamed(Routes.HOME);
  //   } on FirebaseAuthException catch (e) {
  //     Get.snackbar('Error', _parseFirebaseError(e.code));
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }