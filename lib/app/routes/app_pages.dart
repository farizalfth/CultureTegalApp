import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/view.dart';      // Import view login kamu
import '../modules/register/view.dart';   // Import view register kamu
import '../modules/main/view.dart';       // Import view main (wrapper) kamu

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // UBAH BAGIAN INI: Dari Routes.HOME menjadi Routes.LOGIN
  static const INITIAL = Routes.LOGIN; 

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    // TAMBAHKAN ROUTE LOGIN
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
    ),
    // TAMBAHKAN ROUTE REGISTER
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
    ),
    // TAMBAHKAN ROUTE MAIN (Dashboard Utama)
    GetPage(
      name: _Paths.MAIN,
      page: () => MainWrapper(),
    ),
  ];
}