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
                    options: MapOptions(
                      initialCenter: const LatLng(-6.8694, 109.1256),
                      initialZoom: 13.5,
                      minZoom: 10,
                      maxZoom: 18,
                      onPositionChanged: (position, hasGesture) {
                        controller.updateZoom(position.zoom);
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                        subdomains: const ['a', 'b', 'c', 'd'],
                        userAgentPackageName: 'com.tegalculture.app',
                        tileDisplay: const TileDisplay.fadeIn(
                          duration: Duration(milliseconds: 200),
                        ),
                        keepBuffer: 3,
                        panBuffer: 1,
                      ),
                      MarkerLayer(
                        markers: [
                          if (controller.userLocation.value != null)
                            Marker(
                              point: controller.userLocation.value!,
                              width: 40,
                              height: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Container(
                                    height: 16,
                                    width: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade600,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ...controller.filteredMapItems.map((item) {
                            final double currentSize = controller.getMarkerSize(
                              item,
                            );
                            return Marker(
                              point: item.coordinate,
                              width: currentSize + 10,
                              height: currentSize + 10,
                              child: _buildCustomPin(item),
                            );
                          }),
                        ],
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
                _buildActionBar(context),
                const SizedBox(height: 12),
                _buildCategoryFilters(),
              ],
            ),
          ),
          Obx(() {
            if (!controller.isNearSite.value ||
                controller.nearSiteItem.value == null) {
              return const SizedBox.shrink();
            }
            final site = controller.nearSiteItem.value!;
            return Positioned(
              top: MediaQuery.of(context).padding.top + 130,
              left: 16,
              right: 16,
              child: _buildGeofenceBanner(site),
            );
          }),
          Positioned(right: 16, bottom: 240, child: _buildFloatingControls()),
          Obx(() {
            if (controller.selectedItem.value == null) {
              return const SizedBox.shrink();
            }
            return Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildWordCloudSection(),
                  const SizedBox(height: 10),
                  _buildOverviewCard(controller.selectedItem.value!),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCustomPin(MapItem item) {
    return Obx(() {
      final isSelected = controller.selectedItem.value?.id == item.id;
      final double size = controller.getMarkerSize(item);

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
          width: isSelected ? size + 10 : size,
          height: isSelected ? size + 10 : size,
          decoration: BoxDecoration(
            color: pinColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: isSelected ? 3 : 2),
            boxShadow: [
              BoxShadow(
                color: pinColor.withOpacity(0.4),
                blurRadius: isSelected ? 12 : 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            pinIcon,
            color: Colors.white,
            size: isSelected ? size * 0.55 : size * 0.45,
          ),
        ),
      );
    });
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: _buildSearchField()),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 52,
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
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: "Cari lokasi, event, atau toko...",
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Colors.grey,
            size: 22,
          ),
          suffixIcon: Obx(() {
            if (controller.searchQuery.value.isEmpty) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: const Icon(
                Icons.clear_rounded,
                color: Colors.grey,
                size: 20,
              ),
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
      height: 42,
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
                    fontSize: 13,
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

  Widget _buildFloatingControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => controller.getLiveUserLocation(),
          child: Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.my_location_rounded,
              color: Colors.blue,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeofenceBanner(MapItem site) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.room_rounded, color: Colors.green.shade700, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Kamu tiba di ${site.title}!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.green.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Klik tombol untuk klaim 10000 Poin Kunjungan.",
                  style: TextStyle(color: Colors.green.shade800, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Obx(() {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: controller.isClaimingGeofence.value
                  ? null
                  : () => controller.claimGeofencePoints(site.id),
              child: controller.isClaimingGeofence.value
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Klaim",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWordCloudSection() {
    return Obx(() {
      if (controller.isWordCloudLoading.value) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            ),
          ),
        );
      }

      if (controller.wordCloudData.isEmpty) {
        return const SizedBox.shrink();
      }

      final previewList = controller.wordCloudData.take(4).toList();

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.analytics_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Kata Kunci Terpopuler",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _showFullWordCloudPopup(),
                  child: const Text(
                    "Lihat Semua",
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: previewList.map((item) {
                final word = item['text'] as String;
                final weight = item['value'] as int;
                final double scaledFontSize =
                    10.0 + (weight / 6).clamp(0.0, 6.0);

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    word,
                    style: TextStyle(
                      fontSize: scaledFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  void _showFullWordCloudPopup() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(
              Icons.analytics_outlined,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Big Data Analisis: ${controller.selectedItem.value?.title}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ekstraksi kata kunci otomatis dari ratusan ulasan pengguna Google Maps di internet untuk menganalisis sentimen lokasi.",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.wordCloudData.map((item) {
                  final word = item['text'] as String;
                  final weight = item['value'] as int;
                  final double scaledFontSize =
                      11.0 + (weight / 5).clamp(0.0, 10.0);

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.15),
                      ),
                    ),
                    child: Text(
                      word,
                      style: TextStyle(
                        fontSize: scaledFontSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Tutup",
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
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
                    Row(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            minimumSize: const Size(60, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => controller.openInGoogleMaps(
                            item.coordinate.latitude,
                            item.coordinate.longitude,
                          ),
                          icon: const Icon(
                            Icons.navigation_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Rute",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            minimumSize: const Size(60, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _navigateToDetail(item),
                          child: const Text(
                            "Detail",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
