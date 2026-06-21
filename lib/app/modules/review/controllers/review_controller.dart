import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/culture_provider.dart';
import '../../../data/service/auth_service.dart';
import '../../detail_budaya/controllers/detail_budaya_controller.dart';
import '../../explore/controllers/explore_controller.dart';

class ReviewController extends GetxController {
  final CultureProvider _cultureProvider = Get.find<CultureProvider>();
  final ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  late CultureModel culture;
  final rating = 0.obs;
  final TextEditingController commentController = TextEditingController();

  final isSubmitting = false.obs;
  final selectedImages = <String>[].obs;

  var isLoading = false.obs;
  var isLoadMore = false.obs;
  var currentPage = 1;
  var hasNextPage = true.obs;
  final RxList<ReviewModel> reviewsList = <ReviewModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    culture = Get.arguments as CultureModel;
    scrollController.addListener(_scrollListener);
    fetchInitialReviews();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (hasNextPage.value && !isLoadMore.value && !isLoading.value) {
        loadMoreReviews();
      }
    }
  }

  Future<void> fetchInitialReviews() async {
    try {
      isLoading.value = true;
      currentPage = 1;
      hasNextPage.value = true;

      final data = await _cultureProvider.getPaginatedReviews(
        culture.id,
        page: currentPage,
        perPage: 10,
      );
      final List<dynamic> rawItems = data['items'] ?? [];
      final List<ReviewModel> items = rawItems
          .map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
          .toList();

      reviewsList.assignAll(items);
      hasNextPage.value = data['has_next'] as bool? ?? false;
    } catch (e) {
      debugPrint("Gagal memuat ulasan awal: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreReviews() async {
    try {
      isLoadMore.value = true;
      currentPage++;

      final data = await _cultureProvider.getPaginatedReviews(
        culture.id,
        page: currentPage,
        perPage: 10,
      );
      final List<dynamic> rawItems = data['items'] ?? [];
      final List<ReviewModel> items = rawItems
          .map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
          .toList();

      reviewsList.addAll(items);
      hasNextPage.value = data['has_next'] as bool? ?? false;
    } catch (e) {
      currentPage--;
      debugPrint("Gagal memuat halaman ulasan berikutnya: $e");
    } finally {
      isLoadMore.value = false;
    }
  }

  String? get currentUserId {
    if (Get.isRegistered<AuthService>()) {
      return Get.find<AuthService>().currentUserId;
    }
    return null;
  }

  bool get hasOwnReview => ownReview != null;

  ReviewModel? get ownReview {
    final String? uid = currentUserId;
    if (uid == null || reviewsList.isEmpty) return null;
    return reviewsList.firstWhereOrNull((r) => r.userId == uid);
  }

  List<ReviewModel> get otherReviews {
    final String? uid = currentUserId;
    if (uid == null) return reviewsList;
    return reviewsList.where((r) => r.userId != uid).toList();
  }

  double get averageRating {
    if (reviewsList.isEmpty) return 0.0;
    double total = 0;
    for (var review in reviewsList) {
      total += review.rating;
    }
    return total / reviewsList.length;
  }

  int countStars(int star) {
    return reviewsList.where((r) => r.rating.toInt() == star).length;
  }

  double starPercentage(int star) {
    if (reviewsList.isEmpty) return 0.0;
    return countStars(star) / reviewsList.length;
  }

  Future<void> pickImage(ImageSource source) async {
    if (selectedImages.length >= 3) {
      Get.snackbar(
        "Batas Maksimal",
        "Anda hanya dapat menambahkan maksimal 3 foto ulasan",
        backgroundColor: Colors.amber.shade800,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        selectedImages.add(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        "Galat",
        "Gagal mengambil gambar: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void removeSelectedImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  void prepareEdit() {
    final review = ownReview;
    if (review != null) {
      rating.value = review.rating.toInt();
      commentController.text = review.comment;
      selectedImages.assignAll(review.reviewImages);
    }
  }

  Future<void> submitReview() async {
    if (rating.value == 0) {
      Get.snackbar(
        "Kesalahan",
        "Silakan pilih rating terlebih dahulu",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (commentController.text.trim().isEmpty) {
      Get.snackbar(
        "Kesalahan",
        "Ulasan tidak boleh kosong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSubmitting.value = true;
      bool success;
      List<String> imagesBase64 = [];

      final activeImages = selectedImages.take(3).toList();

      for (String path in activeImages) {
        if (path.startsWith('http')) {
          imagesBase64.add(path);
        } else {
          final bytes = await File(path).readAsBytes();
          imagesBase64.add(base64Encode(bytes));
        }
      }

      if (hasOwnReview) {
        success = await _cultureProvider.putReview(
          culture.id,
          rating.value.toDouble(),
          commentController.text.trim(),
          reviewImagesBase64: imagesBase64,
        );
      } else {
        success = await _cultureProvider.postReview(
          culture.id,
          rating.value.toDouble(),
          commentController.text.trim(),
          reviewImagesBase64: imagesBase64,
        );
      }

      if (success) {
        Get.back();
        Get.snackbar(
          "Sukses",
          "Ulasan Anda berhasil disimpan",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await _syncData();
        await fetchInitialReviews();
      }
    } catch (e) {
      Get.snackbar(
        "Gagal",
        e.toString().replaceAll("Exception: ", ""),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
      rating.value = 0;
      commentController.clear();
      selectedImages.clear();
    }
  }

  Future<void> deleteOwnReview() async {
    try {
      isSubmitting.value = true;
      final bool success = await _cultureProvider.deleteReview(culture.id);

      if (success) {
        Get.snackbar(
          "Sukses",
          "Ulasan Anda berhasil dihapus",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await _syncData();
        await fetchInitialReviews();
      }
    } catch (e) {
      Get.snackbar(
        "Gagal",
        e.toString().replaceAll("Exception: ", ""),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _syncData() async {
    if (Get.isRegistered<ExploreController>()) {
      await Get.find<ExploreController>().fetchCulturesData();
      final updatedSite = Get.find<ExploreController>().allData.firstWhere(
        (p) => p.id == culture.id,
      );

      culture = updatedSite;
      update();

      if (Get.isRegistered<DetailBudayaController>()) {
        Get.find<DetailBudayaController>().culture = updatedSite;
        Get.find<DetailBudayaController>().update();
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    commentController.dispose();
    super.onClose();
  }
}
