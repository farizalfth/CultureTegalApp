import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/news_model.dart';
import '../../explore/controllers/explore_controller.dart';
import '../../event/controllers/event_controller.dart';

class SearchPageController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  var searchQuery = "".obs;
  var selectedTab = 0.obs;

  var filter1Value = "Semua".obs;
  var filter2Value = "Semua".obs;

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

  void updateQuery(String val) => searchQuery.value = val;

  void resetFilters() {
    filter1Value.value = "Semua";
    filter2Value.value = selectedTab.value == 3 ? "Semua Waktu" : "Semua";
  }

  List<CultureModel> get filteredCultures {
    if (!Get.isRegistered<ExploreController>()) return [];
    List<CultureModel> list = Get.find<ExploreController>().allData;

    if (searchQuery.value.isNotEmpty) {
      list = list
          .where(
            (c) =>
                c.title.toLowerCase().contains(searchQuery.value.toLowerCase()),
          )
          .toList();
    }

    if (filter1Value.value != "Semua") {
      list = list.where((c) => c.category == filter1Value.value).toList();
    }

    return list;
  }

  List<EventModel> get filteredEvents {
    if (!Get.isRegistered<EventController>()) return [];
    final ec = Get.find<EventController>();
    List<EventModel> list = [...ec.allOngoingEvents, ...ec.allUpcomingEvents];

    if (searchQuery.value.isNotEmpty) {
      list = list
          .where(
            (e) =>
                e.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
          )
          .toList();
    }

    if (filter1Value.value != "Semua") {
      list = list.where((e) => e.category == filter1Value.value).toList();
    }

    if (filter2Value.value != "Semua") {
      if (filter2Value.value == "Berjalan") {
        list = list.where((e) => e.status == "Sedang Berjalan").toList();
      } else if (filter2Value.value == "Mendatang") {
        list = list
            .where((e) => e.status == "Akan Datang" || e.status == "Rutin")
            .toList();
      } else if (filter2Value.value == "Selesai") {
        list = list.where((e) => e.status == "Selesai").toList();
      }
    }

    return list;
  }

  List<NewsModel> get filteredNews {
    if (!Get.isRegistered<EventController>()) return [];
    List<NewsModel> list = Get.find<EventController>().allNews;

    if (searchQuery.value.isNotEmpty) {
      list = list
          .where(
            (n) =>
                n.title.toLowerCase().contains(searchQuery.value.toLowerCase()),
          )
          .toList();
    }

    if (filter1Value.value != "Semua") {
      list = list.where((n) => n.category == filter1Value.value).toList();
    }

    return list;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
