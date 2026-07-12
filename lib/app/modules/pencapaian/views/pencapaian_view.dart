import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/app_colors.dart';
import '../controllers/pencapaian_controller.dart';

class PencapaianView extends GetView<PencapaianController> {
  const PencapaianView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Pencapaian & Peringkat",
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
        bottom: TabBar(
          controller: controller.tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: "Lencana"),
            Tab(text: "Papan Peringkat"),
            Tab(text: "Statistik"),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.badges.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return TabBarView(
          controller: controller.tabController,
          children: [
            _buildBadgesTab(),
            _buildLeaderboardTab(),
            _buildStatsTab(),
          ],
        );
      }),
    );
  }

  Widget _buildBadgesTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: controller.badges.length,
      itemBuilder: (context, index) {
        final badge = controller.badges[index];
        final bool isUnlocked = badge['is_unlocked'] ?? false;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isUnlocked
                  ? AppColors.accent.withOpacity(0.2)
                  : Colors.grey.shade100,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  isUnlocked ? Colors.transparent : Colors.grey.shade400,
                  BlendMode.color,
                ),
                child: Image.asset(
                  "assets/images/register/register_icon.png",
                  height: 70,
                  width: 70,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                badge['nama_badge'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isUnlocked ? Colors.black87 : Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                badge['deskripsi'],
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeaderboardTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: controller.leaderboard.length,
      itemBuilder: (context, index) {
        final user = controller.leaderboard[index];
        final int rank = user['rank'] ?? (index + 1);

        Color rankColor = Colors.grey.shade700;
        if (rank == 1) rankColor = Colors.amber.shade700;
        if (rank == 2) rankColor = Colors.grey.shade400;
        if (rank == 3) rankColor = Colors.orange.shade400;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: rankColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "$rank",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: rankColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.background,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['nama'] ?? 'User Tegal',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Level ${user['level'] ?? 1}",
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
                    Icons.monetization_on_rounded,
                    color: AppColors.accent,
                    size: 18,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    "${user['total_xp']} Poin",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsTab() {
    final s = controller.stats;
    if (s.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statsCircleItem(
                  s['scanned_sites_count'].toString(),
                  "Situs Dikunjungi",
                ),
                _statsCircleItem(
                  s['correct_quizzes_count'].toString(),
                  "Kuis Benar",
                ),
                _statsCircleItem(
                  s['badges_collected_count'].toString(),
                  "Lencana",
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _statsTile(
            Icons.monetization_on,
            "Sisa Saldo Poin Budaya",
            "${s['total_points']} Poin",
            Colors.amber,
          ),
          const SizedBox(height: 12),
          _statsTile(
            Icons.bolt,
            "Total Poin Akumulatif",
            "${s['total_xp']} Poin",
            AppColors.accent,
          ),
          const SizedBox(height: 12),
          _statsTile(
            Icons.military_tech,
            "Tingkatan Level Akun",
            "Level ${s['current_level']}",
            AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _statsCircleItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _statsTile(IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
