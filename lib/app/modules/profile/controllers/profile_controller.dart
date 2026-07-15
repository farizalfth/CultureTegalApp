import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/service/auth_service.dart';
import '../../../data/service/user_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepository = Get.find<UserRepository>();
  final UserService userService = UserService.to;
  final AuthService _authService = Get.find<AuthService>();
  final String baseUrl = dotenv.env['FLASK_API_URL'] ?? '';

  final RxBool isLoading = false.obs;
  final RxInt scannedSitesCount = 0.obs;
  final RxInt correctQuizzesCount = 0.obs;
  final RxInt badgesCollectedCount = 0.obs;
  final RxInt totalPoints = 0.obs;
  final RxInt totalXp = 0.obs;
  final RxInt currentLevel = 1.obs;
  final RxDouble levelProgress = 0.0.obs;

  final RxBool isNotificationEnabled = true.obs;
  final RxList<dynamic> scanHistory = <dynamic>[].obs;
  final RxMap<String, dynamic> favoritesData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    try {
      isNotificationEnabled.value =
          OneSignal.User.pushSubscription.optedIn ?? true;
    } catch (e) {
      isNotificationEnabled.value = true;
    }
    loadAllProfileData();
  }

  String getBaseWebUrl(String path) {
    final String cleanBase = baseUrl.replaceAll('/api/v1', '').trim();
    final String sanitizedPath = path.startsWith('/') ? path : '/$path';
    return '$cleanBase$sanitizedPath';
  }

  Future<void> loadAllProfileData() async {
    isLoading.value = true;
    try {
      await userService.refreshUserData();
      final statsData = await _userRepository.getUserStats();
      if (statsData != null) {
        scannedSitesCount.value = statsData['scanned_sites_count'] ?? 0;
        correctQuizzesCount.value = statsData['correct_quizzes_count'] ?? 0;
        badgesCollectedCount.value = statsData['badges_collected_count'] ?? 0;
        totalPoints.value = statsData['total_points'] ?? 0;
        totalXp.value = statsData['total_xp'] ?? 0;
        currentLevel.value = statsData['current_level'] ?? 1;
        levelProgress.value = (totalXp.value % 1000) / 1000.0;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchScanHistory() async {
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http.get(
        Uri.parse('$cleanBase/users/scan-history'),
        headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        scanHistory.assignAll(body['data'] ?? []);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> fetchFavorites() async {
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http.get(
        Uri.parse('$cleanBase/users/favorites'),
        headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        favoritesData.value = body['data'] ?? {};
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> toggleNotification(bool val) async {
    isNotificationEnabled.value = val;
    try {
      final String? onesignalId = OneSignal.User.pushSubscription.id;
      final String? token = _authService.currentToken;
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';

      if (val) {
        OneSignal.User.pushSubscription.optIn();
        if (onesignalId != null && token != null) {
          await http.post(
            Uri.parse('$cleanBase/users/onesignal'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({'onesignal_id': onesignalId}),
          );
        }
      } else {
        OneSignal.User.pushSubscription.optOut();
        if (onesignalId != null && token != null) {
          await http.post(
            Uri.parse('$cleanBase/users/onesignal/logout'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({'onesignal_id': onesignalId}),
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> launchWebUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          "Gagal Membuka Halaman",
          "Perangkat tidak dapat membuka tautan ini.",
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void promptDeleteAccount() {
    Get.defaultDialog(
      title: "Hapus Akun",
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
      middleText:
          "Peringatan: Seluruh data, poin, lencana, dan riwayat perjalanan Anda akan dihapus secara permanen dari server. Aksi ini tidak dapat dibatalkan.",
      textCancel: "Batal",
      textConfirm: "Hapus Permanen",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );
        try {
          await _authService.deleteAccount();
        } catch (e) {
          Get.back();
          Get.snackbar("Gagal", "Tidak dapat menghapus akun: $e");
        }
      },
    );
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
