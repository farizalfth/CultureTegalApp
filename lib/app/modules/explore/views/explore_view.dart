import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/app_colors.dart';
import '../../../data/models/culture_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/main_header.dart';
import '../controllers/explore_controller.dart';
import '../../main/controllers/controller.dart';
import '../../../utils/shimmer_placeholder.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();
    final double screenWidth = context.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () => controller.fetchCulturesData(),
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: CustomScrollView(
          controller: mainController.exploreScrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          slivers: [
            const SliverToBoxAdapter(
              child: MainHeader(
                title: "Jelajah Budaya",
                subtitle: "Temukan keindahan budaya Kota Tegal",
                hintText: "Cari tempat budaya...",
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyCategoryDelegate(
                child: Container(
                  color: AppColors.background,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                  child: _buildCategoryTabs(),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.hasError.value) {
                    return _buildErrorState();
                  }

                  if (controller.isLoading.value) {
                    return _buildBodyShimmer(context, screenWidth);
                  }

                  final sliderItems = controller.activeSliderItems;
                  final places = controller.filteredPlaces;

                  return controller.selectedCategoryIndex.value == 0
                      ? _buildSemuaLayout(context, sliderItems, places)
                      : _buildFilteredLayout(context, sliderItems, places);
                }),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyShimmer(BuildContext context, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerPlaceholder(
          width: double.infinity,
          height: 200,
          borderRadius: 28,
        ),
        const SizedBox(height: 30),
        const ShimmerPlaceholder(width: 150, height: 20, borderRadius: 6),
        const SizedBox(height: 15),
        _buildHorizontalPopularShimmer(),
        const SizedBox(height: 30),
        const ShimmerPlaceholder(width: 180, height: 20, borderRadius: 6),
        const SizedBox(height: 15),
        _buildVerticalRecommendationShimmer(width),
      ],
    );
  }

  Widget _buildHorizontalPopularShimmer() {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: 18, bottom: 5),
            child: const ShimmerPlaceholder(
              width: 180,
              height: 210,
              borderRadius: 24,
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalRecommendationShimmer(double width) {
    return Column(
      children: List.generate(2, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const ShimmerPlaceholder(
                  width: 90,
                  height: 90,
                  borderRadius: 18,
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
                        width: width * 0.45,
                        height: 18,
                        borderRadius: 6,
                      ),
                      const SizedBox(height: 8),
                      ShimmerPlaceholder(
                        width: width * 0.3,
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
      }),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "Gagal Terhubung ke Server",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.fetchCulturesData(),
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text(
                "Coba Lagi",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemuaLayout(
    BuildContext context,
    List<CultureModel> sliders,
    List<CultureModel> places,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroSlider(context, sliders),
        const SizedBox(height: 30),
        _buildSectionHeader("Kategori Populer"),
        const SizedBox(height: 15),
        _buildPopularCategories(),
        const SizedBox(height: 30),
        _buildSectionHeader(
          "Jelajah Sekitar Anda",
          action: "Lihat Peta",
          onTap: () => Get.toNamed(Routes.MAP_EXPLORE),
        ),
        const SizedBox(height: 15),
        _buildNearbyMapSection(),
        const SizedBox(height: 30),
        _buildSectionHeader("Rekomendasi Untukmu"),
        const SizedBox(height: 15),
        _buildRecommendationList(places.take(2).toList()),
        const SizedBox(height: 30),
        _buildPromoBanner(),
      ],
    );
  }

  Widget _buildFilteredLayout(
    BuildContext context,
    List<CultureModel> sliders,
    List<CultureModel> places,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sliders.isNotEmpty) ...[
          _buildHeroSlider(context, sliders),
          const SizedBox(height: 30),
        ],
        _buildSectionHeader(
          "Lokasi Terdekat",
          action: "Buka Peta",
          onTap: () => Get.toNamed(Routes.MAP_EXPLORE),
        ),
        const SizedBox(height: 15),
        _buildNearbyMapSection(),
        const SizedBox(height: 30),
        _buildSectionHeader("Daftar Jelajah"),
        const SizedBox(height: 15),
        _buildRecommendationList(places),
      ],
    );
  }

  Widget _buildHeroSlider(BuildContext context, List<CultureModel> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: controller.pageController,
            onPageChanged: (index) =>
                controller.currentSliderIndex.value = index,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final place = items[index];
              return GestureDetector(
                onTap: () =>
                    Get.toNamed(Routes.DETAIL_BUDAYA, arguments: place),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: CachedNetworkImage(
                          imageUrl: place.image,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const ShimmerPlaceholder(
                                width: double.infinity,
                                height: 200,
                                borderRadius: 28,
                              ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.85),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              place.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              place.subtitle,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => Get.toNamed(
                                Routes.DETAIL_BUDAYA,
                                arguments: place,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Jelajah Sekarang",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final int current = controller.currentSliderIndex.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              items.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: current == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: current == index
                      ? AppColors.accent
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    final categories = [
      {'icon': Icons.grid_view_rounded, 'label': 'Semua'},
      {'icon': Icons.account_balance_rounded, 'label': 'Sejarah'},
      {'icon': Icons.theater_comedy_rounded, 'label': 'Tradisi'},
      {'icon': Icons.restaurant_rounded, 'label': 'Kuliner'},
      {'icon': Icons.terrain_rounded, 'label': 'Wisata'},
    ];

    return Obx(() {
      final int selected = controller.selectedCategoryIndex.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(categories.length, (index) {
          final bool isActive = selected == index;
          return GestureDetector(
            onTap: () => controller.changeCategory(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.accent : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      if (isActive)
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Icon(
                    categories[index]['icon'] as IconData,
                    color: isActive
                        ? Colors.white
                        : AppColors.primary.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  categories[index]['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? AppColors.accent : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }),
      );
    });
  }

  Widget _buildPopularCategories() {
    final historyPlaces = controller.allData
        .where((p) => p.category == "Sejarah")
        .toList();
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: historyPlaces.length,
        itemBuilder: (context, index) {
          final place = historyPlaces[index];
          return GestureDetector(
            onTap: () => Get.toNamed(Routes.DETAIL_BUDAYA, arguments: place),
            child: _popularCard(place.title, place.category, place.image),
          );
        },
      ),
    );
  }

  Widget _popularCard(String title, String tag, String img) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 18, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: CachedNetworkImage(
                  imageUrl: img,
                  height: 110,
                  width: 180,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ShimmerPlaceholder(
                    width: 180,
                    height: 110,
                    borderRadius: 24,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  "Jelajahi keunikannya",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyMapSection() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.MAP_EXPLORE),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  Icons.map_outlined,
                  size: 50,
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.accent, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Lihat lokasi budaya di sekitar anda",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationList(List<CultureModel> places) {
    return Column(
      children: places
          .map(
            (place) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: GestureDetector(
                onTap: () =>
                    Get.toNamed(Routes.DETAIL_BUDAYA, arguments: place),
                child: _recommendationCard(
                  place.title,
                  place.description,
                  place.category,
                  place.image,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _recommendationCard(
    String title,
    String desc,
    String cat,
    String imgUrl,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              placeholder: (context, url) => const ShimmerPlaceholder(
                width: 90,
                height: 90,
                borderRadius: 18,
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
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    cat,
                    style: const TextStyle(
                      color: AppColors.accent,
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
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.bookmark_outline, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFDF2E9),
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/jelajah/cover_info_badge.png'),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ayo Jelajah & Kumpulkan Lencana!",
              style: TextStyle(
                color: Color(0xFF7B3F00),
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Jelajahi lebih banyak tempat budaya\ndan dapatkan lencanamu.",
              style: TextStyle(
                color: Color(0xFF7B3F00),
                fontSize: 11,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Lihat Lencana",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    String action = "Lihat Semua",
    VoidCallback? onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: onTap ?? () {},
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: AppColors.accent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            action,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _StickyCategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyCategoryDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 110.0;

  @override
  double get minExtent => 110.0;

  @override
  bool shouldRebuild(covariant _StickyCategoryDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
