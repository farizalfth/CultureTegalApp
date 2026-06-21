import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/news_model.dart';
import '../../../data/providers/news_provider.dart';

class NewsListController extends GetxController {
  final NewsProvider _newsProvider = Get.find<NewsProvider>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  var selectedCategoryIndex = 0.obs;
  var searchQuery = "".obs;
  var isLoading = false.obs;
  var isLoadMore = false.obs;

  var currentPage = 1;
  var hasNextPage = true.obs;
  final RxList<NewsModel> newsList = <NewsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      selectedCategoryIndex.value = Get.arguments as int;
    }
    scrollController.addListener(_scrollListener);
    fetchInitialNews();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (hasNextPage.value && !isLoadMore.value && !isLoading.value) {
        loadMoreNews();
      }
    }
  }

  Future<void> fetchInitialNews() async {
    try {
      isLoading.value = true;
      currentPage = 1;
      hasNextPage.value = true;

      String cat = [
        "Semua",
        "Budaya",
        "UMKM",
        "Edukasi",
      ][selectedCategoryIndex.value];
      final data = await _newsProvider.getNews(
        category: cat,
        page: currentPage,
        perPage: 10,
      );

      final List<dynamic> rawItems = data['items'] ?? [];
      final List<NewsModel> items = rawItems
          .map((item) => NewsModel.fromJson(item as Map<String, dynamic>))
          .toList();

      newsList.assignAll(items);
      hasNextPage.value = data['has_next'] as bool? ?? false;
    } catch (e) {
      debugPrint("Gagal memuat berita awal: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreNews() async {
    try {
      isLoadMore.value = true;
      currentPage++;

      String cat = [
        "Semua",
        "Budaya",
        "UMKM",
        "Edukasi",
      ][selectedCategoryIndex.value];
      final data = await _newsProvider.getNews(
        category: cat,
        page: currentPage,
        perPage: 10,
      );

      final List<dynamic> rawItems = data['items'] ?? [];
      final List<NewsModel> items = rawItems
          .map((item) => NewsModel.fromJson(item as Map<String, dynamic>))
          .toList();

      newsList.addAll(items);
      hasNextPage.value = data['has_next'] as bool? ?? false;
    } catch (e) {
      currentPage--;
      debugPrint("Gagal memuat halaman berita berikutnya: $e");
    } finally {
      isLoadMore.value = false;
    }
  }

  void setCategory(int index) {
    selectedCategoryIndex.value = index;
    fetchInitialNews();
  }

  List<NewsModel> get filteredNews {
    if (searchQuery.value.isEmpty) return newsList;
    return newsList
        .where(
          (n) =>
              n.title.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
