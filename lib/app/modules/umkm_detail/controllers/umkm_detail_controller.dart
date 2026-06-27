import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/umkm_model.dart';
import '../../../data/models/review_model.dart';
import '../../../data/providers/umkm_provider.dart';

class UmkmDetailController extends GetxController {
  final UmkmProvider _umkmProvider = Get.find<UmkmProvider>();

  late final UmkmModel product;
  final isLoadingReviews = false.obs;
  final reviews = <ReviewModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments as UmkmModel;
    fetchReviewsLimit();
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

    final mapsUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${product.latitude},${product.longitude}",
    );

    try {
      if (await canLaunchUrl(mapsUrl)) {
        await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
      } else {
        throw "Tidak dapat membuka aplikasi Peta.";
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

    final webUrl = Uri.parse(product.externalLink!);

    try {
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } else {
        throw "Tidak dapat membuka browser.";
      }
    } catch (e) {
      _showErrorSnackbar(e.toString());
    }
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
