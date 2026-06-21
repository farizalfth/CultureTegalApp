import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/service/user_service.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final isLoading = false.obs;

  final RxList<EventModel> events = <EventModel>[
    EventModel(
      id: "1",
      name: "Festival Bahari Tegal",
      location: "Alun-alun Kota Tegal",
      detailedAddress: "Jl. Pancasila No.1, Tegal, Jawa Tengah",
      imageUrl:
          "https://radarcbs.com/assets/images/1770943164_1840ce5bbf3c827b7d85.jpg",
      schedule: "25 Mei 2024",
      fullDate: "Sabtu, 25 Mei 2024",
      time: "09.00 - 22.00 WIB",
      status: "Akan Datang",
      category: "Budaya",
      description:
          "Festival Bahari Tegal adalah acara tahunan yang merayakan kekayaan budaya dan potensi bahari Kota Tegal. Akan dimeriahkan dengan berbagai pertunjukan seni, lomba, kuliner khas Tegal, dan pameran UMKM.",
      audience: "Terbuka untuk umum",
      ticketPrice: "Gratis (Terbuka untuk umum)",
      latitude: -6.8672,
      longitude: 109.1380,
      badgeTop: "25",
      badgeBottom: "Mei",
      highlights: [
        EventHighlight(
          name: "Pertunjukan\nSeni",
          icon: Icons.theater_comedy_rounded,
        ),
        EventHighlight(name: "Kuliner\nKhas", icon: Icons.soup_kitchen_rounded),
        EventHighlight(name: "Pameran\nUMKM", icon: Icons.storefront_rounded),
        EventHighlight(
          name: "Lomba &\nGames",
          icon: Icons.emoji_events_rounded,
        ),
      ],
    ),
    EventModel(
      id: "2",
      name: "Senam Pagi Massal",
      location: "Alun-Alun Tegal",
      detailedAddress: "Kawasan Alun-Alun, Mangkukusuman",
      imageUrl: null,
      schedule: "Setiap Minggu",
      fullDate: "Setiap Hari Minggu",
      time: "06.00 - 09.00 WIB",
      status: "Rutin",
      category: "Olahraga",
      description:
          "Kegiatan senam massal gratis untuk seluruh warga kota guna menjaga kesehatan dan kebugaran bersama.",
      audience: "Terbuka untuk umum",
      ticketPrice: "Gratis",
      isRecurring: true,
      latitude: -6.8672,
      longitude: 109.1380,
      badgeTop: "Tiap",
      badgeBottom: "Mggu",
    ),
    EventModel(
      id: "3",
      name: "Pameran Inovasi UMKM",
      location: "Gedung Birao (SCS)",
      detailedAddress: "Jl. Pancasila, Tegal Timur",
      imageUrl:
          "https://madosijateng.com/uploads/202209093030102104-DSC09666_11zon.jpg",
      schedule: "Senin - Kamis",
      fullDate: "Setiap Senin s/d Kamis",
      time: "09.00 - 19.00 WIB",
      status: "Akan Datang",
      category: "Ekonomi",
      description:
          "Pameran yang menampilkan ratusan produk inovatif dari pegiat UMKM Kota Tegal, mulai dari fashion, kuliner, hingga kriya.",
      audience: "Terbuka untuk umum",
      ticketPrice: "Gratis",
      latitude: -6.8617,
      longitude: 109.1384,
      isRecurring: true,
      badgeTop: "Sen",
      badgeBottom: "Kam",
      highlights: [
        EventHighlight(name: "Bazar\nProduk", icon: Icons.shopping_bag_rounded),
        EventHighlight(name: "Talkshow\nBisnis", icon: Icons.mic_rounded),
      ],
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        UserService.to.refreshUserData(),
        Future.delayed(const Duration(seconds: 1)),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  void onScanTap() {}

  void onProfileTap() {}

  void onMenuTap(String menuName) {}

  void onSeeAllMarketplace() {}
}
