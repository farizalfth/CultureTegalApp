import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPageController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  var searchQuery = "".obs;
  var selectedTab = 0.obs;

  var filter1Value = "Semua".obs;
  var filter2Value = "Semua".obs;

  final Map<int, Map<String, dynamic>> tabConfigs = {
    0: {
      "label1": "Kategori Budaya",
      "items1": ["Semua", "Sejarah", "Budaya", "Alam"],
      "label2": "Urutkan Berdasarkan",
      "items2": ["Semua", "Terbaru", "Terpopuler"],
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
      "items2": ["Semua", "Ongoing", "Upcoming", "Rutin"],
    },
    3: {
      "label1": "Topik Berita",
      "items1": ["Semua", "Pariwisata", "Ekonomi", "Budaya"],
      "label2": "Waktu Publikasi",
      "items2": ["Semua Waktu", "Hari Ini", "1 Minggu", "1 Bulan"],
    },
  };

  void updateQuery(String val) => searchQuery.value = val;

  void resetFilters() {
    filter1Value.value = "Semua";
    filter2Value.value = selectedTab.value == 3 ? "Semua Waktu" : "Semua";
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}