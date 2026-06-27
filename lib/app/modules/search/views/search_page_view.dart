import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/search_page_controller.dart';
import '../../../data/models/models.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/news_model.dart';
import '../../../data/models/umkm_model.dart';
import '../../../utils/shimmer_placeholder.dart';

class SearchPageView extends GetView<SearchPageController> {
  const SearchPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black87,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      autofocus: true,
                      onChanged: controller.updateQuery,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: "Cari sesuatu...",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottom: TabBar(
            onTap: (index) {
              controller.changeCategoryTab(index);
            },
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            tabs: const [
              Tab(text: "Jelajah"),
              Tab(text: "UMKM"),
              Tab(text: "Event"),
              Tab(text: "Berita"),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildFilterBar(),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildCulturesResultList(),
                  _buildUmkmsResultList(),
                  _buildEventsResultList(),
                  _buildNewsResultList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Obx(() {
        final config = controller.tabConfigs[controller.selectedTab.value]!;
        return Row(
          children: [
            Expanded(
              child: _buildDropdownFilter(
                label: config['label1'],
                value: controller.filter1Value,
                items: config['items1'],
                onChanged: (val) => controller.changeFilter1(val),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildDropdownFilter(
                label: config['label2'],
                value: controller.filter2Value,
                items: config['items2'],
                onChanged: (val) => controller.changeFilter2(val),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDropdownFilter({
    required String label,
    required RxString value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade500,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final bool isActive =
              value.value != "Semua" && value.value != "Semua Waktu";
          return PopupMenuButton<String>(
            onSelected: onChanged,
            offset: const Offset(0, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.accent.withOpacity(0.08)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? AppColors.accent : Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      value.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isActive ? AppColors.accent : Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: isActive ? AppColors.accent : Colors.grey,
                  ),
                ],
              ),
            ),
            itemBuilder: (context) => items
                .map(
                  (item) => PopupMenuItem(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 13)),
                  ),
                )
                .toList(),
          );
        }),
      ],
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const ShimmerPlaceholder(
                  width: 85,
                  height: 85,
                  borderRadius: 15,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerPlaceholder(
                        width: 60,
                        height: 15,
                        borderRadius: 6,
                      ),
                      const SizedBox(height: 8),
                      ShimmerPlaceholder(
                        width: context.width * 0.5,
                        height: 18,
                        borderRadius: 6,
                      ),
                      const SizedBox(height: 8),
                      ShimmerPlaceholder(
                        width: context.width * 0.3,
                        height: 14,
                        borderRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCulturesResultList() {
    return Obx(() {
      if (controller.isLoadingCultures.value) {
        return _buildShimmerList();
      }

      final list = controller.searchedCulturesList;
      if (list.isEmpty) return _buildEmptyState();

      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.DETAIL_BUDAYA, arguments: item),
              child: _customCard(
                item.title,
                item.category,
                item.image,
                item.subtitle,
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildUmkmsResultList() {
    return Obx(() {
      if (controller.isLoadingUmkms.value) {
        return _buildShimmerList();
      }

      final list = controller.searchedUmkmsList;
      if (list.isEmpty) return _buildEmptyState();

      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.UMKM_DETAIL, arguments: item),
              child: _customCard(
                item.name,
                item.category,
                item.image,
                "${item.storeName} • ${item.price}",
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildEventsResultList() {
    return Obx(() {
      if (controller.isLoadingEvents.value) {
        return _buildShimmerList();
      }

      final list = controller.searchedEventsList;
      if (list.isEmpty) return _buildEmptyState();

      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.DETAIL_EVENT, arguments: item),
              child: _customCard(
                item.name,
                item.category,
                item.imageUrl ?? "",
                item.location,
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildNewsResultList() {
    return Obx(() {
      if (controller.isLoadingNews.value) {
        return _buildShimmerList();
      }

      final list = controller.searchedNewsList;
      if (list.isEmpty) return _buildEmptyState();

      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.NEWS_DETAIL, arguments: item),
              child: _customCard(
                item.title,
                item.category,
                item.image,
                item.date,
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "Tidak ada hasil ditemukan",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _customCard(String title, String tag, String imgUrl, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              width: 85,
              height: 85,
              fit: BoxFit.cover,
              placeholder: (context, url) => const ShimmerPlaceholder(
                width: 85,
                height: 85,
                borderRadius: 15,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
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
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
