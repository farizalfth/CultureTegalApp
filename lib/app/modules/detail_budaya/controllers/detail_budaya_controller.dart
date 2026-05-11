import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/models.dart';

class DetailBudayaController extends GetxController {
  late CultureModel culture;
  final PageController pageController = PageController();
  final currentIndex = 0.obs;
  final isExpanded = false.obs;
  final isFavorite = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    culture = Get.arguments as CultureModel;
    _startAutoSlide();
  }

  void _startAutoSlide() {
    if (culture.gallery.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (pageController.hasClients) {
          int nextIndex = (currentIndex.value + 1) % culture.gallery.length;
          if (nextIndex < 5) {
            pageController.animateToPage(
              nextIndex,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
            );
          } else {
            pageController.animateToPage(0, duration: const Duration(milliseconds: 1000), curve: Curves.easeInOut);
          }
        }
      });
    }
  }

  void toggleExpand() => isExpanded.value = !isExpanded.value;
  void toggleFavorite() => isFavorite.value = !isFavorite.value;

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}