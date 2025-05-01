import 'package:darpik/controllers/advertisement_controller.dart';
import 'package:darpik/controllers/landmark_controller.dart';

import 'package:darpik/views/profile.dart';
import 'package:darpik/widgets/AdSliderWidget.dart';
import 'package:darpik/widgets/BuildFavoritesPageWidget.dart';
import 'package:darpik/widgets/BuildLandmarkWidget.dart';
import 'package:darpik/widgets/CategoriesWidget.dart';
import 'package:darpik/widgets/CustomButtonNavbarWidget.dart';
import 'package:darpik/widgets/CustomDrawerWidget.dart';
import 'package:darpik/widgets/CustomHomeAppBarWidget.dart';
import 'package:darpik/widgets/SearchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<LandmarkService> {
  final _searchController = TextEditingController();
  final AdvertisementController adController =
      Get.find<AdvertisementController>();

  HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: const CustomHomeAppBar(),
          backgroundColor: Colors.white,
          body: _getPage(controller.currentIndex.value),
          bottomNavigationBar: const CustomBottomNavigationBar(),
          drawer: CustomDrawer(controller: controller),
        ));
  }

  Widget _getPage(int index) {
    switch (index) {
      case 2:
        return _buildHomeContent();
      case 1:
        return FavoritesPage();
      case 0:
        return ProfilePage();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SearchBarWidget(
            controller: _searchController,
            onSubmitted: _showSearchResults,
          ),
          CategoriesWidget(controller: controller),
          AdSliderWidget(controller: adController),
          _buildLandmarksList(),
        ],
      ),
    );
  }

  void _showSearchResults(String query) {
    controller.filteredLandmarks.value = controller.landmarks
        .where((landmark) =>
            landmark.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    Get.to(() => MapScreen(landmarks: controller.filteredLandmarks));
  }

  Widget _buildLandmarksList() {
    return Obx(() {
      final landmarks = controller.landmarks;
      if (landmarks.isEmpty) {
        return const Center(child: Text('No landmarks available'));
      }
      return SizedBox(
        height: landmarks.length * 200, // Adjust based on your item height
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: landmarks.length,
          itemBuilder: (context, index) {
            final landmark = landmarks[index];
            return LandmarkItem(landmark);
          },
        ),
      );
    });
  }
//comment section
}

