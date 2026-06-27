import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/news_model.dart';
import '../../../data/providers/event_provider.dart';
import '../../../data/providers/news_provider.dart';

class EventController extends GetxController {
  final EventProvider _eventProvider = Get.find<EventProvider>();
  final NewsProvider _newsProvider = Get.find<NewsProvider>();
  final PageController pageController = PageController();

  var currentSliderIndex = 0.obs;
  var selectedCategoryIndex = 0.obs;

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = "".obs;

  final RxList<EventModel> allOngoingEvents = <EventModel>[].obs;
  final RxList<EventModel> allUpcomingEvents = <EventModel>[].obs;
  final RxList<NewsModel> allNews = <NewsModel>[].obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchEventsData();
  }

  Future<void> fetchEventsData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = "";

      final Map<String, dynamic> eventData = await _eventProvider.getEvents();
      final List<dynamic> rawEventItems = eventData['items'] ?? [];
      final List<EventModel> fetchedEvents = rawEventItems
          .map((item) => EventModel.fromJson(item as Map<String, dynamic>))
          .toList();

      final Map<String, dynamic> data = await _newsProvider.getNews(
        category: "Semua",
        page: 1,
        perPage: 4,
      );
      final List<dynamic> rawNewsItems = data['items'] ?? [];
      final List<NewsModel> fetchedNewsList = rawNewsItems
          .map((item) => NewsModel.fromJson(item as Map<String, dynamic>))
          .toList();

      allOngoingEvents.assignAll(
        fetchedEvents.where((e) => e.status == "Sedang Berjalan").toList(),
      );
      allUpcomingEvents.assignAll(
        fetchedEvents.where((e) => e.status != "Sedang Berjalan").toList(),
      );
      allNews.assignAll(fetchedNewsList);

      _startAutoSlider();
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
    } finally {
      isLoading.value = false;
    }
  }

  List<EventModel> get filteredOngoingEvents {
    if (selectedCategoryIndex.value == 0) {
      return allOngoingEvents;
    }
    String cat = [
      "Semua",
      "Budaya",
      "UMKM",
      "Edukasi",
    ][selectedCategoryIndex.value];
    return allOngoingEvents.where((e) => e.category == cat).toList();
  }

  List<EventModel> get filteredUpcomingEvents {
    if (selectedCategoryIndex.value == 0) {
      return allUpcomingEvents
          .where((e) => e.status == "Akan Datang" || e.status == "Rutin")
          .toList();
    }
    String cat = [
      "Semua",
      "Budaya",
      "UMKM",
      "Edukasi",
    ][selectedCategoryIndex.value];
    return allUpcomingEvents
        .where(
          (e) =>
              e.category == cat &&
              (e.status == "Akan Datang" || e.status == "Rutin"),
        )
        .toList();
  }

  List<NewsModel> get filteredNews {
    if (selectedCategoryIndex.value == 0) {
      return allNews;
    }
    String cat = [
      "Semua",
      "Budaya",
      "UMKM",
      "Edukasi",
    ][selectedCategoryIndex.value];
    return allNews.where((n) => n.category == cat).toList();
  }

  void _startAutoSlider() {
    _timer?.cancel();
    currentSliderIndex.value = 0;
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
    if (filteredOngoingEvents.isEmpty) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      int max = filteredOngoingEvents.length;
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

  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
    currentSliderIndex.value = 0;
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
    _startAutoSlider();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
