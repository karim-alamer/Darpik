import 'package:darpik/controllers/advertisement_controller.dart';
import 'package:darpik/controllers/auth_controller.dart';
import 'package:darpik/controllers/landmark_controller.dart';
import 'package:darpik/routes/app_pages.dart';
import 'package:darpik/services/database_helper.dart';
import 'package:darpik/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  try {
    await DatabaseHelper.initDb();
  } catch (e) {
    print('Database initialization error: $e');
  }
  // Get.lazyPut(() => AuthController());
  Get.put(AuthController());
  // Get.put(LandmarkController());
  Get.put(LandmarkService());
    Get.put(AdvertisementController());
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'دربك - الرياض',
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? Routes.HOME : Routes.LOGIN,
      getPages: AppPages.routes,
      locale: const Locale('ar', 'SA'),
    );
  }
}
