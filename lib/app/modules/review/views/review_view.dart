import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/app_colors.dart';
import '../../../utils/image_viewer.dart';
import '../../../utils/shimmer_placeholder.dart';
import '../controllers/review_controller.dart';

class ReviewView extends GetView<ReviewController> {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        title: Column(
          children: [
            const Text(
              "Ulasan Pengunjung",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              controller.culture.title,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: GetBuilder<ReviewController>(
        builder: (_) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRatingSummary(),
                const SizedBox(height: 30),
                if (controller.hasOwnReview) ...[
                  const Text(
                    "Ulasan Anda",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _buildOwnReviewCard(context),
                  const SizedBox(height: 30),
                ],
                const Text(
                  "Ulasan Pengunjung Lain",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildReviewList(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: GetBuilder<ReviewController>(
        builder: (_) {
          return FloatingActionButton.extended(
            onPressed: () {
              if (controller.hasOwnReview) {
                controller.prepareEdit();
              }
              _showWriteReviewSheet(context);
            },
            backgroundColor: AppColors.primary,
            icon: Icon(
              controller.hasOwnReview
                  ? Icons.edit_rounded
                  : Icons.edit_note_rounded,
              color: Colors.white,
            ),
            label: Text(
              controller.hasOwnReview ? "Edit Ulasan" : "Tulis Ulasan",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Row(
      children: [
        Column(
          children: [
            Text(
              controller.averageRating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star_rounded,
                  color: index < controller.averageRating.toInt()
                      ? Colors.amber
                      : Colors.grey.shade300,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${controller.culture.reviews.length} Ulasan",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(width: 30),
        Expanded(
          child: Column(
            children: [
              _starBar(5, controller.starPercentage(5)),
              _starBar(4, controller.starPercentage(4)),
              _starBar(3, controller.starPercentage(3)),
              _starBar(2, controller.starPercentage(2)),
              _starBar(1, controller.starPercentage(1)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _starBar(int star, double percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            "$star",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade100,
              color: AppColors.accent,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnReviewCard(BuildContext context) {
    final review = controller.ownReview;
    if (review == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(review.userAvatar),
                radius: 18,
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
                  (i) => Icon(
                    Icons.star_rounded,
                    color: i < review.rating.toInt()
                        ? Colors.amber
                        : Colors.grey.shade200,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          if (review.reviewImages.isNotEmpty) ...[
            const SizedBox(height: 12),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  controller.prepareEdit();
                  _showWriteReviewSheet(context);
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: AppColors.accent,
                ),
                label: const Text(
                  "Edit",
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _showDeleteConfirmationDialog(),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 16,
                  color: Colors.red,
                ),
                label: const Text(
                  "Hapus",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewList() {
    final list = controller.otherReviews;
    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Text(
            "Belum ada ulasan dari pengunjung lain",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final review = list[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      review.userAvatar,
                    ),
                    radius: 18,
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
                      (i) => Icon(
                        Icons.star_rounded,
                        color: i < review.rating.toInt()
                            ? Colors.amber
                            : Colors.grey.shade200,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                review.comment,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                  height: 1.5,
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
              const SizedBox(height: 15),
              Divider(color: Colors.grey.shade100),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Hapus Ulasan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Apakah Anda yakin ingin menghapus ulasan Anda secara permanen?",
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
              controller.deleteOwnReview();
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

  void _showWriteReviewSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          25,
          25,
          25,
          MediaQuery.of(context).viewInsets.bottom + 25,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.hasOwnReview ? "Perbarui Ulasan" : "Berikan Ulasan",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => GestureDetector(
                      onTap: () => controller.rating.value = index + 1,
                      child: Icon(
                        index < controller.rating.value
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: index < controller.rating.value
                            ? Colors.amber
                            : Colors.grey.shade400,
                        size: 40,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Ceritakan pengalamanmu di sini...",
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Obx(() {
              final int length = controller.selectedImages.length;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  children: [
                    if (length < 3) ...[
                      GestureDetector(
                        onTap: () => _showImageSourcePicker(context),
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.grey,
                                size: 28,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Tambah Foto",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                    ...List.generate(length, (index) {
                      final String path = controller.selectedImages[index];
                      final bool isLocal = !path.startsWith('http');

                      return Container(
                        margin: const EdgeInsets.only(right: 15),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: SizedBox(
                                height: 80,
                                width: 80,
                                child: isLocal
                                    ? Image.file(File(path), fit: BoxFit.cover)
                                    : CachedNetworkImage(
                                        imageUrl: path,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const ShimmerPlaceholder(
                                              width: 80,
                                              height: 80,
                                              borderRadius: 15,
                                            ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                              ),
                            ),
                            Positioned(
                              top: -8,
                              right: -8,
                              child: GestureDetector(
                                onTap: () =>
                                    controller.removeSelectedImage(index),
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.red,
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
            const SizedBox(height: 25),
            Obx(() {
              final bool isLoading = controller.isSubmitting.value;
              return ElevatedButton(
                onPressed: isLoading ? null : () => controller.submitReview(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        controller.hasOwnReview
                            ? "Perbarui Ulasan"
                            : "Kirim Ulasan",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showImageSourcePicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Sumber Foto",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      controller.pickImage(ImageSource.camera);
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Kamera",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      controller.pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(
                      Icons.photo_library_outlined,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Galeri",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
