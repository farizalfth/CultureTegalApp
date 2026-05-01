part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN; // Tambahkan ini
  static const REGISTER = _Paths.REGISTER; // Tambahkan ini
  static const MAIN = _Paths.MAIN; // Tambahkan ini
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const LOGIN = '/login'; // Pastikan ini ada
  static const REGISTER = '/register'; // Tambahkan ini
  static const MAIN = '/main'; // Tambahkan ini
}