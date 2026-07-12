import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../controllers/umkm_detail_controller.dart';
import '../../../routes/app_pages.dart';

class UmkmDetailView extends GetView<UmkmDetailController> {
  const UmkmDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;
    final double safeBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: context.height * 0.42,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(product.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 80,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.white, Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              product.category,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 22,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.rating.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.price,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      const Text(
                        "Deskripsi Produk",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description ??
                            "Tidak ada deskripsi untuk produk ini.",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.storefront_rounded,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.storeName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product.storeAddress ??
                                        "Alamat toko tidak dicantumkan.",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (product.latitude != null &&
                                product.longitude != null)
                              GestureDetector(
                                onTap: () => controller.launchMaps(),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.directions_outlined,
                                    color: Colors.blue.shade700,
                                    size: 24,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildWordCloudSection(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Ulasan Pengunjung",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed(
                              '/reviews',
                              arguments: {
                                'type': 'umkm',
                                'id': product.id,
                                'title': product.name,
                              },
                            )?.then((_) => controller.fetchReviewsLimit()),
                            child: const Text(
                              "Lihat Semua",
                              style: TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        if (controller.isLoadingReviews.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }
                        if (controller.reviews.isEmpty) {
                          return Text(
                            "Belum ada ulasan untuk produk ini.",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                            ),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.reviews.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 24),
                          itemBuilder: (context, index) {
                            final rev = controller.reviews[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.grey.shade100,
                                      backgroundImage: NetworkImage(
                                        rev.userAvatar,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rev.userName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            rev.date,
                                            style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          rev.rating.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  rev.comment,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                                if (rev.reviewImages.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: SizedBox(
                                      height: 60,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: rev.reviewImages.length,
                                        itemBuilder: (context, imgIdx) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            width: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.grey.shade200,
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  rev.reviewImages[imgIdx],
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        );
                      }),
                      SizedBox(height: 120 + safeBottom),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: context.mediaQueryPadding.top + 10,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.9),
              radius: 24,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87,
                  size: 18,
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ),
          Positioned(
            bottom: safeBottom > 0 ? safeBottom + 10 : 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                if (product.latitude != null && product.longitude != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.blue.shade50,
                      child: IconButton(
                        icon: const Icon(
                          Icons.map_outlined,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Get.toNamed(
                            Routes.MAP_EXPLORE,
                            arguments: {'targetId': product.id},
                          );
                        },
                      ),
                    ),
                  ),
                if (product.externalLink != null &&
                    product.externalLink!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.orange.shade50,
                      child: IconButton(
                        icon: const Icon(
                          Icons.language_outlined,
                          color: Colors.orange,
                        ),
                        onPressed: () => controller.launchWebLink(),
                      ),
                    ),
                  ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.launchWhatsApp(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(double.infinity, 52),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Hubungi Toko",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCloudSection() {
    return Obx(() {
      if (controller.isWordCloudLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      }

      if (controller.wordCloudData.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.cloud_queue_rounded, color: AppColors.accent),
              SizedBox(width: 8),
              Text(
                "Kata Kunci Pembeli",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Hasil analisis sentimen Big Data eksternal",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Wrap(
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    word,
                    style: TextStyle(
                      fontSize: scaledFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 32),
        ],
      );
    });
  }
}
