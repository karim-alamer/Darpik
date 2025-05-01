// file: widgets/custom_bottom_navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darpik/controllers/landmark_controller.dart';
// غيّر المسار حسب مشروعك

class CustomBottomNavigationBar extends GetView<LandmarkService> {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: controller.bottomNavIndex.value,
          onTap: (index) => controller.bottomNavIndex.value = index,
          backgroundColor: Colors.white,
          elevation: 10.0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          selectedItemColor: const Color(0xFF9C174E),
          unselectedItemColor: Colors.grey[600],
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.person_outline),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.all(5),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFF9C174E),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Icon(Icons.person),
                ),
              ),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.favorite_border),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.all(5),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFF9C174E),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Icon(Icons.favorite),
                ),
              ),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.home_outlined),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.all(5),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFF9C174E),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Icon(Icons.home),
                ),
              ),
              label: 'Home',
            ),
          ],
        ));
  }
}
