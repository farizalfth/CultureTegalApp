import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/culture_model.dart';
import '../../../data/providers/culture_provider.dart';
import '../../../data/service/auth_service.dart';
import '../../../data/service/user_service.dart';

class ExploreController extends GetxController {
  final CultureProvider _cultureProvider = Get.put(CultureProvider());
  final PageController pageController = PageController();

  var currentSliderIndex = 0.obs;
  var selectedCategoryIndex = 0.obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = "".obs;

  var allData = <CultureModel>[].obs;
  var activeSliderItems = <CultureModel>[].obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _waitForAuth();
    fetchCulturesData();
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

  Future<void> fetchCulturesData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = "";

      final List<CultureModel> fetchedData = await _cultureProvider
          .getCultures();
      allData.assignAll(fetchedData);
      _updateSliderItems();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
    } finally {
      isLoading.value = false;
    }
  }

  void _updateSliderItems() {
    List<CultureModel> filtered;
    if (selectedCategoryIndex.value == 0) {
      filtered = allData.where((p) => p.isSlider).toList();
    } else {
      String cat = [
        "Semua",
        "Sejarah",
        "Tradisi",
        "Kuliner",
        "Wisata",
      ][selectedCategoryIndex.value];
      filtered = allData.where((p) => p.category == cat && p.isSlider).toList();
    }

    activeSliderItems.assignAll(filtered.take(5).toList());
    _startAutoSlider();
  }

  void _startAutoSlider() {
    _timer?.cancel();
    currentSliderIndex.value = 0;
    if (pageController.hasClients) pageController.jumpToPage(0);
    if (activeSliderItems.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      int max = activeSliderItems.length;
      if (max > 1) {
        if (currentSliderIndex.value < max - 1) {
          currentSliderIndex.value++;
        } else {
          currentSliderIndex.value = 0;
        }
        if (pageController.hasClients) {
          pageController.animateToPage(
            currentSliderIndex.value,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutQuart,
          );
        }
      }
    });
  }

  List<CultureModel> get filteredPlaces {
    if (selectedCategoryIndex.value == 0) return allData;
    String cat = [
      "Semua",
      "Sejarah",
      "Tradisi",
      "Kuliner",
      "Wisata",
    ][selectedCategoryIndex.value];
    return allData.where((p) => p.category == cat).toList();
  }

  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
    _updateSliderItems();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
