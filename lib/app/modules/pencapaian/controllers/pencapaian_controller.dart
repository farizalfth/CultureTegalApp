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

  String getImageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final String cleanBase = baseUrl.replaceAll('/api/v1', '');
    return '$cleanBase/static/uploads/$path';
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
      }

      if (results[1].statusCode == 200) {
        final response = json.decode(results[1].body);
        leaderboard.assignAll(response['data'] ?? []);
      }

      if (results[2].statusCode == 200) {
        final response = json.decode(results[2].body);
        stats.value = response['data'] ?? {};
      }
    } catch (e) {
      debugPrint("Gagal memuat data pencapaian: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
