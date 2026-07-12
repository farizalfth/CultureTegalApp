import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../data/service/auth_service.dart';

class ScanHistoryController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final String baseUrl = dotenv.env['FLASK_API_URL'] ?? '';

  final RxBool isLoading = false.obs;
  final RxList<dynamic> listScans = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchScansData();
  }

  Future<void> fetchScansData() async {
    isLoading.value = true;
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http.get(
        Uri.parse('$cleanBase/scans/ai/history'),
        headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> data = body['data'] ?? [];

        if (data.isEmpty) {
          _simulateLocalHistoryFallback();
        } else {
          listScans.assignAll(data);
        }
      } else {
        _simulateLocalHistoryFallback();
      }
    } catch (e) {
      _simulateLocalHistoryFallback();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteHistory(String scanId) async {
    if (scanId.startsWith("dummy")) {
      listScans.removeWhere((item) => item['id'] == scanId);
      Get.snackbar(
        "Berhasil",
        "Riwayat simulasi dihapus",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http.delete(
        Uri.parse('$cleanBase/scans/ai/history/$scanId'),
        headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
      );

      if (response.statusCode == 200) {
        listScans.removeWhere((item) => item['id'] == scanId);
        Get.snackbar(
          "Berhasil",
          "Riwayat pemindaian permanen dihapus",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw "Gagal menghapus data dari server";
      }
    } catch (e) {
      Get.snackbar(
        "Kesalahan",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _simulateLocalHistoryFallback() {
    listScans.assignAll([
      {
        "id": "dummy1",
        "predicted_label": "kupat_glabed",
        "food_details": {
          "nama_makanan": "Kupat Glabed (Simulasi)",
          "deskripsi":
              "Kupat Glabed adalah kuliner legendaris khas Kota Tegal berupa potongan ketupat yang disajikan dengan siraman kuah kuning kental gurih beraroma kunyit dan santan. Hidangan ini biasanya disajikan hangat dengan taburan bawang goreng, kerupuk mie, dan sate blengong.",
          "video_url": "https://www.youtube.com/watch?v=A3RjZ1pREb8",
        },
        "image_url": null,
        "created_at": DateTime.now().toIso8601String(),
      },
    ]);
  }

  Future<void> launchVideo(String urlString) async {
    Get.toNamed('/webview', arguments: urlString);
  }
}
