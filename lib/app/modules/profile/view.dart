import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/app_colors.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildProgressCard(),
                  const SizedBox(height: 20),
                  _buildStatsRow(),
                  const SizedBox(height: 30),

                  // Menu Utama
                  _buildSectionTitle("Menu Utama"),
                  _buildMenuItem(
                    Icons.person_outline_rounded,
                    "Edit Profil",
                    "Ubah informasi akun kamu",
                  ),
                  _buildMenuItem(
                    Icons.location_on_outlined,
                    "Riwayat Jelajah",
                    "Lihat tempat budaya yang pernah dikunjungi",
                  ),
                  _buildMenuItem(
                    Icons.qr_code_scanner_rounded,
                    "Scan History",
                    "Lihat hasil scan budaya yang telah kamu lakukan",
                  ),
                  _buildMenuItem(
                    Icons.shopping_bag_outlined,
                    "Pesanan UMKM",
                    "Lihat pesanan produk UMKM kamu",
                  ),
                  _buildMenuItem(
                    Icons.favorite_outline_rounded,
                    "Favorit",
                    "Lihat budaya, tempat dan produk favoritmu",
                  ),

                  const SizedBox(height: 25),

                  // Pengaturan
                  _buildSectionTitle("Pengaturan"),
                  _buildMenuItem(
                    Icons.notifications_none_rounded,
                    "Notifikasi",
                    "Kelola pengaturan notifikasi",
                  ),
                  _buildMenuItem(
                    Icons.language_rounded,
                    "Bahasa",
                    "Pilih bahasa aplikasi",
                    trailingText: "Bahasa Indonesia",
                  ),
                  _buildMenuItem(
                    Icons.dark_mode_outlined,
                    "Dark Mode",
                    "Aktifkan tampilan gelap",
                    isSwitch: true,
                  ),
                  _buildMenuItem(
                    Icons.security_outlined,
                    "Privasi & Keamanan",
                    "Kelola privasi dan keamanan akun",
                  ),

                  const SizedBox(height: 25),

                  // Bantuan & Informasi
                  _buildSectionTitle("Bantuan & Informasi"),
                  _buildMenuItem(
                    Icons.info_outline_rounded,
                    "Tentang Aplikasi",
                    "Informasi tentang Tegal Culture",
                  ),
                  _buildMenuItem(
                    Icons.help_outline_rounded,
                    "Bantuan",
                    "Pusat bantuan dan FAQ",
                  ),
                  _buildMenuItem(
                    Icons.description_outlined,
                    "Syarat & Ketentuan",
                    "Baca syarat dan ketentuan penggunaan",
                  ),

                  // Logout
                  const SizedBox(height: 10),
                  _buildMenuItem(
                    Icons.logout_rounded,
                    "Logout",
                    "Keluar dari akun kamu",
                    isLogout: true,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      // Padding disamakan dengan Event/Beranda agar konsisten (Top: 60, Bottom: 30)
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        // --- PERBAIKAN GAMBAR DI SINI ---
        image: DecorationImage(
          image: AssetImage('assets/images/beranda/cover_atas.png'),
          fit: BoxFit.cover, // MEMBUAT GAMBAR FULL MENUTUPI BACKGROUND
          opacity: 0.15, // Tekstur halus agar teks tetap terbaca
          alignment: Alignment.center, // Memastikan gambar di tengah
        ),
        // --------------------------------
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
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
              const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 25),
          // Profile Card (Putih)
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
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.background,
                  child: Icon(Icons.person, color: AppColors.primary),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nadhif Basalamah",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "nadhif.b@email.com",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(15),
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.map_rounded, color: Colors.orange),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Progress Jelajah Budaya",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Terus jelajahi dan dapatkan lebih banyak pencapaian!",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Column(
                children: [
                  Text(
                    "Level 3",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "60%",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: 0.6,
            backgroundColor: Colors.grey.shade200,
            color: Colors.orange,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statItem(Icons.temple_hindu_rounded, "12", "Budaya Jelajahi"),
        _statItem(Icons.qr_code_scanner_rounded, "8", "Scan Berhasil"),
        _statItem(Icons.quiz_rounded, "5", "Quiz Selesai"),
      ],
    );
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
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isLogout ? Colors.red.shade50.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
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
                value: false,
                onChanged: (v) {},
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
