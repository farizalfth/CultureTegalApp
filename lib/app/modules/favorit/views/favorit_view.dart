import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/favorit_controller.dart';

class FavoritView extends GetView<FavoritController> {
  const FavoritView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            "Favorit Saya",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
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
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: "Budaya"),
              Tab(text: "UMKM"),
              Tab(text: "Event"),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final cultures = controller.favoritesData['cultures'] ?? [];
          final umkms = controller.favoritesData['umkms'] ?? [];
          final events = controller.favoritesData['events'] ?? [];

          return TabBarView(
            children: [
              _buildList(cultures, 'culture'),
              _buildList(umkms, 'umkm'),
              _buildList(events, 'event'),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildList(List<dynamic> items, String type) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          "Tidak ada item favorit",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final String title =
            item['nama_tempat'] ?? item['nama_produk'] ?? item['name'] ?? '';
        final String subtitle =
            item['lokasi_singkat'] ??
            item['nama_toko'] ??
            item['schedule'] ??
            '';

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
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
            trailing: type == 'event'
                ? IconButton(
                    icon: const Icon(
                      Icons.edit_calendar_rounded,
                      color: AppColors.primary,
                    ),
                    onPressed: () => _addToGoogleCalendar(item),
                  )
                : const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            onTap: () {
              if (type == 'culture') {
                Get.toNamed(Routes.DETAIL_BUDAYA, arguments: item['id']);
              } else if (type == 'umkm') {
                Get.toNamed(Routes.UMKM_DETAIL, arguments: item['id']);
              } else if (type == 'event') {
                Get.toNamed(Routes.DETAIL_EVENT, arguments: item['id']);
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _addToGoogleCalendar(dynamic event) async {
    final String title = event['name'] ?? '';
    final String details = event['description'] ?? '';
    final String location = event['location'] ?? '';

    final Uri url = Uri.parse(
      "https://calendar.google.com/calendar/render?action=TEMPLATE&text=${Uri.encodeComponent(title)}&details=${Uri.encodeComponent(details)}&location=${Uri.encodeComponent(location)}",
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.snackbar("Gagal", "Tidak dapat membuka Google Calendar.");
    }
  }
}
