import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/providers/event_provider.dart';

class EventListController extends GetxController {
  final EventProvider _eventProvider = Get.find<EventProvider>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  var isFilterExpanded = false.obs;
  var selectedCategoryIndex = 0.obs;
  var selectedStatus = "Semua".obs;
  var searchQuery = "".obs;

  var isLoading = false.obs;
  var isLoadMore = false.obs;
  var currentPage = 1;
  var hasNextPage = true.obs;
  final RxList<EventModel> eventList = <EventModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _handleIncomingArguments();
    scrollController.addListener(_scrollListener);
    fetchInitialEvents();
  }

  void _handleIncomingArguments() {
    final dynamic args = Get.arguments;
    if (args != null) {
      if (args is int) {
        selectedCategoryIndex.value = args;
      } else if (args is Map<String, dynamic>) {
        selectedCategoryIndex.value = args['category'] ?? 0;
        selectedStatus.value = args['status'] ?? "Semua";
        isFilterExpanded.value = args['expandFilter'] ?? false;
      }
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (hasNextPage.value && !isLoadMore.value && !isLoading.value) {
        loadMoreEvents();
      }
    }
  }

  Future<void> fetchInitialEvents() async {
    try {
      isLoading.value = true;
      currentPage = 1;
      hasNextPage.value = true;

      String cat = [
        "Semua",
        "Budaya",
        "UMKM",
        "Edukasi",
      ][selectedCategoryIndex.value];
      final data = await _eventProvider.getEvents(
        category: cat,
        status: selectedStatus.value,
        page: currentPage,
        perPage: 10,
      );

      final List<dynamic> rawItems = data['items'] ?? [];
      final List<EventModel> items = rawItems
          .map((item) => EventModel.fromJson(item as Map<String, dynamic>))
          .toList();

      eventList.assignAll(items);
      hasNextPage.value = data['has_next'] as bool? ?? false;
    } catch (e) {
      debugPrint("Gagal memuat event awal: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreEvents() async {
    try {
      isLoadMore.value = true;
      currentPage++;

      String cat = [
        "Semua",
        "Budaya",
        "UMKM",
        "Edukasi",
      ][selectedCategoryIndex.value];
      final data = await _eventProvider.getEvents(
        category: cat,
        status: selectedStatus.value,
        page: currentPage,
        perPage: 10,
      );

      final List<dynamic> rawItems = data['items'] ?? [];
      final List<EventModel> items = rawItems
          .map((item) => EventModel.fromJson(item as Map<String, dynamic>))
          .toList();

      eventList.addAll(items);
      hasNextPage.value = data['has_next'] as bool? ?? false;
    } catch (e) {
      currentPage--;
      debugPrint("Gagal memuat halaman event berikutnya: $e");
    } finally {
      isLoadMore.value = false;
    }
  }

  void toggleFilter() => isFilterExpanded.value = !isFilterExpanded.value;

  void setCategory(int index) {
    selectedCategoryIndex.value = index;
    fetchInitialEvents();
  }

  void setStatus(String status) {
    selectedStatus.value = status;
    fetchInitialEvents();
  }

  List<EventModel> get filteredEvents {
    if (searchQuery.value.isEmpty) return eventList;
    return eventList
        .where(
          (e) => e.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
