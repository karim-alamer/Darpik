import 'package:darpik/controllers/landmark_controller.dart';
import 'package:darpik/views/home_view.dart';
import 'package:darpik/views/login_view.dart';
import 'package:darpik/views/registration_view.dart';
import 'package:get/get.dart';

class Routes {
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/home';
}

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
    ),
    // GetPage(
    //   name: Routes.BOOKING,
    //   page: () => BookingView(),
    // ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegistrationView(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LandmarkService>(() => LandmarkService());
      }),
    ),
  ];
}
