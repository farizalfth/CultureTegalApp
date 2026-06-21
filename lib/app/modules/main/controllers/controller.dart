import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/service/auth_service.dart';
import '../../event/controllers/event_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../../data/service/user_service.dart';
import '../../explore/controllers/explore_controller.dart';

class MainController extends GetxController with WidgetsBindingObserver {
  var currentIndex = 0.obs;
  var isFabExpanded = false.obs;

  var isBooting = true.obs;
  var bootError = false.obs;
  var bootErrorMessage = "".obs;

  final ScrollController homeScrollController = ScrollController();
  final ScrollController exploreScrollController = ScrollController();
  final ScrollController umkmScrollController = ScrollController();
  final ScrollController eventScrollController = ScrollController();

  var showScrollToTop = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _setupScrollListeners();
    initializeSystem();
  }

  void _setupScrollListeners() {
    homeScrollController.addListener(_scrollListener);
    exploreScrollController.addListener(_scrollListener);
    umkmScrollController.addListener(_scrollListener);
    eventScrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final activeController = _getActiveScrollController();
    if (activeController != null && activeController.hasClients) {
      if (activeController.offset > 400) {
        showScrollToTop.value = true;
      } else {
        showScrollToTop.value = false;
      }
    } else {
      showScrollToTop.value = false;
    }
  }

  ScrollController? _getActiveScrollController() {
    switch (currentIndex.value) {
      case 0:
        return homeScrollController;
      case 1:
        return exploreScrollController;
      case 2:
        return umkmScrollController;
      case 3:
        return eventScrollController;
      default:
        return null;
    }
  }

  void scrollToTop() {
    final activeController = _getActiveScrollController();
    if (activeController != null && activeController.hasClients) {
      activeController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutQuart,
      );
    }
  }

  Future<void> initializeSystem() async {
    try {
      isBooting.value = true;
      bootError.value = false;
      bootErrorMessage.value = "";

      await _waitForAuth();

      if (Get.isRegistered<UserService>()) {
        await Get.find<UserService>().refreshUserData();
      }

      if (Get.isRegistered<ExploreController>()) {
        await Get.find<ExploreController>().fetchCulturesData();
      }

      if (Get.isRegistered<EventController>()) {
        await Get.find<EventController>().fetchEventsData();
      }

      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().loadAllData();
      }

      isBooting.value = false;
    } catch (e) {
      bootError.value = true;
      bootErrorMessage.value = e.toString().replaceAll("Exception: ", "");
      isBooting.value = false;
    }
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

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    homeScrollController.dispose();
    exploreScrollController.dispose();
    umkmScrollController.dispose();
    eventScrollController.dispose();
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
    _scrollListener();
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
