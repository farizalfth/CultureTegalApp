import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () => controller.loadAllProfileData(),
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context, controller)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildLevelPointsCard(controller),
                    const SizedBox(height: 20),
                    _buildStatsRow(controller),
                    const SizedBox(height: 30),
                    _buildSectionTitle("Menu Utama"),
                    _buildMenuItem(
                      Icons.person_outline_rounded,
                      "Edit Profil",
                      "Ubah informasi akun kamu",
                      onTap: () {
                        Get.toNamed(Routes.EDIT_PROFILE)?.then((_) {
                          controller.loadAllProfileData();
                        });
                      },
                    ),
                    _buildMenuItem(
                      Icons.location_on_outlined,
                      "Riwayat Jelajah",
                      "Lihat tempat budaya yang pernah dikunjungi",
                      onTap: () => Get.toNamed(Routes.RIWAYAT_JELAJAH),
                    ),
                    _buildMenuItem(
                      Icons.qr_code_scanner_rounded,
                      "Riwayat AI Kuliner",
                      "Lihat hasil scan makanan yang telah kamu lakukan",
                      onTap: () => Get.toNamed(Routes.SCAN_HISTORY),
                    ),
                    _buildMenuItem(
                      Icons.favorite_outline_rounded,
                      "Favorit",
                      "Lihat budaya, tempat dan produk favoritmu",
                      onTap: () => Get.toNamed(Routes.FAVORIT),
                    ),
                    const SizedBox(height: 25),
                    _buildSectionTitle("Pengaturan"),
                    Obx(
                      () => _buildMenuItem(
                        Icons.notifications_active_outlined,
                        "Notifikasi",
                        "Aktifkan pemberitahuan sistem",
                        isSwitch: true,
                        switchValue: controller.isNotificationEnabled.value,
                        onSwitchChanged: (val) =>
                            controller.toggleNotification(val),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.security_outlined,
                      "Privasi & Keamanan",
                      "Kelola privasi dan keamanan akun",
                      onTap: () => controller.launchWebUrl(
                        controller.getBaseWebUrl('/privacy-policy'),
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildSectionTitle("Bantuan & Informasi"),
                    _buildMenuItem(
                      Icons.info_outline_rounded,
                      "Tentang Aplikasi",
                      "Informasi tentang Tegal Culture",
                      onTap: () => controller.launchWebUrl(
                        controller.getBaseWebUrl('/tentang'),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.help_outline_rounded,
                      "Bantuan",
                      "Pusat bantuan dan FAQ",
                      onTap: () => controller.launchWebUrl(
                        controller.getBaseWebUrl('/help'),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.description_outlined,
                      "Syarat & Ketentuan",
                      "Baca syarat dan ketentuan penggunaan",
                      onTap: () => controller.launchWebUrl(
                        controller.getBaseWebUrl('/terms-of-service'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildMenuItem(
                      Icons.person_remove_rounded,
                      "Hapus Akun",
                      "Hapus akun dan semua data permanen",
                      isLogout: true,
                      onTap: () => controller.promptDeleteAccount(),
                    ),
                    _buildMenuItem(
                      Icons.logout_rounded,
                      "Logout",
                      "Keluar dari akun kamu",
                      isLogout: true,
                      onTap: () => controller.logout(),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProfileController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        context.mediaQueryPadding.top + 20,
        20,
        30,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        image: DecorationImage(
          image: AssetImage('assets/images/beranda/cover_atas.png'),
          fit: BoxFit.cover,
          opacity: 0.15,
          alignment: Alignment.center,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Akun",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Kelola informasi dan aktivitasmu di sini",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Obx(() {
              final user = controller.userService.user.value;
              final String name = user?.name ?? "User Tegal";
              final String email = user?.email ?? "guest@tegalculture.id";
              final String? profilePic = user?.profilePicture;

              return Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.background,
                    child: ClipOval(
                      child: profilePic != null && profilePic.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: profilePic,
                              fit: BoxFit.cover,
                              width: 56,
                              height: 56,
                              placeholder: (context, url) => const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                color: AppColors.primary,
                                size: 28,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: AppColors.primary,
                              size: 28,
                            ),
                    ),
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
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelPointsCard(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Obx(() {
        final int level = controller.currentLevel.value;
        final int points = controller.totalPoints.value;

        return Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.military_tech_rounded,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Level Akun",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Level $level",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 40, width: 1, color: Colors.grey.shade200),
            Expanded(
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.monetization_on_rounded,
                      color: Colors.amber,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Poin",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$points",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatsRow(ProfileController controller) {
    return Obx(() {
      final int sitesCount = controller.scannedSitesCount.value;
      final int quizzesCount = controller.correctQuizzesCount.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statItem(
            Icons.temple_hindu_rounded,
            "$sitesCount",
            "Budaya Jelajahi",
          ),
          _statItem(
            Icons.qr_code_scanner_rounded,
            "$sitesCount",
            "Lokasi Fisik",
          ),
          _statItem(Icons.quiz_rounded, "$quizzesCount", "Kuis Selesai"),
        ],
      );
    });
  }

  Widget _statItem(IconData icon, String count, String label) {
    return Container(
      width: Get.width * 0.28,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary.withOpacity(0.7)),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle, {
    String? trailingText,
    bool isSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isLogout ? Colors.red.shade50.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isLogout ? Colors.red.shade100 : AppColors.background,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isLogout ? Colors.red : AppColors.primary.withOpacity(0.7),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isLogout ? Colors.red : Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        trailing: isSwitch
            ? Switch(
                value: switchValue,
                onChanged: onSwitchChanged,
                activeColor: AppColors.accent,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (trailingText != null)
                    Text(
                      trailingText,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isLogout ? Colors.red : Colors.grey,
                  ),
                ],
              ),
      ),
    );
  }
}
