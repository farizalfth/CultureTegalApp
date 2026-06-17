import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/icon_mapping.dart';
import '../../../utils/image_viewer.dart';
import '../controllers/detail_budaya_controller.dart';
import '../../../data/models/review_model.dart';
import '../../../utils/shimmer_placeholder.dart';
import 'gallery_views.dart';

class DetailBudayaView extends GetView<DetailBudayaController> {
  const DetailBudayaView({super.key});

  @override
  Widget build(BuildContext context) {
    final culture = controller.culture;
    final List<String> displayGallery = culture.gallery.isEmpty
        ? [culture.image]
        : culture.gallery;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 350,
                        width: double.infinity,
                        child: PageView.builder(
                          controller: controller.pageController,
                          onPageChanged: (index) =>
                              controller.currentIndex.value = index,
                          itemCount: displayGallery.length > 5
                              ? 5
                              : displayGallery.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => Get.to(
                                () => const ImageViewerView(),
                                arguments: displayGallery[index],
                              ),
                              child: CachedNetworkImage(
                                imageUrl: displayGallery[index],
                                width: double.infinity,
                                height: 350,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const ShimmerPlaceholder(
                                      width: double.infinity,
                                      height: 350,
                                    ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.white.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: const Offset(0, -25),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  culture.title,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  culture.category,
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.home_work_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                culture.subtitle,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildInfoBar(),
                          const SizedBox(height: 24),
                          _buildDescriptionSection(),
                          const SizedBox(height: 24),
                          if (culture.gallery.isNotEmpty) ...[
                            _buildGallerySection(),
                            const SizedBox(height: 24),
                          ],
                          _buildFunFactSection(),
                          const SizedBox(height: 24),
                          if (culture.facilities.isNotEmpty) ...[
                            _buildFacilitiesSection(),
                            const SizedBox(height: 24),
                          ],
                          _buildReviewsSection(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildTopBar(context),
          _buildBottomActionButtons(),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.grey.shade800,
                size: 18,
              ),
            ),
          ),
          Row(
            children: [
              Obx(
                () => GestureDetector(
                  onTap: () => controller.toggleFavorite(),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      controller.isFavorite.value
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      color: controller.isFavorite.value
                          ? Colors.red
                          : Colors.grey.shade800,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.share_outlined,
                  color: Colors.grey.shade800,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBar() {
    final culture = controller.culture;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _infoItem(
            Icons.calendar_month_rounded,
            "Dibangun",
            culture.builtYear,
          ),
          _verticalDivider(),
          _infoItem(Icons.location_on_rounded, "Lokasi", culture.subLocation),
          _verticalDivider(),
          _infoItem(Icons.explore_rounded, "Jarak", culture.distance),
          _verticalDivider(),
          _infoItem(
            Icons.access_time_filled_rounded,
            "Durasi",
            culture.duration,
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.shade200);
  }

  Widget _buildDescriptionSection() {
    final description = controller.culture.description;
    final bool canExpand = description.length > 150;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            description,
            maxLines: controller.isExpanded.value ? null : 3,
            overflow: controller.isExpanded.value
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ),
        if (canExpand) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => controller.toggleExpand(),
            child: Obx(
              () => Row(
                children: [
                  Text(
                    controller.isExpanded.value
                        ? "Sembunyikan"
                        : "Selengkapnya",
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Icon(
                    controller.isExpanded.value
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.accent,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGallerySection() {
    final gallery = controller.culture.gallery;
    final limitedGallery = gallery.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Galeri",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            GestureDetector(
              onTap: () =>
                  Get.to(() => const GalleryView(), arguments: gallery),
              child: Text(
                "Lihat Semua",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: limitedGallery.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Get.to(
                  () => const ImageViewerView(),
                  arguments: limitedGallery[index],
                ),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: limitedGallery[index],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ShimmerPlaceholder(
                        width: 80,
                        height: 80,
                        borderRadius: 12,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFunFactSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF2E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.accent,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tahukah Kamu?",
                  style: TextStyle(
                    color: Color(0xFF7B3F00),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  controller.culture.funFact,
                  style: const TextStyle(
                    color: Color(0xFF7B3F00),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesSection() {
    final facilities = controller.culture.facilities;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Fasilitas",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: facilities.map((fac) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    IconMapping.getIcon(fac.icon),
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    fac.name,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    final list = controller.culture.reviews;
    if (list.isEmpty) return const SizedBox.shrink();

    final limitedReviews = list.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Ulasan Pengunjung",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            GestureDetector(
              onTap: () =>
                  Get.toNamed(Routes.REVIEWS, arguments: controller.culture),
              child: const Text(
                "Lihat Semua",
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...limitedReviews.map((review) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        review.userAvatar,
                      ),
                      radius: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            review.date,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star_rounded,
                          color: index < review.rating.toInt()
                              ? Colors.amber
                              : Colors.grey.shade200,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  review.comment,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                if (review.reviewImages.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: review.reviewImages.length,
                      itemBuilder: (context, idx) {
                        return GestureDetector(
                          onTap: () => Get.to(
                            () => const ImageViewerView(),
                            arguments: review.reviewImages[idx],
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: review.reviewImages[idx],
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const ShimmerPlaceholder(
                                      width: 80,
                                      height: 80,
                                      borderRadius: 10,
                                    ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBottomActionButtons() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.navigation_outlined,
                color: AppColors.accent,
              ),
              label: const Text(
                "Rute",
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                side: const BorderSide(color: AppColors.accent, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.explore_outlined, color: Colors.white),
              label: const Text(
                "Jelajahi Sekarang",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                minimumSize: const Size(double.infinity, 55),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
