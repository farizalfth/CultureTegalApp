import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/event_list_controller.dart';
import '../../../data/models/event_model.dart';
import '../../../utils/shimmer_placeholder.dart';

class EventListView extends GetView<EventListController> {
  const EventListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              10,
              context.mediaQueryPadding.top + 10,
              10,
              10,
            ),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black87,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: controller.searchController,
                          onChanged: (val) =>
                              controller.searchQuery.value = val,
                          decoration: const InputDecoration(
                            hintText: "Cari event...",
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Obx(
                      () => GestureDetector(
                        onTap: () => controller.toggleFilter(),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: controller.isFilterExpanded.value
                                ? AppColors.accent
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.tune_rounded,
                            color: controller.isFilterExpanded.value
                                ? Colors.white
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: controller.isFilterExpanded.value
                        ? _buildFilterPanel()
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final events = controller.filteredEvents;
              if (events.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy_rounded,
                        size: 60,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Tidak ada event ditemukan.",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(10),
                itemCount:
                    events.length + (controller.isLoadMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < events.length) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () => Get.toNamed(
                          Routes.DETAIL_EVENT,
                          arguments: events[index],
                        ),
                        child: _eventCard(events[index]),
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    final categories = ["Semua", "Budaya", "UMKM", "Edukasi"];
    final statuses = ["Semua", "Berjalan", "Mendatang", "Selesai"];

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              return Row(
                children: List.generate(
                  categories.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(
                        categories[index],
                        style: TextStyle(
                          color: controller.selectedCategoryIndex.value == index
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      selected: controller.selectedCategoryIndex.value == index,
                      selectedColor: AppColors.primary,
                      onSelected: (val) => controller.setCategory(index),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 15),
          const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Obx(() {
            return Row(
              children: statuses
                  .map(
                    (status) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        showCheckmark: false,
                        label: Text(
                          status,
                          style: TextStyle(
                            color: controller.selectedStatus.value == status
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                        selected: controller.selectedStatus.value == status,
                        selectedColor: AppColors.accent,
                        onSelected: (val) => controller.setStatus(status),
                      ),
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _eventCard(EventModel event) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: event.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: event.imageUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const ShimmerPlaceholder(
                          width: 100,
                          height: 100,
                          borderRadius: 18,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Image.asset(
                        'assets/images/login/cover_login.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        event.badgeTop,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        event.badgeBottom,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    event.category,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  event.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
