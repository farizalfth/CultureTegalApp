import 'package:get/get.dart';

import '../modules/detail_budaya/bindings/detail_budaya_binding.dart';
import '../modules/detail_budaya/views/detail_budaya_view.dart';
import '../modules/event/bindings/detail_event_binding.dart';
import '../modules/event/bindings/event_binding.dart';
import '../modules/event/bindings/event_list_binding.dart';
import '../modules/event/views/detail_event_view.dart';
import '../modules/event/views/event_list_view.dart';
import '../modules/event/views/event_view.dart';
import '../modules/explore/bindings/explore_binding.dart';
import '../modules/explore/views/explore_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/news/bindings/news_detail_binding.dart';
import '../modules/news/bindings/news_list_binding.dart';
import '../modules/news/views/news_detail_view.dart';
import '../modules/news/views/news_list_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/review/bindings/review_binding.dart';
import '../modules/review/views/review_view.dart';
import '../modules/search/bindings/search_page_binding.dart';
import '../modules/search/views/search_page_view.dart';
import '../modules/umkm/bindings/umkm_binding.dart';
import '../modules/umkm/views/umkm_view.dart';
import '../modules/umkm_detail/bindings/umkm_detail_binding.dart';
import '../modules/umkm_detail/views/umkm_detail_view.dart';
import '../modules/update_password/bindings/update_password_binding.dart';
import '../modules/update_password/views/update_password_view.dart';
import '../modules/verify_otp/bindings/verify_otp_binding.dart';
import '../modules/verify_otp/views/verify_otp_view.dart';

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
      name: _Paths.DETAIL_BUDAYA,
      page: () => const DetailBudayaView(),
      binding: DetailBudayaBinding(),
      transition: Transition.fadeIn,
      children: [
        GetPage(
          name: _Paths.DETAIL_BUDAYA,
          page: () => const DetailBudayaView(),
          binding: DetailBudayaBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.REVIEWS,
      page: () => const ReviewView(),
      binding: ReviewBinding(),
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
      name: _Paths.EVENT_LIST,
      page: () => const EventListView(),
      binding: EventListBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.NEWS_LIST,
      page: () => const NewsListView(),
      binding: NewsListBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.NEWS_DETAIL,
      page: () => const NewsDetailView(),
      binding: NewsDetailBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.UMKM,
      page: () => const UmkmView(),
      binding: UmkmBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchPageView(),
      binding: SearchPageBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.REVIEW,
      page: () => const ReviewView(),
      binding: ReviewBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_PASSWORD,
      page: () => const UpdatePasswordView(),
      binding: UpdatePasswordBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_OTP,
      page: () => const VerifyOtpView(),
      binding: VerifyOtpBinding(),
    ),
    GetPage(
      name: _Paths.UMKM_DETAIL,
      page: () => const UmkmDetailView(),
      binding: UmkmDetailBinding(),
    ),
  ];
}
