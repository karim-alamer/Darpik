import 'package:darpik/controllers/landmark_controller.dart';
import 'package:darpik/models/landmarkModel.dart';
import 'package:darpik/widgets/landmarkFormWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandmarkDetailCard extends StatelessWidget {
  final Landmark landmark;

  const LandmarkDetailCard({super.key, required this.landmark});
  @override
  Widget build(BuildContext context) {
    final LandmarkService landmarkService = Get.find();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Directionality(
          // ✅ تحديد اتجاه النصوص ليكون من اليسار لليمين
          textDirection: TextDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                landmark.name,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              _buildLandmarkImage(landmark
                  .imagePath), // ✅ استخدم الدالة اللي بتفصل بين النت والمحلي
              const SizedBox(height: 16),
              _buildDetailRow('Location', landmark.location),
              _buildDetailRow('Category', landmark.category),
              _buildDetailRow('Rating', landmark.rating.toString()),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _showEditDialog,
                    child: const Text('Edit'),
                  ),
                  ElevatedButton(
                    onPressed: _deleteLandmark,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void _showEditDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(' Edit'),
        content: LandmarkForm(landmark: landmark),
      ),
    );
  }

  void _deleteLandmark() {
    Get.find<LandmarkService>().deleteLandmark(landmark.id);
  }

  Widget _buildLandmarkImage(String imagePath) {
    // حالة الصور من الإنترنت
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      String directUrl = imagePath;

      // معالجة روابط freeimage.host
      if (imagePath.contains('freeimage.host/i/')) {
        directUrl = imagePath
                .replaceAll('https://freeimage.host/i/', 'https://iili.io/')
                .replaceAll('http://freeimage.host/i/', 'https://iili.io/') +
            '.jpg';
      }
      // معالجة روابط وجك دخ (أضف الشروط الخاصة بمصدرك الجديد هنا)
      else if (imagePath.contains('your-custom-domain.com')) {
        directUrl = imagePath.replaceAll('/thumb/', '/original/');
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          directUrl,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorPlaceholder();
          },
        ),
      );
    }
    // حالة الصور المحلية
    else {
      try {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorPlaceholder();
            },
          ),
        );
      } catch (e) {
        return _buildErrorPlaceholder();
      }
    }
  }

// ودجيت لعرض حالة الخطأ الموحدة
  Widget _buildErrorPlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 40, color: Colors.grey[500]),
          SizedBox(height: 8),
          Text(
            'تعذر تحميل الصورة',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
