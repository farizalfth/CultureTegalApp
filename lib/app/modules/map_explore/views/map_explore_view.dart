import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/app_colors.dart';
import '../../../data/models/map_item_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/map_explore_controller.dart';

class MapExploreView extends GetView<MapExploreController> {
  const MapExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : FlutterMap(
                    mapController: controller.mapController,
                    options: const MapOptions(
                      initialCenter: LatLng(-6.8694, 109.1256),
                      initialZoom: 13.5,
                      minZoom: 10,
                      maxZoom: 18,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                        subdomains: const ['a', 'b', 'c', 'd'],
                        userAgentPackageName: 'com.tegalculture.app',
                      ),
                      MarkerLayer(
                        markers: controller.filteredMapItems.map((item) {
                          return Marker(
                            point: item.coordinate,
                            width: 60,
                            height: 60,
                            child: _buildCustomPin(item),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                _buildSearchField(),
                const SizedBox(height: 12),
                _buildCategoryFilters(),
              ],
            ),
          ),
          Obx(() {
            if (controller.selectedItem.value == null) {
              return const SizedBox.shrink();
            }
            return Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: _buildOverviewCard(controller.selectedItem.value!),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCustomPin(MapItem item) {
    return Obx(() {
      final isSelected = controller.selectedItem.value?.id == item.id;

      Color pinColor;
      IconData pinIcon;

      switch (item.type) {
        case MapItemType.culture:
          pinColor = AppColors.primary;
          pinIcon = Icons.account_balance_rounded;
          break;
        case MapItemType.event:
          pinColor = Colors.orange.shade800;
          pinIcon = Icons.theater_comedy_rounded;
          break;
        case MapItemType.umkm:
          pinColor = Colors.green.shade600;
          pinIcon = Icons.storefront_rounded;
          break;
      }

      return GestureDetector(
        onTap: () => controller.selectItem(item),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: isSelected ? 50 : 40,
          height: isSelected ? 50 : 40,
          decoration: BoxDecoration(
            color: pinColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: pinColor.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(pinIcon, color: Colors.white, size: isSelected ? 24 : 18),
        ),
      );
    });
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: "Cari lokasi, event, atau toko...",
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
          suffixIcon: Obx(() {
            if (controller.searchQuery.value.isEmpty)
              return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.clear_rounded, color: Colors.grey),
              onPressed: () {
                controller.searchController.clear();
                controller.onSearchChanged("");
              },
            );
          }),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final List<String> categories = ["Semua", "Budaya", "Event", "UMKM"];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Obx(() {
            final isSelected = controller.activeFilter.value == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.accent,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.grey.shade200,
                  ),
                ),
                onSelected: (selected) {
                  if (selected) {
                    controller.changeFilter(cat);
                  }
                },
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildOverviewCard(MapItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 90,
                height: 90,
                color: Colors.grey.shade100,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 90,
                height: 90,
                color: Colors.grey.shade100,
                child: const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(item.type).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getCategoryLabel(item.type),
                        style: TextStyle(
                          color: _getCategoryColor(item.type),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (item.type == MapItemType.umkm)
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            item.rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.infoTag,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _navigateToDetail(item),
                      child: const Text(
                        "Detail",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
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

  Color _getCategoryColor(MapItemType type) {
    switch (type) {
      case MapItemType.culture:
        return AppColors.primary;
      case MapItemType.event:
        return Colors.orange.shade800;
      case MapItemType.umkm:
        return Colors.green.shade600;
    }
  }

  String _getCategoryLabel(MapItemType type) {
    switch (type) {
      case MapItemType.culture:
        return "Budaya";
      case MapItemType.event:
        return "Event";
      case MapItemType.umkm:
        return "UMKM";
    }
  }

  void _navigateToDetail(MapItem item) {
    switch (item.type) {
      case MapItemType.culture:
        Get.toNamed(Routes.DETAIL_BUDAYA, arguments: item.originalModel);
        break;
      case MapItemType.event:
        Get.toNamed(Routes.DETAIL_EVENT, arguments: item.originalModel);
        break;
      case MapItemType.umkm:
        Get.toNamed(Routes.UMKM_DETAIL, arguments: item.originalModel);
        break;
    }
  }
}
