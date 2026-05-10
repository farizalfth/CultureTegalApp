import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/news_model.dart';
import '../../event/controllers/event_controller.dart';

class NewsListController extends GetxController {
  final EventController _eventController = Get.find<EventController>();
  var selectedCategoryIndex = 0.obs;
  final TextEditingController searchController = TextEditingController();
  var searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      selectedCategoryIndex.value = Get.arguments as int;
    }
  }

  void setCategory(int index) => selectedCategoryIndex.value = index;

  List<NewsModel> get filteredNews {
    List<NewsModel> combined = _eventController.allNews;
    if (selectedCategoryIndex.value != 0) {
      String cat = [
        "Semua",
        "Budaya",
        "UMKM",
        "Edukasi",
      ][selectedCategoryIndex.value];
      combined = combined.where((n) => n.category == cat).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      combined = combined
          .where(
            (n) =>
                n.title.toLowerCase().contains(searchQuery.value.toLowerCase()),
          )
          .toList();
    }
    return combined;
  }
}