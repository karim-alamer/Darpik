


import 'package:darpik/controllers/auth_controller.dart';
import 'package:darpik/controllers/landmark_controller.dart';
import 'package:darpik/views/AdsDashboard.dart';
import 'package:darpik/views/admindashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomDrawer extends StatelessWidget {
  final LandmarkService controller;

  const CustomDrawer({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF9C174E),
              ),
              child: Text(
                'Main Menu',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                controller.currentIndex.value = 0;
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () {
                controller.currentIndex.value = 1;
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                controller.currentIndex.value = 2;
                Get.back();
              },
            ),
            FutureBuilder<String>(
              future: AuthController().getUserRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }

                if (snapshot.hasData && snapshot.data == 'admin') {
                  return ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Dashboard'),
                    onTap: () {
                      Get.to(() => AdminDashboard());
                    },
                  );
                }
                if (snapshot.hasData && snapshot.data == 'owner') {
                  return ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Ads Dashboard'),
                    onTap: () {
                      Get.to(() => AdDashboard());
                    },
                  );
                }

                return const SizedBox();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () => AuthController().logout(),
            ),
          ],
        ),
      ),
    );
  }
}
