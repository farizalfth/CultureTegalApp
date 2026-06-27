import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/umkm_model.dart';
import '../../../data/providers/umkm_provider.dart';
import '../../../data/service/auth_service.dart';

class UmkmController extends GetxController {
  final UmkmProvider _umkmProvider = Get.find<UmkmProvider>();

  var selectedCategoryIndex = 0.obs;
  var isLoading = false.obs;

  final RxList<UmkmModel> allProducts = <UmkmModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _waitForAuth();
    fetchProducts();
  }

  Future<void> _waitForAuth() async {
    final authService = Get.find<AuthService>();
    for (int i = 0; i < 15; i++) {
      if (authService.currentToken != null) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      final response = await _umkmProvider.getUmkms(page: 1, perPage: 20);
      final List<dynamic> items = response['data']?['items'] ?? [];

      final products = items.map((item) => UmkmModel.fromJson(item)).toList();
      allProducts.assignAll(products);
    } catch (e) {
      Get.snackbar(
        'Gagal Memuat Produk',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<UmkmModel> get filteredProducts {
    if (selectedCategoryIndex.value == 0) return allProducts;
    final categories = ["Semua", "Kuliner", "Fashion", "Kriya"];
    String cat = categories[selectedCategoryIndex.value];
    return allProducts.where((p) => p.category == cat).toList();
  }

  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
  }
}
