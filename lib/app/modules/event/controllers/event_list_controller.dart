import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../event/controllers/event_controller.dart';

class EventListController extends GetxController {
  final EventController _eventController = Get.find<EventController>();

  var isFilterExpanded = false.obs;
  var selectedCategoryIndex = 0.obs;
  var selectedStatus = "Semua".obs;

  final TextEditingController searchController = TextEditingController();
  var searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      selectedCategoryIndex.value = Get.arguments as int;
    }
  }

  void toggleFilter() => isFilterExpanded.value = !isFilterExpanded.value;
  void setCategory(int index) => selectedCategoryIndex.value = index;
  void setStatus(String status) => selectedStatus.value = status;

  List<EventModel> get filteredEvents {
    List<EventModel> combined = [
      ..._eventController.allOngoingEvents,
      ..._eventController.allUpcomingEvents,
    ];

    if (selectedCategoryIndex.value != 0) {
      String cat = [
        "Semua",
        "Budaya",
        "UMKM",
        "Edukasi",
      ][selectedCategoryIndex.value];
      combined = combined.where((e) => e.category == cat).toList();
    }

    if (selectedStatus.value != "Semua") {
      if (selectedStatus.value == "Ongoing") {
        combined = combined
            .where((e) => e.status == "Sedang Berjalan")
            .toList();
      } else {
        combined = combined
            .where((e) => e.status != "Sedang Berjalan")
            .toList();
      }
    }

    if (searchQuery.value.isNotEmpty) {
      combined = combined
          .where(
            (e) =>
                e.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
          )
          .toList();
    }

    return combined;
  }
}