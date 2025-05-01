


import 'package:darpik/controllers/landmark_controller.dart';
import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  final LandmarkService controller;

  const CategoriesWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.keys.length,
        itemBuilder: (context, index) {
          final category = controller.categories.keys.elementAt(index);
          final icon = controller.categories.values.elementAt(index);
          return _CategoryItem(title: category, icon: icon, controller: controller);
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final LandmarkService controller;

  const _CategoryItem({Key? key, required this.title, required this.icon, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => controller.filterByCategory(title),
            child: Container(
              width: 70,
              height: 52,
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 28),
                  const SizedBox(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: SizedBox(
                      height: 16,
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
