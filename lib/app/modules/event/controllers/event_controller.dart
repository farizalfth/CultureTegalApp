import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/news_model.dart';

class EventController extends GetxController {
  var selectedCategoryIndex = 0.obs;
  var currentSliderIndex = 0.obs;
  final PageController pageController = PageController();
  Timer? _timer;

  final RxList<EventModel> allOngoingEvents = <EventModel>[
    EventModel(
      id: "e1",
      name: "Festival Bahari Tegal",
      location: "Kawasan Pantai Alam Indah",
      detailedAddress: "Jl. Sangir, Mintaragen, Tegal Timur",
      schedule: "25 Mei 2024",
      fullDate: "Sabtu, 25 Mei 2024",
      time: "09.00 - 22.00 WIB",
      category: "Budaya",
      imageUrl:
          "https://radarcbs.com/assets/images/1770943164_1840ce5bbf3c827b7d85.jpg",
      status: "Sedang Berjalan",
      description: "Festival tahunan yang merayakan kekayaan budaya pesisir.",
      audience: "Terbuka untuk umum",
      ticketPrice: "Gratis",
      latitude: -6.8500,
      longitude: 109.1400,
      badgeTop: "25",
      badgeBottom: "Mei",
    ),
    EventModel(
      id: "e4",
      name: "Pasar Seni Rakyat",
      location: "Alun-Alun Tegal",
      detailedAddress: "Kawasan Alun-Alun, Tegal",
      schedule: "26 Mei 2024",
      fullDate: "Minggu, 26 Mei 2024",
      time: "16.00 - 23.00 WIB",
      category: "Budaya",
      imageUrl:
          "https://asset.kompas.com/crops/En36rOebrLoFmlPusvTXHcwuNik=/132x43:823x504/750x500/data/photo/2023/06/16/648c7d59d1e20.png",
      status: "Sedang Berjalan",
      description: "Pameran seni jalanan dan pertunjukan musik lokal.",
      audience: "Terbuka untuk umum",
      ticketPrice: "Gratis",
      latitude: -6.8672,
      longitude: 109.1380,
      badgeTop: "26",
      badgeBottom: "Mei",
    ),
  ].obs;

  final RxList<EventModel> allUpcomingEvents = <EventModel>[
    EventModel(
      id: "e2",
      name: "Pameran Inovasi UMKM",
      location: "Gedung Birao (SCS)",
      detailedAddress: "Jl. Pancasila, Tegal Timur",
      schedule: "Senin - Jumat",
      fullDate: "Setiap Senin s/d Jumat",
      time: "09.00 - 18.00 WIB",
      category: "UMKM",
      imageUrl:
          "https://madosijateng.com/uploads/202209093030102104-DSC09666_11zon.jpg",
      status: "Rutin",
      description: "Pameran produk unggulan UMKM lokal.",
      audience: "Terbuka untuk umum",
      ticketPrice: "Gratis",
      isRecurring: true,
      latitude: -6.8617,
      longitude: 109.1384,
      badgeTop: "Sen",
      badgeBottom: "Jum",
    ),
    EventModel(
      id: "e3",
      name: "Workshop Koding",
      location: "Gedung Pusat Edukasi",
      detailedAddress: "Jl. Pendidikan No.2",
      schedule: "10 Jun 2024",
      fullDate: "Senin, 10 Juni 2024",
      time: "08.00 - 15.00 WIB",
      category: "Edukasi",
      imageUrl: null,
      status: "Akan Datang",
      description: "Belajar programming dasar untuk siswa.",
      audience: "Siswa SMA/SMK",
      ticketPrice: "Rp 50.000",
      latitude: -6.8700,
      longitude: 109.1300,
      badgeTop: "10",
      badgeBottom: "Jun",
    ),
  ].obs;

  final RxList<NewsModel> allNews = <NewsModel>[
    NewsModel(
      id: "n1",
      title: "Gereja Blenduk Jadi Ikon Sejarah Kota Tegal",
      category: "Budaya",
      date: "20 Mei 2024",
      image:
          "https://radarcbs.com/assets/images/1770943164_1840ce5bbf3c827b7d85.jpg",
    ),
    NewsModel(
      id: "n2",
      title: "Tahu Aci Khas Tegal Semakin Diminati Wisatawan",
      category: "Kuliner",
      date: "19 Mei 2024",
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQviHVXAO_su-hxtU7dqtrRCwBZMM0BotQGBs1hwfk9b_4_uJ0e-Njlzm2_dIjurP5kD8-00rKiMNkG9XSjQ3sKxQr_Fs3Ig_FwD8p84g&s=10",
    ),
  ].obs;

  List<EventModel> get filteredOngoingEvents {
    if (selectedCategoryIndex.value == 0) return allOngoingEvents;
    String cat = [
      "Semua",
      "Budaya",
      "UMKM",
      "Edukasi",
    ][selectedCategoryIndex.value];
    return allOngoingEvents.where((e) => e.category == cat).toList();
  }

  List<EventModel> get filteredUpcomingEvents {
    if (selectedCategoryIndex.value == 0) return allUpcomingEvents;
    String cat = [
      "Semua",
      "Budaya",
      "UMKM",
      "Edukasi",
    ][selectedCategoryIndex.value];
    return allUpcomingEvents.where((e) => e.category == cat).toList();
  }

  List<NewsModel> get filteredNews {
    if (selectedCategoryIndex.value == 0) return allNews;
    String cat = [
      "Semua",
      "Budaya",
      "UMKM",
      "Edukasi",
    ][selectedCategoryIndex.value];
    return allNews.where((n) => n.category == cat).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _startAutoSlider();
  }

  void _startAutoSlider() {
    _timer?.cancel();
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
    if (pageController.hasClients) pageController.jumpToPage(0);
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
