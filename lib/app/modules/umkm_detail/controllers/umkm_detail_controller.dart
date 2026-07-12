import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../data/models/umkm_model.dart';
import '../../../data/models/review_model.dart';
import '../../../data/providers/umkm_provider.dart';
import '../../../data/service/auth_service.dart';

class UmkmDetailController extends GetxController {
  final UmkmProvider _umkmProvider = Get.find<UmkmProvider>();
  final AuthService _authService = Get.find<AuthService>();
  final String baseUrl = dotenv.env['FLASK_API_URL'] ?? '';

  late final UmkmModel product;
  final isLoadingReviews = false.obs;
  final reviews = <ReviewModel>[].obs;

  final RxBool isWordCloudLoading = false.obs;
  final RxList<Map<String, dynamic>> wordCloudData =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments as UmkmModel;
    fetchReviewsLimit();
    _fetchWordCloud();
  }

  Future<void> _fetchWordCloud() async {
    isWordCloudLoading.value = true;
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http
          .get(
            Uri.parse(
              '$cleanBase/umkm/wordcloud/${Uri.encodeComponent(product.name)}',
            ),
            headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> data = body['data'] ?? [];
        wordCloudData.assignAll(List<Map<String, dynamic>>.from(data));
      } else {
        wordCloudData.clear();
      }
    } catch (e) {
      wordCloudData.clear();
    } finally {
      isWordCloudLoading.value = false;
    }
  }

  Future<void> fetchReviewsLimit() async {
    isLoadingReviews.value = true;
    try {
      final response = await _umkmProvider.getUmkmReviews(
        product.id,
        page: 1,
        perPage: 3,
      );
      final List<dynamic> items = response['items'] ?? [];
      final list = items.map((item) => ReviewModel.fromJson(item)).toList();
      reviews.assignAll(list);
    } catch (e) {
      reviews.clear();
    } finally {
      isLoadingReviews.value = false;
    }
  }

  Future<void> launchWhatsApp() async {
    if (product.whatsappNumber == null || product.whatsappNumber!.isEmpty) {
      _showErrorSnackbar("Nomor WhatsApp tidak tersedia.");
      return;
    }

    final cleanPhone = product.whatsappNumber!.replaceAll(
      RegExp(r'[^\d+]'),
      '',
    );
    final whatsappUrl = Uri.parse(
      "https://wa.me/$cleanPhone?text=Halo%20${Uri.encodeComponent(product.storeName)},%20saya%20tertarik%20dengan%20produk%20${Uri.encodeComponent(product.name)}",
    );

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        throw "Tidak dapat membuka aplikasi WhatsApp.";
      }
    } catch (e) {
      _showErrorSnackbar(e.toString());
    }
  }

  Future<void> launchMaps() async {
    if (product.latitude == null || product.longitude == null) {
      _showErrorSnackbar("Koordinat lokasi toko tidak tersedia.");
      return;
    }

    final String destinationCoords = "${product.latitude},${product.longitude}";
    final iosAppUrl = Uri.parse("comgooglemaps://?q=$destinationCoords");
    final androidAppUrl = Uri.parse("google.navigation:q=$destinationCoords");
    final webUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$destinationCoords",
    );

    try {
      if (await canLaunchUrl(iosAppUrl)) {
        await launchUrl(iosAppUrl);
      } else if (await canLaunchUrl(androidAppUrl)) {
        await launchUrl(androidAppUrl);
      } else {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      _showErrorSnackbar(e.toString());
    }
  }

  Future<void> launchWebLink() async {
    if (product.externalLink == null || product.externalLink!.isEmpty) {
      _showErrorSnackbar("Tautan eksternal tidak tersedia.");
      return;
    }
    Get.toNamed('/webview', arguments: product.externalLink!);
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Gagal Membuka Hubungan',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
