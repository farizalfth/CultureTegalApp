import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../data/service/auth_service.dart';

class PencapaianController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final String baseUrl = dotenv.env['FLASK_API_URL'] ?? '';
  final AuthService _authService = Get.find<AuthService>();

  late TabController tabController;

  var isLoading = false.obs;
  var badges = <dynamic>[].obs;
  var leaderboard = <dynamic>[].obs;
  var stats = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    loadPencapaianData();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> loadPencapaianData() async {
    try {
      isLoading.value = true;
      await _authService.waitForSession();

      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';

      final results = await Future.wait([
        http.get(
          Uri.parse('$cleanBase/users/badges'),
          headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
        ),
        http.get(
          Uri.parse('$cleanBase/users/leaderboard'),
          headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
        ),
        http.get(
          Uri.parse('$cleanBase/users/stats'),
          headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
        ),
      ]);

      if (results[0].statusCode == 200) {
        final response = json.decode(results[0].body);
        badges.assignAll(response['data'] ?? []);
      } else {
        badges.assignAll(_getFallbackBadges());
      }

      if (results[1].statusCode == 200) {
        final response = json.decode(results[1].body);
        leaderboard.assignAll(response['data'] ?? []);
      } else {
        leaderboard.assignAll(_getFallbackLeaderboard());
      }

      if (results[2].statusCode == 200) {
        final response = json.decode(results[2].body);
        stats.value = response['data'] ?? {};
      } else {
        stats.value = _getFallbackStats();
      }
    } catch (e) {
      badges.assignAll(_getFallbackBadges());
      leaderboard.assignAll(_getFallbackLeaderboard());
      stats.value = _getFallbackStats();
    } finally {
      isLoading.value = false;
    }
  }

  List<dynamic> _getFallbackBadges() {
    return [
      {
        "id": "b1",
        "nama_badge": "Penjelajah Pemula",
        "deskripsi": "Berhasil mengunjungi dan memindai 1 objek wisata budaya.",
        "image_url": "assets/images/register/register_icon.png",
        "is_unlocked": true,
      },
      {
        "id": "b2",
        "nama_badge": "Ahli Sejarah Tegal",
        "deskripsi": "Memiliki skor kuis budaya di atas 500 Poin.",
        "image_url": "assets/images/register/register_icon.png",
        "is_unlocked": false,
      },
    ];
  }

  List<dynamic> _getFallbackLeaderboard() {
    return [
      {"rank": 1, "nama": "Nadhif Basalamah", "total_xp": 2400, "level": 3},
      {"rank": 2, "nama": "Laksmana Tegal", "total_xp": 1850, "level": 2},
      {"rank": 3, "nama": "Roro Mendut", "total_xp": 1200, "level": 2},
    ];
  }

  Map<String, dynamic> _getFallbackStats() {
    return {
      "scanned_sites_count": 4,
      "correct_quizzes_count": 8,
      "badges_collected_count": 1,
      "total_points": 350,
      "total_xp": 1200,
      "current_level": 2,
    };
  }
}
