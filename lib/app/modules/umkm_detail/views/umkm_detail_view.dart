import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../controllers/umkm_detail_controller.dart';

class UmkmDetailView extends GetView<UmkmDetailController> {
  const UmkmDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: context.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(product.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
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
                              borderRadius: BorderRadius.circular(30),
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
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.rating.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.price,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Deskripsi Produk",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description ??
                            "Tidak ada deskripsi untuk produk ini.",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.storefront_rounded,
                              color: AppColors.primary,
                              size: 28,
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
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    product.storeAddress ??
                                        "Alamat toko tidak dicantumkan.",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (product.latitude != null &&
                                product.longitude != null)
                              IconButton(
                                icon: const Icon(
                                  Icons.directions_outlined,
                                  color: Colors.blue,
                                  size: 28,
                                ),
                                onPressed: () => controller.launchMaps(),
                                tooltip: "Petunjuk Arah",
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Ulasan Pengunjung",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                      const SizedBox(height: 120),
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
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Get.back(),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
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
                        onPressed: () => controller.launchMaps(),
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
}
