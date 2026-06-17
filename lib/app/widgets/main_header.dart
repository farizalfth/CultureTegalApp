import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/app_colors.dart';
import '../data/service/user_service.dart';
import '../modules/main/controllers/controller.dart';
import '../routes/app_pages.dart';

class MainHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String hintText;

  const MainHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.hintText = "Cari sesuatu...",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        context.mediaQueryPadding.top + 20,
        20,
        30,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
        image: DecorationImage(
          image: AssetImage('assets/images/beranda/cover_atas.png'),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Menggunakan Obx hanya pada bagian nama agar reaktif
                    Obx(() {
                      final user = UserService.to.user.value;
                      final displayName =
                          user?.name ??
                          "Nadhif Basalamah"; // Fallback jika null
                      return Text(
                        "Halo, $displayName!",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildActionIcon(Icons.notifications_none_rounded),
                  const SizedBox(width: 12),
                  Obx(() {
                    final user = UserService.to.user.value;
                    final hasPhoto =
                        user?.profilePicture != null &&
                        user!.profilePicture!.isNotEmpty;

                    return GestureDetector(
                      onTap: () {
                        Get.find<MainController>().changePage(4);
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white24,
                        backgroundImage: hasPhoto
                            ? NetworkImage(user.profilePicture!)
                            : null,
                        child: !hasPhoto
                            ? const Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () => Get.toNamed(Routes.SEARCH),
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            color: Colors.grey,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            hintText,
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Obx(() {
                final user = UserService.to.user.value;
                final userPoints = user?.points ?? "0";
                return _buildQuizPointsCard(userPoints);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Widget _buildQuizPointsCard(String points) {
    return GestureDetector(
      onTap: () => Get.toNamed('/kuis-budaya'),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Poin Kuis",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.monetization_on,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  points,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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
