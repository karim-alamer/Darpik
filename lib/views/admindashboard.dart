import 'package:darpik/controllers/landmark_controller.dart';
import 'package:darpik/models/landmarkModel.dart';
import 'package:darpik/widgets/landmarkDetailCardWidget.dart';
import 'package:darpik/widgets/landmarkFormWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatelessWidget {
  final LandmarkService _controller = Get.put(LandmarkService());

  AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          _ResponsiveFilterButton(),
        ],
      ),
      body: _buildResponsiveLayout(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLandmarkDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Desktop/Tablet layout
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildLandmarksList(),
              ),
              Expanded(
                flex: 3,
                child: _buildLandmarkDetails(),
              ),
            ],
          );
        } else {
          // Mobile layout
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: _buildLandmarksList(),
              ),
              SizedBox(
                  height: 1,
                  child: Container(color: Colors.grey)), // بدل الـ Divider
              Expanded(
                flex: 1,
                child: _buildLandmarkDetails(),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildLandmarksList() {
    return Obx(() => ListView.builder(
          itemCount: _controller.landmarks.length,
          itemBuilder: (context, index) {
            final landmark = _controller.landmarks[index];
            return _LandmarkListItem(
              landmark: landmark,
              onTap: () => _controller.currentIndex.value = index,
            );
          },
        ));
  }

  Widget _buildLandmarkDetails() {
    return Obx(() {
      if (_controller.landmarks.isEmpty) {
        return const Center(child: Text('No Places Founded  '));
      }
      int index = _controller.currentIndex.value;
      if (index >= _controller.landmarks.length) {
        _controller.currentIndex.value =
            0; // إعادة التعيين إلى 0 إذا كان خارج النطاق
        index = 0;
      }

      final landmark = _controller.landmarks[index];
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: LandmarkDetailCard(landmark: landmark),
      );
    });
  }

  void _showAddLandmarkDialog() {
    Get.dialog(
      const AlertDialog(
        title: Center(child: Text('Add place')),
        content: LandmarkForm(),
      ),
    );
  }
}

class _ResponsiveFilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 400) {
          return DropdownButton<String>(
            items: ['All', 'Museums', 'Restaurants', 'Store']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) =>
                Get.find<LandmarkService>().filterByCategory(value!),
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          );
        }
      },
    );
  }

  void _showFilterSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select category'),
            ...['All', 'Museums', 'Restaurants', 'Store'].map((e) => ListTile(
                  title: Text(e),
                  onTap: () {
                    Get.find<LandmarkService>().filterByCategory(e);
                    Get.back();
                  },
                )),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class _LandmarkListItem extends StatelessWidget {
  final Landmark landmark;
  final VoidCallback onTap;

  const _LandmarkListItem({required this.landmark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildImageWidget(landmark.imagePath),
      title: Text(landmark.name),
      subtitle: Text(landmark.category),
      trailing: Obx(() => IconButton(
            icon: Icon(landmark.isFavorite.value
                ? Icons.favorite
                : Icons.favorite_border),
            onPressed: () =>
                Get.find<LandmarkService>().toggleFavorite(landmark),
          )),
      onTap: onTap,
    );
  }
Widget _buildImageWidget(String imagePath) {
  if (imagePath.trim().isEmpty) {
    return _buildErrorWidget('لا يوجد صورة');
  }

  // التحقق إذا كان الرابط من الإنترنت
  if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
    // لو الصورة من freeimage.host، نحولها لرابط مباشر من iili.io
    String directUrl = imagePath.contains('freeimage.host')
        ? imagePath.replaceAll('https://freeimage.host/i/', 'https://iili.io/') + '.jpg'
        : imagePath;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 50,
        height: 50,
        child: Image.network(
          directUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorWidget('خطأ في التحميل'),
        ),
      ),
    );
  }

  // في حالة عدم وجود رابط إنترنت صحيح
  return _buildErrorWidget('رابط غير صالح');
}


  

  Widget _buildErrorWidget(String message) {
    return Container(
      width: 70,
      height: 70,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 20, color: Colors.red),
          Text(
            message,
            style: const TextStyle(fontSize: 8, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
