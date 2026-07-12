import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../data/service/auth_service.dart';

class AnalitikController extends GetxController {
  final String baseUrl = dotenv.env['FLASK_API_URL'] ?? '';
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> sentimentData = <String, dynamic>{}.obs;
  final RxList<dynamic> topLocations = <dynamic>[].obs;
  final RxList<dynamic> wordCloudData = <dynamic>[].obs;

  final RxString selectedLocation = 'Semua Lokasi'.obs;
  final RxList<String> availableLocations = <String>['Semua Lokasi'].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnalyticsData();
  }

  Future<void> fetchAnalyticsData() async {
    isLoading.value = true;
    try {
      await _authService.waitForSession();
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';

      String locParam = selectedLocation.value == 'Semua Lokasi'
          ? 'global_all'
          : selectedLocation.value;

      final response = await http
          .get(
            Uri.parse(
              '$cleanBase/search/public-analytics?location=${Uri.encodeComponent(locParam)}',
            ),
            headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final data = body['data'] ?? {};

        sentimentData.value = data['sentiment'] ?? {};
        topLocations.assignAll(data['top_locations'] ?? []);
        wordCloudData.assignAll(data['wordcloud'] ?? []);

        final List<dynamic> locs = data['available_locations'] ?? [];
        if (availableLocations.length == 1 && locs.isNotEmpty) {
          availableLocations.addAll(locs.map((e) => e.toString()).toList());
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      sentimentData.clear();
      topLocations.clear();
      wordCloudData.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void changeLocation(String loc) {
    if (selectedLocation.value != loc) {
      selectedLocation.value = loc;
      fetchAnalyticsData();
    }
  }
}
