import 'package:get/get.dart';


import '../modules/event/bindings/detail_event_binding.dart';
import '../modules/event/bindings/event_binding.dart';
import '../modules/event/views/detail_event_view.dart';
import '../modules/event/views/event_view.dart';
import '../modules/explore/bindings/explore_binding.dart';
import '../modules/explore/views/explore_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/umkm/bindings/umkm_binding.dart';
import '../modules/umkm/views/umkm_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.EXPLORE,
      page: () => const ExploreView(),
      binding: ExploreBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainWrapper(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.EVENT,
      page: () => const EventView(),
      binding: EventBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_EVENT,
      page: () => const DetailEventView(),
      binding: DetailEventBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.UMKM,
      page: () => const UmkmView(),
      binding: UmkmBinding(),
    ),
  ];
}
