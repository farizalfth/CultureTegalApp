import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/data/service/auth_service.dart';
import 'app/data/service/secure_storage_service.dart';

Future<void> saveNotificationLocally(String title, String body) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedNotifs =
        prefs.getStringList('local_notifications') ?? [];

    final newNotif = {
      "title": title,
      "body": body,
      "time": DateTime.now().toIso8601String(),
    };

    storedNotifs.insert(0, jsonEncode(newNotif));
    if (storedNotifs.length > 50) {
      storedNotifs = storedNotifs.sublist(0, 50);
    }

    await prefs.setStringList('local_notifications', storedNotifs);
  } catch (e) {
    developer.log(e.toString());
  }
}

Future<void> initOneSignal() async {
  try {
    final String oneSignalAppId = dotenv.env['ONESIGNAL_APP_ID'] ?? '';

    if (oneSignalAppId.isEmpty) {
      return;
    }

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(oneSignalAppId);
    OneSignal.Notifications.requestPermission(true);

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      final title = event.notification.title ?? "Pemberitahuan Baru";
      final body = event.notification.body ?? "";
      saveNotificationLocally(title, body);
    });

    OneSignal.Notifications.addClickListener((event) {
      final title = event.notification.title ?? "Pemberitahuan Baru";
      final body = event.notification.body ?? "";
      saveNotificationLocally(title, body);

      if (Get.isRegistered<AuthService>() &&
          Get.find<AuthService>().isLoggedIn) {
        if (Get.currentRoute != Routes.NOTIFIKASI) {
          Get.toNamed(Routes.NOTIFIKASI);
        }
      }
    });
  } catch (e) {
    developer.log(e.toString());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    final errorMessage = error.toString();
    if (errorMessage.contains('otp_expired') ||
        errorMessage.contains('access_denied')) {
      Future.delayed(const Duration(milliseconds: 500), () {
        final isLoggedIn = Get.isRegistered<AuthService>()
            ? Get.find<AuthService>().isLoggedIn
            : false;
        if (isLoggedIn) {
          Get.snackbar(
            'Info Tautan',
            'Tautan yang Anda klik sudah tidak berlaku.',
            backgroundColor: Colors.black87,
            colorText: Colors.white,
          );
        } else {
          if (Get.currentRoute.isNotEmpty && Get.currentRoute != '/login') {
            Get.offAllNamed('/login');
          }
          Get.snackbar(
            'Tautan Tidak Valid',
            'Tautan verifikasi ini sudah kedaluwarsa.',
            backgroundColor: Colors.orange.shade600,
            colorText: Colors.white,
          );
        }
      });
      return true;
    }
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
    authOptions: FlutterAuthClientOptions(localStorage: SecureLocalStorage()),
  );

  initOneSignal();

  await Get.putAsync(() => AuthService().init());

  runApp(
    GetMaterialApp(
      title: "Tegal Culture",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE67E22),
          primary: const Color(0xFFE67E22),
          surface: const Color(0xFFFDF5E6),
        ),
        scaffoldBackgroundColor: const Color(0xFFFDF5E6),
      ),
      initialBinding: InitialBinding(),
      initialRoute: Get.find<AuthService>().isLoggedIn
          ? Routes.MAIN
          : AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}
