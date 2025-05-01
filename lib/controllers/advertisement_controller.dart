import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darpik/models/advertisementsModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

// Assuming your Advertisement model is here

class AdvertisementController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxInt currentIndex = 0.obs;
  final RxBool isActive = false.obs;

  final RxList<Advertisement> advertisements = <Advertisement>[].obs;
  final RxList<Advertisement> filteredAds = <Advertisement>[].obs;
  final RxString selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdvertisements();
  }

  final categories = {
    'Famous': Icons.landscape,
    ' Museums': Icons.museum,
    'Parks': Icons.park,
    'Entertainment': Icons.attractions,
    'Shopping': Icons.shopping_cart,
    'Restaurants': Icons.restaurant,
    'Universities': Icons.school,
    'Hospitals': Icons.local_hospital,
    'Government Buildings': Icons.account_balance,
    'Airports': Icons.flight,
  };

  void fetchAdvertisements() {
    _firestore.collection('advertisements').snapshots().listen(
      (snapshot) {
        advertisements.assignAll(snapshot.docs
            .map((doc) {
              try {
                return Advertisement.fromFirestore(doc);
              } catch (e) {
                print('تخطي مستند إعلان غير صالح: ${doc.id}');
                return null;
              }
            })
            .whereType<Advertisement>()
            .toList());
      },
      onError: (error) => Get.snackbar('خطأ', 'فشل في تحميل الإعلانات'),
    );
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category == 'الكل') {
      filteredAds.assignAll(advertisements);
    } else {
      filteredAds.assignAll(
        advertisements.where((ad) => ad.category == category).toList(),
      );
    }
  }

  Future<void> addAdvertisement(Advertisement ad, File? imageFile) async {
    try {
      String imagePath =
          ad.imagePath.isEmpty ? 'https://iili.io/30RK1rQ.jpg' : ad.imagePath;
      Advertisement updatedAds = ad.copyWith(imagePath: imagePath);
      DocumentReference docRef = await _firestore
          .collection('advertisements')
          .add(updatedAds.toFirestore());

      await docRef.update({'id': docRef.id});
      Get.snackbar('نجاح', 'تمت إضافة الإعلان بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إضافة الإعلان: ${e.toString()}');
      throw e;
    }
  }

  Future<void> updateAdvertisement(Advertisement ad) async {
    try {
      await _firestore.collection('advertisements').doc(ad.id).update(
            ad.toFirestore(),
          );
      Get.snackbar('نجاح', 'تم تحديث الإعلان بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحديث الإعلان: ${e.toString()}');
      throw e;
    }
  }

  Future<void> deleteAdvertisement(String id) async {
    try {
      await _firestore.collection('advertisements').doc(id).delete();
      Get.snackbar('نجاح', 'تم حذف الإعلان بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في حذف الإعلان: ${e.toString()}');
      throw e;
    }
  }

  RxList<Advertisement> get featuredAds =>
      advertisements.where((ad) => ad.isActive).toList().obs;

  Future<void> toggleAdStatus(Advertisement ad) async {
    try {
      final newStatus = !ad.isActive;
      // Create new instance with updated status
      final updatedAd = ad.copyWith(isActive: newStatus);

      // Update Firestore
      await _firestore.collection('advertisements').doc(ad.id).update({
        'isActive': newStatus,
      });

      // Update local list
      final index = advertisements.indexWhere((a) => a.id == ad.id);
      if (index != -1) {
        advertisements[index] = updatedAd;
        advertisements.refresh(); // Force observable update
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تغيير حالة الإعلان');
    }
  }

  // Additional matching methods
  void updateCurrentIndex(int index) => currentIndex.value = index;

  List<String> get adCategories => categories.keys.toList();

  IconData getCategoryIcon(String category) => categories[category]!;
}
