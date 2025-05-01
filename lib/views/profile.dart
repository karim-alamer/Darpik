import 'package:darpik/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final prefs = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              // padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildProfileAvatar(prefs),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildProfileGrid(prefs),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileAvatar(SharedPreferences prefs) {
    return GestureDetector(
      onTap: _authController.uploadProfileImage,
      child: Obx(() => Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(
                  prefs.getString('avatarPath')?.isNotEmpty == true
                      ? prefs.getString('avatarPath')!
                      : 'assets/images/default-avatar.png',
                ),
                child: _authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : null,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit,
                  size: 24,
                  color: Color(0xFF9C174E),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildProfileGrid(SharedPreferences prefs) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.2,
      children: [
        _buildProfileItem('Name', prefs.getString('name') ?? 'Unknown'),
        _buildProfileItem('Email', prefs.getString('email') ?? 'Unknown'),
        _buildProfileItem('Role', prefs.getString('userRole') ?? 'User'),
        _buildProfileItem(
          'Registration Date',
          DateFormat('yyyy-MM-dd').format(
            prefs.containsKey('createdAt') &&
                    prefs.getString('createdAt')!.isNotEmpty
                ? DateTime.fromMillisecondsSinceEpoch(
                    int.parse(prefs.getString('createdAt')!))
                : DateTime.now(),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
