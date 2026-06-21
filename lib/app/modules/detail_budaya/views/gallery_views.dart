import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/app_colors.dart';
import '../../../utils/shimmer_placeholder.dart';
import '../../../utils/image_viewer.dart';
import '../controllers/detail_budaya_controller.dart';
import '../../explore/controllers/explore_controller.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    final detailController = Get.find<DetailBudayaController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Galeri Foto",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (Get.isRegistered<ExploreController>()) {
            await Get.find<ExploreController>().fetchCulturesData();
            final updatedSite = Get.find<ExploreController>().allData
                .firstWhere((p) => p.id == detailController.culture.id);
            detailController.culture = updatedSite;
            detailController.update();
          }
        },
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: GetBuilder<DetailBudayaController>(
          builder: (controller) {
            final List<String> gallery = controller.culture.gallery;

            if (gallery.isEmpty) {
              return const Center(
                child: Text(
                  "Belum ada foto di galeri",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              );
            }

            return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: gallery.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Get.to(
                    () => const ImageViewerView(),
                    arguments: gallery[index],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: gallery[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ShimmerPlaceholder(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 16,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
