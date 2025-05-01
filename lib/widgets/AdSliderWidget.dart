import 'package:carousel_slider/carousel_slider.dart';
import 'package:darpik/controllers/advertisement_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdSliderWidget extends StatelessWidget {
  final AdvertisementController controller;

  const AdSliderWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.featuredAds.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          autoPlayInterval: const Duration(seconds: 5),
          onPageChanged: (index, reason) {
            controller.updateCurrentIndex(index);
          },
        ),
        items: controller.featuredAds.map((ad) {
          String imagePath = ad.imagePath;

          Widget imageWidget;

          if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
            String directUrl = imagePath.contains('freeimage.host')
                ? imagePath.replaceAll('https://freeimage.host/i/', 'https://iili.io/') + '.jpg'
                : imagePath;

            imageWidget = Image.network(
              directUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, color: Colors.grey);
              },
            );
          } else {
            imageWidget = Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, color: Colors.grey);
              },
            );
          }

          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: imageWidget,
            ),
          );
        }).toList(),
      );
    });
  }
}
