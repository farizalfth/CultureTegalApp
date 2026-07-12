import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../controllers/riwayat_jelajah_controller.dart';

class RiwayatJelajahView extends GetView<RiwayatJelajahController> {
  const RiwayatJelajahView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            "Riwayat Jelajah",
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
              Tab(text: "Lokasi Fisik"),
              Tab(text: "Literasi Baca"),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          return TabBarView(
            children: [
              _buildList(
                controller.listGeofence,
                Icons.room_rounded,
                Colors.green,
              ),
              _buildList(
                controller.listRead,
                Icons.menu_book_rounded,
                Colors.blue,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildList(List<dynamic> items, IconData icon, Color iconColor) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          "Belum ada riwayat aktivitas",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(8),
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
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            title: Text(
              item['nama_tempat'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Text(
              item['created_at']?.toString().split('T')[0] ?? '',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Text(
              "+${item['poin_didapat']} Poin",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
          ),
        );
      },
    );
  }
}
