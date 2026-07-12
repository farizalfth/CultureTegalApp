import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/main_header.dart';
import '../../../utils/shimmer_placeholder.dart';
import '../../main/controllers/controller.dart';
import '../controllers/home_controller.dart';
import '../../../data/models/news_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = context.width;
    final double screenHeight = context.height;
    final mainController = Get.find<MainController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () => controller.loadAllData(),
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: CustomScrollView(
          controller: mainController.homeScrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(child: _buildHeaderSection()),
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyMenuDelegate(
                child: Container(
                  color: AppColors.background,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  child: _buildQuickActionMenu(),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return _buildBodyShimmer(
                      context,
                      screenWidth,
                      screenHeight,
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      _buildBannerSlider(),
                      const SizedBox(height: 35),
                      _buildMainFeaturesGrid(),
                      const SizedBox(height: 30),
                      _buildSectionHeader(
                        "Berita Tegal",
                        () => Get.toNamed(Routes.NEWS_LIST),
                      ),
                      const SizedBox(height: 15),
                      _buildNewsList(screenWidth),
                    ],
                  );
                }),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyShimmer(BuildContext context, double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const ShimmerPlaceholder(
          width: double.infinity,
          height: 150,
          borderRadius: 24,
        ),
        const SizedBox(height: 35),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.45,
          children: List.generate(4, (index) {
            return const ShimmerPlaceholder(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 24,
            );
          }),
        ),
        const SizedBox(height: 30),
        const ShimmerPlaceholder(width: 120, height: 20, borderRadius: 6),
        const SizedBox(height: 15),
        _buildNewsListShimmer(width),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      color: Colors.white,
      child: const MainHeader(
        title: "Tegal Culture",
        subtitle: "",
        hintText: "Cari budaya Tegal...",
      ),
    );
  }

  Widget _buildQuickActionMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _quickActionItem(
          "Smart\nCulture",
          Icons.auto_awesome_rounded,
          () => Get.toNamed(Routes.AI_SCAN),
        ),
        _quickActionItem(
          "Jelajah\nBudaya",
          Icons.explore_rounded,
          () => Get.find<MainController>().changePage(1),
        ),
        _quickActionItem(
          "Peta\nBudaya",
          Icons.map_rounded,
          () => Get.toNamed(Routes.MAP_EXPLORE),
        ),
        _quickActionItem(
          "Kuis\nBudaya",
          Icons.quiz_rounded,
          () => Get.toNamed(Routes.KUIS_BUDAYA),
        ),
      ],
    );
  }

  Widget _quickActionItem(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSlider() {
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
              onPressed: () => Get.toNamed(Routes.PENCAPAIAN),
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

  Widget _buildMainFeaturesGrid() {
    final mainController = Get.find<MainController>();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.45,
      children: [
        _featureCard(
          "Analitik Data",
          Icons.bar_chart_rounded,
          AppColors.cardBlue,
          () => Get.toNamed(Routes.ANALITIK),
        ),
        _featureCard(
          "Event Tegal",
          Icons.event_note_rounded,
          AppColors.cardOrange,
          () => mainController.changePage(3),
        ),
        _featureCard(
          "Kebudayaan",
          Icons.account_balance_rounded,
          AppColors.cardRed,
          () => mainController.changePage(1),
        ),
        _featureCard(
          "UMKM Lokal",
          Icons.storefront_rounded,
          AppColors.cardBrown,
          () => mainController.changePage(2),
        ),
      ],
    );
  }

  Widget _featureCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    icon,
                    color: Colors.white.withOpacity(0.3),
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            letterSpacing: 0.2,
          ),
        ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              "Lihat Semua",
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsListShimmer(double width) {
    return Column(
      children: List.generate(2, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const ShimmerPlaceholder(
                  width: 90,
                  height: 90,
                  borderRadius: 16,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerPlaceholder(
                        width: 60,
                        height: 20,
                        borderRadius: 8,
                      ),
                      const SizedBox(height: 10),
                      ShimmerPlaceholder(
                        width: width * 0.5,
                        height: 16,
                        borderRadius: 4,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerPlaceholder(
                            width: width * 0.25,
                            height: 12,
                            borderRadius: 4,
                          ),
                          const ShimmerPlaceholder(
                            width: 14,
                            height: 14,
                            borderRadius: 4,
                          ),
                        ],
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

  Widget _buildNewsList(double width) {
    if (controller.newsList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "Belum ada berita terbaru",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ),
      );
    }

    return Column(
      children: controller.newsList
          .map(
            (news) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => Get.toNamed(Routes.NEWS_DETAIL, arguments: news),
                child: _newsCard(news),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _newsCard(NewsModel news) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(Routes.NEWS_DETAIL, arguments: news),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: news.image,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const ShimmerPlaceholder(
                      width: 90,
                      height: 90,
                      borderRadius: 16,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 16),
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
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          news.category,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        news.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 12,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                news.date,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StickyMenuDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyMenuDelegate({required this.child});

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
  bool shouldRebuild(covariant _StickyMenuDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
