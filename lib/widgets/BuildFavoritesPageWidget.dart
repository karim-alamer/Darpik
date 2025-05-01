// file: widgets/favorites_page.dart
import 'package:darpik/widgets/BuildLandmarkWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darpik/controllers/landmark_controller.dart';

// لو عامل ويدجيت مستقل لعرض المعلم

class FavoritesPage extends GetView<LandmarkService> {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.favoriteLandmarks.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 60, color: Colors.grey),
              Text('No favorites yet', style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: controller.favoriteLandmarks.length,
        itemBuilder: (context, index) {
          final landmark = controller.favoriteLandmarks[index];
          return LandmarkItem(landmark); // أو استخدم _buildLandmarkItem لو عندك
        },
      );
    });
  }
}
