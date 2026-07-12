part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const MAIN = _Paths.MAIN;
  static const EXPLORE = _Paths.EXPLORE;
  static const DETAIL_BUDAYA = _Paths.DETAIL_BUDAYA;
  static const REVIEWS = _Paths.REVIEWS;
  static const EVENT = _Paths.EVENT;
  static const DETAIL_EVENT = _Paths.DETAIL_EVENT;
  static const EVENT_LIST = _Paths.EVENT_LIST;
  static const NEWS_LIST = _Paths.NEWS_LIST;
  static const NEWS_DETAIL = _Paths.NEWS_DETAIL;
  static const UMKM = _Paths.UMKM;
  static const SEARCH = _Paths.SEARCH;
  static const REVIEW = _Paths.REVIEW;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const UPDATE_PASSWORD = _Paths.UPDATE_PASSWORD;
  static const VERIFY_OTP = _Paths.VERIFY_OTP;
  static const UMKM_DETAIL = _Paths.UMKM_DETAIL;
  static const MAP_EXPLORE = _Paths.MAP_EXPLORE;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const KUIS_BUDAYA = _Paths.KUIS_BUDAYA;
  static const PENCAPAIAN = _Paths.PENCAPAIAN;
  static const DETAIL_PENCAPAIAN = _Paths.DETAIL_PENCAPAIAN;
  static const AI_SCAN = _Paths.AI_SCAN;
  static const QUIZ = _Paths.QUIZ;
}

abstract class _Paths {
  _Paths._();

  static const HOME = '/home';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const MAIN = '/main';
  static const EXPLORE = '/explore';
  static const DETAIL_BUDAYA = '/detail-budaya';
  static const REVIEWS = '/reviews';
  static const EVENT = '/event';
  static const DETAIL_EVENT = '/detail-event';
  static const EVENT_LIST = '/event-list';
  static const NEWS_LIST = '/news-list';
  static const NEWS_DETAIL = '/news-detail';
  static const UMKM = '/umkm';
  static const SEARCH = '/search';
  static const REVIEW = '/review';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const UPDATE_PASSWORD = '/update-password';
  static const VERIFY_OTP = '/verify-otp';
  static const UMKM_DETAIL = '/umkm-detail';
  static const MAP_EXPLORE = '/map-explore';
  static const EDIT_PROFILE = '/edit-profile';
  static const KUIS_BUDAYA = '/kuis-budaya';
  static const PENCAPAIAN = '/pencapaian';
  static const DETAIL_PENCAPAIAN = '/detail-pencapaian';
  static const AI_SCAN = '/ai-scan';
  static const QUIZ = '/quiz';
}
