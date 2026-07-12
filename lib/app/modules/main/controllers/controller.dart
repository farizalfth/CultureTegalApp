import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/service/auth_service.dart';
import '../../event/controllers/event_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../../data/service/user_service.dart';
import '../../explore/controllers/explore_controller.dart';
import '../../umkm/controllers/umkm_controller.dart';
import '../../../routes/app_pages.dart';

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

      isBooting.value = false;

      _triggerLazyLoad(0);
    } catch (e) {
      bootError.value = true;
      bootErrorMessage.value = e.toString().replaceAll("Exception: ", "");
      isBooting.value = false;
    }
  }

  Future<void> _waitForAuth() async {
    await Get.find<AuthService>().waitForSession();
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
    _triggerLazyLoad(index);
  }

  void _triggerLazyLoad(int index) {
    switch (index) {
      case 0:
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().loadAllData();
        }
        break;
      case 1:
        if (Get.isRegistered<ExploreController>()) {
          final ctrl = Get.find<ExploreController>();
          if (ctrl.allData.isEmpty && !ctrl.isLoading.value) {
            ctrl.fetchCulturesData();
          }
        }
        break;
      case 2:
        if (Get.isRegistered<UmkmController>()) {
          final ctrl = Get.find<UmkmController>();
          if (ctrl.allProducts.isEmpty && !ctrl.isLoading.value) {
            ctrl.fetchProducts();
          }
        }
        break;
      case 3:
        if (Get.isRegistered<EventController>()) {
          final ctrl = Get.find<EventController>();
          if (ctrl.allOngoingEvents.isEmpty && !ctrl.isLoading.value) {
            ctrl.fetchEventsData();
          }
        }
        break;
    }
  }

  void toggleFab() {
    isFabExpanded.value = !isFabExpanded.value;
  }

  void goToUmkm() {
    changePage(2);
  }

  void goToScan() {
    if (isFabExpanded.value) {
      isFabExpanded.value = false;
    }
    Get.toNamed(Routes.AI_SCAN);
  }

  void goToMap() {
    if (isFabExpanded.value) {
      isFabExpanded.value = false;
    }
    Get.toNamed(Routes.MAP_EXPLORE);
  }

  void goToQuiz() {
    if (isFabExpanded.value) {
      isFabExpanded.value = false;
    }
    Get.toNamed(Routes.KUIS_BUDAYA);
  }
}
