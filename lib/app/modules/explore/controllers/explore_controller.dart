import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../data/models/culture_model.dart';
import '../../../data/providers/culture_provider.dart';
import '../../../data/service/auth_service.dart';

class ExploreController extends GetxController {
  final CultureProvider _cultureProvider = Get.find<CultureProvider>();
  final PageController pageController = PageController();
  final AuthService _authService = Get.find<AuthService>();
  final String baseUrl = dotenv.env['FLASK_API_URL'] ?? '';

  var currentSliderIndex = 0.obs;
  var selectedCategoryIndex = 0.obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = "".obs;

  var allData = <CultureModel>[].obs;
  var activeSliderItems = <CultureModel>[].obs;
  final RxSet<String> favoritedSiteIds = <String>{}.obs;

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

      await _authService.waitForSession();

      final List<CultureModel> fetchedData = await _cultureProvider
          .getCultures();
      allData.assignAll(fetchedData);
      _updateSliderItems();
      await loadFavoriteSites();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFavoriteSites() async {
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http.get(
        Uri.parse('$cleanBase/users/favorites'),
        headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> cultures = body['data']?['cultures'] ?? [];
        favoritedSiteIds.assignAll(
          cultures.map((c) => c['id'].toString()).toSet(),
        );
      }
    } catch (_) {}
  }

  Future<void> toggleFavorite(String siteId) async {
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http.post(
        Uri.parse('$cleanBase/users/favorites/toggle'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_authService.currentToken}',
        },
        body: json.encode({'target_type': 'culture', 'target_id': siteId}),
      );

      if (response.statusCode == 200) {
        if (favoritedSiteIds.contains(siteId)) {
          favoritedSiteIds.remove(siteId);
        } else {
          favoritedSiteIds.add(siteId);
        }
      }
    } catch (_) {}
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
