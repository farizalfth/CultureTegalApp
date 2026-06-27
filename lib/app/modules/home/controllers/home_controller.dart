import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/news_model.dart';
import '../../../data/models/umkm_model.dart';
import '../../../data/providers/event_provider.dart';
import '../../../data/providers/news_provider.dart';
import '../../../data/providers/umkm_provider.dart';
import '../../../data/service/user_service.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final EventProvider _eventProvider = Get.find<EventProvider>();
  final UmkmProvider _umkmProvider = Get.find<UmkmProvider>();
  final NewsProvider _newsProvider = Get.find<NewsProvider>();

  final isLoading = false.obs;

  final RxList<EventModel> events = <EventModel>[].obs;
  final RxList<UmkmModel> products = <UmkmModel>[].obs;
  final RxList<NewsModel> newsList = <NewsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    try {
      isLoading.value = true;

      final results = await Future.wait([
        UserService.to.refreshUserData(),
        _eventProvider.getEvents(page: 1, perPage: 3),
        _umkmProvider.getUmkms(page: 1, perPage: 3),
        _newsProvider.getNews(page: 1, perPage: 3),
      ]);

      final Map<String, dynamic> eventData = results[1] as Map<String, dynamic>;
      final List<dynamic> rawEvents = eventData['items'] ?? [];
      events.assignAll(rawEvents.map((e) => EventModel.fromJson(e)).toList());

      final Map<String, dynamic> umkmRaw = results[2] as Map<String, dynamic>;
      final List<dynamic> rawUmkmsParsed = umkmRaw['data']?['items'] ?? [];
      products.assignAll(
        rawUmkmsParsed.map((p) => UmkmModel.fromJson(p)).toList(),
      );

      final Map<String, dynamic> newsData = results[3] as Map<String, dynamic>;
      final List<dynamic> rawNews = newsData['items'] ?? [];
      newsList.assignAll(rawNews.map((n) => NewsModel.fromJson(n)).toList());
    } catch (e) {
      debugPrint("Gagal memuat dashboard beranda: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> syncUserData() async {
    await loadAllData();
  }
}
