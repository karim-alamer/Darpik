import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darpik/models/commentModel.dart';
import 'package:darpik/models/landmarkModel.dart';
import 'package:darpik/models/userModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandmarkService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var bottomNavIndex = 0.obs;
  final RxInt currentIndex = 0.obs;
  final RxList<Landmark> landmarks = <Landmark>[].obs;
  final RxList<Landmark> filteredLandmarks = <Landmark>[].obs;
  final RxString selectedCategory = 'الكل'.obs;
  final RxList<User> users = <User>[].obs;
  final RxList<Comment> comments = <Comment>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLandmarks();
    _loadInitialData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filterByCategory('All');
    });
  }

  final categories = {
    'All': Icons.all_inclusive,
    'Famous': Icons.landscape,
    'Museums': Icons.museum,
    'Parks': Icons.park,
    'Entertainment': Icons.attractions,
    'Shopping': Icons.shopping_cart,
    'Restaurants': Icons.restaurant,
    'Universities': Icons.school,
    'Hospitals': Icons.local_hospital,
    'Government Buildings': Icons.account_balance,
    'Airports': Icons.flight,
  };

  Future<String> uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('landmarks/$fileName');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  void fetchLandmarks() {
    _firestore.collection('landmarks').snapshots().listen(
      (snapshot) {
        final result = snapshot.docs
            .map((doc) {
              try {
                return Landmark.fromFirestore(doc);
              } catch (e) {
                print('تخطي مستند غير صالح: ${doc.id}');
                return null;
              }
            })
            .whereType<Landmark>()
            .toList();
        landmarks.assignAll(result);
        filterByCategory(selectedCategory.value);
      },
      onError: (error) => Get.snackbar('خطأ', 'فشل في تحميل المعالم'),
    );
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category == 'All') {
      filteredLandmarks.assignAll(landmarks);
    } else {
      filteredLandmarks.assignAll(
        landmarks.where((landmark) => landmark.category == category).toList(),
      );
    }
  }

  Future<void> addLandmark(Landmark landmark, File? imageFile) async {
    try {
      String imagePath = landmark.imagePath.isEmpty
          ? 'https://iili.io/30RK1rQ.jpg'
          : landmark.imagePath;
      Landmark updatedLandmark = landmark.copyWith(imagePath: imagePath);
      DocumentReference docRef = await _firestore.collection('landmarks').add(
            updatedLandmark.toFirestore(),
          );
      await docRef.update({'id': docRef.id});
      Get.snackbar('Success', 'Landmark added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add landmark: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> updateLandmark(Landmark landmark) async {
    try {
      await _firestore.collection('landmarks').doc(landmark.id).update(
            landmark.toFirestore(),
          );
      Get.snackbar('Success', 'Landmark updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update landmark: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> deleteLandmark(String id) async {
    try {
      await _firestore.collection('landmarks').doc(id).delete();
      Get.snackbar('Success', 'Landmark deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete landmark: ${e.toString()}');
      rethrow;
    }
  }

  RxList<Landmark> get favoriteLandmarks =>
      landmarks.where((landmark) => landmark.isFavorite.value).toList().obs;

  Future<void> toggleFavorite(Landmark landmark) async {
    try {
      // Update local value immediately for responsiveness
      landmark.isFavorite.toggle();
      await _firestore.collection('landmarks').doc(landmark.id).update({
        'isFavorite': landmark.isFavorite.value,
      });
    } catch (e) {
      landmark.isFavorite.toggle(); // Revert on error
      Get.snackbar('Error', 'Failed to update favorite');
    }
  }

  void _loadInitialData() {
    _loadUsers();
    _loadComments();
  }

  void _loadUsers() {
    users.addAll([
      User(
        id: '1',
        name: 'محمد علي',
        email: "k@gmail.com",
        role: "user",
        createdAt: DateTime.now(),
        avatarPath: 'assets/images/user1.jpg',
      ),
      User(
        id: '2',
        createdAt: DateTime.now(),
        name: 'أحمد حسن',
        email: "k@gmail.com",
        role: "user",
        avatarPath: 'assets/images/user2.jpg',
      ),
    ]);
  }

  void _loadComments() {
    comments.addAll([
      Comment(
          id: '1',
          userId: '1',
          landmarkId: '1',
          text: 'تجربة رائعة، أنصح الجميع بزيارته!',
          timestamp: DateTime.now().subtract(const Duration(days: 1))),
      Comment(
        id: '2',
        userId: '2',
        landmarkId: '2',
        text: 'مكان مميز للتعرف على التاريخ',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      )
    ]);
  }

  List<Comment> getCommentsForLandmark(String landmarkId) {
    return comments.where((c) => c.landmarkId == landmarkId).toList();
  }
}
