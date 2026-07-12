import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/scan_history_controller.dart';
import '../../../utils/shimmer_placeholder.dart';

class ScanHistoryView extends GetView<ScanHistoryController> {
  const ScanHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Riwayat AI Kuliner",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (controller.listScans.isEmpty) {
          return const Center(
            child: Text(
              "Belum ada riwayat pemindaian makanan",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.listScans.length,
          itemBuilder: (context, index) {
            final item = controller.listScans[index];
            final details = item['food_details'];
            final String name = details != null
                ? details['nama_makanan']
                : item['predicted_label'];
            final String date = item['created_at'] != null
                ? item['created_at'].toString().split('T')[0]
                : '';
            final String? img = item['image_url'];
            final String scanId = item['id'].toString();

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _showScanDetails(context, item),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: img != null
                              ? CachedNetworkImage(
                                  imageUrl:
                                      "http://${controller.baseUrl.replaceAll('http://', '').replaceAll('/api/v1', '')}$img",
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const ShimmerPlaceholder(
                                        width: 60,
                                        height: 60,
                                        borderRadius: 12,
                                      ),
                                  errorWidget: (context, url, error) =>
                                      _buildFallbackIcon(),
                                )
                              : _buildFallbackIcon(),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Dipindai pada: $date",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                          ),
                          onPressed: () =>
                              _showDeleteConfirmation(scanId, name),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.fastfood_rounded, color: AppColors.accent),
    );
  }

  void _showDeleteConfirmation(String scanId, String name) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Hapus Riwayat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Yakin ingin menghapus riwayat pindaian $name? Foto pindaian Anda juga akan dihapus dari server.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Batal",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteHistory(scanId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Hapus",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showScanDetails(BuildContext context, dynamic item) {
    final details = item['food_details'];
    final String name = details != null
        ? details['nama_makanan']
        : item['predicted_label'];
    final String desc = details != null
        ? details['deskripsi']
        : 'Deskripsi tidak tersedia.';
    final String? videoUrl = details != null ? details['video_url'] : null;
    final String? img = item['image_url'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(context).padding.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (img != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl:
                          "http://${controller.baseUrl.replaceAll('http://', '').replaceAll('/api/v1', '')}$img",
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ShimmerPlaceholder(
                        width: double.infinity,
                        height: 180,
                        borderRadius: 16,
                      ),
                      errorWidget: (context, url, error) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                desc,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              if (videoUrl != null) ...[
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    controller.launchVideo(videoUrl);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Putar Video Resep (In-App)",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  Get.toNamed(Routes.KUIS_BUDAYA);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.quiz_rounded, color: Colors.white),
                label: const Text(
                  "Buka Kuis Pengetahuan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
