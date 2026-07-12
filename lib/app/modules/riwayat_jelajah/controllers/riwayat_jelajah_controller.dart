import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../data/service/auth_service.dart';

class RiwayatJelajahController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final String baseUrl = dotenv.env['FLASK_API_URL'] ?? '';

  final RxBool isLoading = false.obs;
  final RxList<dynamic> listGeofence = <dynamic>[].obs;
  final RxList<dynamic> listRead = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRiwayatData();
  }

  Future<void> fetchRiwayatData() async {
    isLoading.value = true;
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
        final List<dynamic> data = body['data'] ?? [];
        listGeofence.assignAll(
          data.where((x) => x['scan_method'] == 'geofence').toList(),
        );
        listRead.assignAll(
          data.where((x) => x['scan_method'] == 'read').toList(),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
