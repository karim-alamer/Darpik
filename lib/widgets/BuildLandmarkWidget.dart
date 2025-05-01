// file: widgets/landmark_item.dart
import 'package:darpik/controllers/landmark_controller.dart';
import 'package:darpik/models/commentModel.dart';
import 'package:darpik/models/landmarkModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import 'dart:ui' as ui;

class LandmarkItem extends StatelessWidget {
  final Landmark landmark;
  final LandmarkService controller = Get.find();

  LandmarkItem(this.landmark, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: InkWell(
        onTap: () => _showLandmarkDetails(landmark),
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: landmark.imagePath.isEmpty
                      ? Image.asset(
                          'assets/images/default.jpg',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported,
                                size: 180, color: Colors.grey);
                          },
                        )
                      : _buildLandmarkImage(landmark.imagePath),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      landmark.price,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 29),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                textDirection: ui.TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    landmark.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    textDirection: ui.TextDirection.ltr,
                    children: [
                      const Icon(Icons.location_pin, color: Color(0xFF9C174E)),
                      const SizedBox(width: 4),
                      Text(
                        landmark.location,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                        textDirection: ui.TextDirection.ltr,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    textDirection: ui.TextDirection.ltr,
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFF9C174E), size: 16),
                      Text(
                        '${landmark.rating}',
                        style: const TextStyle(color: Color(0xFF9C174E)),
                      ),
                      const Spacer(),
                      Obx(() => IconButton(
                            icon: Icon(
                              landmark.isFavorite.value
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: () =>
                                controller.toggleFavorite(landmark),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandmarkImage(String imagePath) {
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      String directUrl =
          '${imagePath.replaceAll('https://freeimage.host/i/', 'https://iili.io/')}.jpg';

      return Image.network(
        directUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 180, color: Colors.grey);
        },
      );
    } else {
      return Image.asset(
        'assets/images/default.jpg',
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image_not_supported,
              size: 180, color: Colors.grey);
        },
      );
    }
  }

  void _showLandmarkDetails(Landmark landmark) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ), // أضف هذه القوسين للإغلاق الصحيح لـ BoxDecoration
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(landmark.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  // Text('\$',
                  //     style: const TextStyle(
                  //         fontSize: 18,
                  //         color: Color(0xFF006D2B),
                  //         fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_pin, color: Color(0xFF9C174E)),
                  const SizedBox(width: 8),
                  Text(landmark.location,
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  landmark.imagePath,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(landmark.description, style: const TextStyle(fontSize: 16)),
              _buildCommentsSection(
                  controller.getCommentsForLandmark(landmark.id)),
              ElevatedButton(
                onPressed: () => _showMap([landmark]),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C174E),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('عرض الموقع على الخريطة'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsSection(List<Comment> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Comments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...comments.map((comment) => _buildCommentItem(comment)),
      ],
    );
  }

  void _showMap(List<Landmark> landmarks) {
    Get.to(() => MapScreen(landmarks: landmarks));
  }

  Widget _buildCommentItem(Comment comment) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(controller.users
            .firstWhere((user) => user.id == comment.userId)
            .avatarPath),
      ),
      title: Text(controller.users
          .firstWhere((user) => user.id == comment.userId)
          .name),
      subtitle: Text(comment.text),
    );
  }
}

class MapScreen extends StatelessWidget {
  final List<Landmark> landmarks;

  const MapScreen({super.key, required this.landmarks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location on Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: landmarks.first.position,
          zoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: landmarks
                .map((landmark) => Marker(
                      point: landmark.position,
                      child: const Icon(Icons.location_pin,
                          color: Colors.red, size: 40),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
