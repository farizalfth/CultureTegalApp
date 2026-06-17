// lib/app/modules/main/controllers/main_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';

class MainController extends GetxController with WidgetsBindingObserver {
  var currentIndex = 0.obs;
  var isFabExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      if (Get.isRegistered<HomeController>()) {
        HomeController.to.loadAllData();
      }
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (isFabExpanded.value) {
      isFabExpanded.value = false;
    }
  }

  void toggleFab() {
    isFabExpanded.value = !isFabExpanded.value;
  }

  void goToUmkm() => print("Navigasi ke UMKM");
  void goToScan() => print("Navigasi ke Scan");
  void goToMap() => print("Navigasi ke Map");
}
