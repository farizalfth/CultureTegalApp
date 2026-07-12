import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../data/service/auth_service.dart';

class AiScanController extends GetxController {
  final String baseUrl = dotenv.env['FLASK_API_URL'] ?? '';
  final AuthService _authService = Get.find<AuthService>();
  final ImagePicker _picker = ImagePicker();

  var isLoading = false.obs;
  var isHistoryLoading = false.obs;
  var scanResult = Rxn<Map<String, dynamic>>();
  var scanHistory = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadScanHistory();
  }

  Future<void> loadScanHistory() async {
    try {
      isHistoryLoading.value = true;
      await _authService.waitForSession();

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
        scanHistory.assignAll(data);
      }
    } catch (e) {
      debugPrint("Gagal mengambil histori scan: $e");
    } finally {
      isHistoryLoading.value = false;
    }
  }

  Future<void> pickAndScanImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 70,
      );

      if (file == null) return;

      isLoading.value = true;
      scanResult.value = null;

      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$cleanBase/scans/ai'),
      );

      request.headers['Authorization'] = 'Bearer ${_authService.currentToken}';
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        scanResult.value = body['data'] ?? {};
        await loadScanHistory();
      } else {
        Get.snackbar(
          "Pindaian Gagal",
          "Koneksi server terganggu. Mengaktifkan simulator kuliner...",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        _triggerMockScanResult();
      }
    } catch (e) {
      _triggerMockScanResult();
    } finally {
      isLoading.value = false;
    }
  }

  void _triggerMockScanResult() {
    scanResult.value = {
      "predicted_label": "kupat_glabed",
      "confidence": 0.94,
      "food_details": {
        "nama_makanan": "Kupat Glabed",
        "deskripsi":
            "Kupat Glabed adalah kuliner khas Kota Tegal berupa potongan ketupat yang disajikan dengan siraman kuah kuning kental yang gurih khas (glabed), dilengkapi taburan bawang goreng, kerupuk mie, dan sate blengong.",
        "video_url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      },
      "image_url": "/static/uploads/default.jpg",
    };
  }
}
