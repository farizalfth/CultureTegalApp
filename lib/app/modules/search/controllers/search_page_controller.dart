import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/news_model.dart';
import '../../../data/models/umkm_model.dart';
import '../../../data/providers/culture_provider.dart';
import '../../../data/providers/umkm_provider.dart';
import '../../../data/providers/event_provider.dart';
import '../../../data/providers/news_provider.dart';
import '../../../data/service/auth_service.dart';

class SearchPageController extends GetxController {
  final CultureProvider _cultureProvider = Get.isRegistered<CultureProvider>()
      ? Get.find<CultureProvider>()
      : Get.put(CultureProvider());

  final UmkmProvider _umkmProvider = Get.isRegistered<UmkmProvider>()
      ? Get.find<UmkmProvider>()
      : Get.put(UmkmProvider());

  final EventProvider _eventProvider = Get.isRegistered<EventProvider>()
      ? Get.find<EventProvider>()
      : Get.put(EventProvider());

  final NewsProvider _newsProvider = Get.isRegistered<NewsProvider>()
      ? Get.find<NewsProvider>()
      : Get.put(NewsProvider());

  final TextEditingController searchController = TextEditingController();
  var searchQuery = "".obs;
  var selectedTab = 0.obs;

  var filter1Value = "Semua".obs;
  var filter2Value = "Semua".obs;

  var isLoadingCultures = false.obs;
  var isLoadingUmkms = false.obs;
  var isLoadingEvents = false.obs;
  var isLoadingNews = false.obs;

  final RxList<CultureModel> searchedCulturesList = <CultureModel>[].obs;
  final RxList<UmkmModel> searchedUmkmsList = <UmkmModel>[].obs;
  final RxList<EventModel> searchedEventsList = <EventModel>[].obs;
  final RxList<NewsModel> searchedNewsList = <NewsModel>[].obs;

  final Map<int, Map<String, dynamic>> tabConfigs = {
    0: {
      "label1": "Kategori Budaya",
      "items1": ["Semua", "Sejarah", "Tradisi", "Kuliner", "Wisata"],
      "label2": "Urutkan Berdasarkan",
      "items2": ["Semua", "Terbaru"],
    },
    1: {
      "label1": "Kategori Produk",
      "items1": ["Semua", "Kuliner", "Fashion", "Kriya"],
      "label2": "Rentang Harga",
      "items2": ["Semua", "Termurah", "Termahal"],
    },
    2: {
      "label1": "Jenis Event",
      "items1": ["Semua", "Budaya", "UMKM", "Edukasi"],
      "label2": "Status Pelaksanaan",
      "items2": ["Semua", "Berjalan", "Mendatang", "Selesai"],
    },
    3: {
      "label1": "Topik Berita",
      "items1": ["Semua", "Budaya", "UMKM", "Edukasi"],
      "label2": "Waktu Publikasi",
      "items2": ["Semua Waktu", "Hari Ini", "1 Minggu", "1 Bulan"],
    },
  };

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _waitForAuth();
    debounce(
      searchQuery,
      (_) => fetchSearchResults(),
      time: const Duration(milliseconds: 500),
    );
    fetchSearchResults();
  }

  Future<void> _waitForAuth() async {
    final authService = Get.find<AuthService>();
    int retry = 0;
    while (authService.currentToken == null && retry < 30) {
      await Future.delayed(const Duration(milliseconds: 150));
      retry++;
    }
  }

  void updateQuery(String val) => searchQuery.value = val;

  void changeCategoryTab(int index) {
    selectedTab.value = index;
    resetFilters();
    fetchSearchResults();
  }

  void changeFilter1(String val) {
    filter1Value.value = val;
    fetchSearchResults();
  }

  void changeFilter2(String val) {
    filter2Value.value = val;
    fetchSearchResults();
  }

  void resetFilters() {
    filter1Value.value = "Semua";
    filter2Value.value = selectedTab.value == 3 ? "Semua Waktu" : "Semua";
  }

  Future<void> fetchSearchResults() async {
    final tab = selectedTab.value;
    if (tab == 0) {
      await fetchCultureSearchResults();
    } else if (tab == 1) {
      await fetchUmkmSearchResults();
    } else if (tab == 2) {
      await fetchEventSearchResults();
    } else if (tab == 3) {
      await fetchNewsSearchResults();
    }
  }

  Future<void> fetchCultureSearchResults() async {
    final int activeTabAtStart = selectedTab.value;
    isLoadingCultures.value = true;
    try {
      final list = await _cultureProvider.getCultures(
        category: filter1Value.value,
        search: searchQuery.value,
      );
      if (selectedTab.value == activeTabAtStart) {
        searchedCulturesList.assignAll(list);
      }
    } catch (e) {
      if (selectedTab.value == activeTabAtStart) {
        searchedCulturesList.clear();
      }
    } finally {
      if (selectedTab.value == activeTabAtStart) {
        isLoadingCultures.value = false;
      }
    }
  }

  Future<void> fetchUmkmSearchResults() async {
    final int activeTabAtStart = selectedTab.value;
    isLoadingUmkms.value = true;
    try {
      final response = await _umkmProvider.getUmkms(
        category: filter1Value.value,
        search: searchQuery.value,
        sort: filter2Value.value,
        page: 1,
        perPage: 20,
      );
      if (selectedTab.value == activeTabAtStart) {
        final List<dynamic> items = response['data']?['items'] ?? [];
        final products = items.map((item) => UmkmModel.fromJson(item)).toList();
        searchedUmkmsList.assignAll(products);
      }
    } catch (e) {
      if (selectedTab.value == activeTabAtStart) {
        searchedUmkmsList.clear();
      }
    } finally {
      if (selectedTab.value == activeTabAtStart) {
        isLoadingUmkms.value = false;
      }
    }
  }

  Future<void> fetchEventSearchResults() async {
    final int activeTabAtStart = selectedTab.value;
    isLoadingEvents.value = true;
    try {
      final response = await _eventProvider.getEvents(
        category: filter1Value.value,
        status: filter2Value.value,
        search: searchQuery.value,
        page: 1,
        perPage: 20,
      );
      if (selectedTab.value == activeTabAtStart) {
        final List<dynamic> items = response['items'] ?? [];
        final list = items.map((item) => EventModel.fromJson(item)).toList();
        searchedEventsList.assignAll(list);
      }
    } catch (e) {
      if (selectedTab.value == activeTabAtStart) {
        searchedEventsList.clear();
      }
    } finally {
      if (selectedTab.value == activeTabAtStart) {
        isLoadingEvents.value = false;
      }
    }
  }

  Future<void> fetchNewsSearchResults() async {
    final int activeTabAtStart = selectedTab.value;
    isLoadingNews.value = true;
    try {
      final response = await _newsProvider.getNews(
        category: filter1Value.value,
        search: searchQuery.value,
        page: 1,
        perPage: 20,
      );
      if (selectedTab.value == activeTabAtStart) {
        final List<dynamic> items = response['items'] ?? [];
        final list = items.map((item) => NewsModel.fromJson(item)).toList();
        searchedNewsList.assignAll(list);
      }
    } catch (e) {
      if (selectedTab.value == activeTabAtStart) {
        searchedNewsList.clear();
      }
    } finally {
      if (selectedTab.value == activeTabAtStart) {
        isLoadingNews.value = false;
      }
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
