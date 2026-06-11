import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:developer' as developer;

import 'app/routes/app_pages.dart';
import 'app/data/service/auth_service.dart';
import 'app/data/service/user_service.dart';
import 'app/data/service/secure_storage_service.dart';

Future<void> initOneSignal() async {
  try {
    final String oneSignalAppId = dotenv.env['ONESIGNAL_APP_ID'] ?? '';

    if (oneSignalAppId.isEmpty) {
      developer.log("OneSignal App ID tidak ditemukan di .env");
      return;
    }

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(oneSignalAppId);
    OneSignal.Notifications.requestPermission(true);

    developer.log("OneSignal berhasil diinisialisasi");
  } catch (e) {
    developer.log("Gagal inisialisasi OneSignal: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    final errorMessage = error.toString();

    if (errorMessage.contains('otp_expired') || errorMessage.contains('access_denied')) {
      developer.log("INFO: Tautan kedaluwarsa ditangkap.");

      Future.delayed(const Duration(milliseconds: 500), () {
        final isLoggedIn = Get.isRegistered<AuthService>() ? Get.find<AuthService>().isLoggedIn : false;

        if (isLoggedIn) {
          Get.snackbar(
            'Info Tautan',
            'Tautan yang Anda klik sudah tidak berlaku, namun Anda sudah aman berada di dalam aplikasi.',
            backgroundColor: Colors.black87,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
          );
        } else {
          if (Get.currentRoute.isNotEmpty && Get.currentRoute != '/login') {
            Get.offAllNamed('/login');
          }

          Get.snackbar(
            'Tautan Tidak Valid',
            'Tautan verifikasi ini sudah kedaluwarsa atau sudah digunakan. Silakan login secara manual atau minta tautan baru.',
            backgroundColor: Colors.orange.shade600,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            margin: const EdgeInsets.all(16),
            snackPosition: SnackPosition.TOP,
          );
        }
      });
      return true;
    }

    developer.log("CRITICAL ASYNC ERROR: $errorMessage");
    return true;
  };

  await dotenv.load(fileName: ".env");

  final String? supabaseUrl = dotenv.env['SUPABASE_URL'];
  final String? supabaseKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'];

  if (supabaseUrl == null || supabaseKey == null) {
    return;
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
    authOptions: FlutterAuthClientOptions(
      localStorage: SecureLocalStorage(),
    ),
  );

  initOneSignal();

  await Get.putAsync(() => AuthService().init());
  Get.put(UserService());

  runApp(
    GetMaterialApp(
      title: "Tegal Culture",
      initialRoute: Get.find<AuthService>().isLoggedIn ? Routes.MAIN : AppPages.INITIAL,
      getPages: AppPages.routes,
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const Scaffold(
          backgroundColor: Color(0xFFFDF5E6),
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFFE67E22)),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}