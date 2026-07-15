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

  String getFormattedImageUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return '';
    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      return rawUrl;
    }

    final String cleanHost = baseUrl
        .replaceAll('http://', '')
        .replaceAll('https://', '')
        .replaceAll('/api/v1', '')
        .trim();

    final String protocol = baseUrl.startsWith('https')
        ? 'https://'
        : 'http://';
    final String sanitizedPath = rawUrl.startsWith('/') ? rawUrl : '/$rawUrl';

    return '$protocol$cleanHost$sanitizedPath';
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
      debugPrint(e.toString());
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
      }
    } catch (e) {
      Get.snackbar(
        "Koneksi Bermasalah",
        "Gagal terhubung dengan server pengenal kuliner AI.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> launchVideo(String urlString) async {
    Get.toNamed('/webview', arguments: urlString);
  }
}
