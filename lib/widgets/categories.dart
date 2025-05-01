import 'package:darpik/controllers/landmark_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesSection extends GetView<LandmarkService> {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.keys.length,
          itemBuilder: (context, index) {
            final category = controller.categories.keys.elementAt(index);
            final icon = controller.categories.values.elementAt(index);
            return _buildCategoryItem(category, icon);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          InkWell(
            onTap: () => controller.filterByCategory(title),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 30, color: const Color(0xFF006D2B)),
                  const SizedBox(height: 4),
                  Text(
                    title.split(' ')[0],
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title.substring(2),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}