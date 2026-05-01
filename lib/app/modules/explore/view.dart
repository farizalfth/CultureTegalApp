import 'package:flutter/material.dart';
import '../../data/app_colors.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryTabs(),
                  const SizedBox(height: 25),
                  _buildHeroBanner(),
                  const SizedBox(height: 25),
                  _buildSectionHeader("Kategori Populer"),
                  _buildPopularCategories(),
                  const SizedBox(height: 25),
                  _buildSectionHeader(
                    "Jelajah Sekitar Anda",
                    action: "Lihat Peta",
                  ),
                  _buildNearbyMapSection(),
                  const SizedBox(height: 25),
                  _buildSectionHeader("Rekomendasi Untukmu"),
                  _buildRecommendationCard(),
                  const SizedBox(height: 25),
                  _buildPromoBanner(),
                  const SizedBox(height: 40), // Ruang ekstra bawah
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk memuat gambar dengan aman agar tidak muncul tanda silang merah
  Widget _safeImage(
    String url, {
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.network(
      url,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: width,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: height,
          width: width,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        // Pastikan hapus 'const' jika muncul error di pubspec lama, namun biasanya tetap bisa
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        // --- TAMBAHKAN BAGIAN INI ---
        image: DecorationImage(
          image: AssetImage('assets/images/beranda/1.png'),
          fit: BoxFit.cover,
          opacity:
              0.15, // Mengatur agar gambar menjadi tekstur transparan di latar belakang
        ),
        // ----------------------------
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
                    "Jelajah Budaya",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Temukan keindahan budaya Kota Tegal",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Cari tempat budaya...",
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.tune_rounded, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = [
      {'icon': Icons.grid_view_rounded, 'label': 'Semua'},
      {'icon': Icons.account_balance_rounded, 'label': 'Sejarah'},
      {'icon': Icons.theater_comedy_rounded, 'label': 'Tradisi'},
      {'icon': Icons.restaurant_rounded, 'label': 'Kuliner'},
    ];
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: index == 0 ? Colors.deepOrange : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    categories[index]['icon'] as IconData,
                    color: index == 0 ? Colors.white : Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  categories[index]['label'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[300],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _safeImage(
              'https://upload.wikimedia.org/wikipedia/commons/e/e0/Batik_Tegal.JPG',
              width: double.infinity,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Gereja Blenduk",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Ikon sejarah Kota Tegal",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                  ),
                  child: const Text(
                    "Jelajah Sekarang",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCategories() {
    return SizedBox(
      height: 200, // Tinggi diperbaiki agar pas
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _popularCard(
            "Masjid Agung Tegal",
            "Sejarah",
            "https://upload.wikimedia.org/wikipedia/commons/e/e2/Masjid_Agung_Tegal.jpg",
          ),
          _popularCard(
            "Klenteng Tek Hay Kiong",
            "Tradisi",
            "https://upload.wikimedia.org/wikipedia/commons/a/a2/Klenteng_Tek_Hay_Kiong_Tegal.jpg",
          ),
        ],
      ),
    );
  }

  Widget _popularCard(String title, String tag, String img) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: _safeImage(img, height: 110, width: 170),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyMapSection() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Icon(
                Icons.map_outlined,
                size: 50,
                color: Colors.grey[400],
              ),
            ),
          ), // Placeholder Peta
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.orange, size: 16),
                const SizedBox(width: 8),
                const Text(
                  "Lihat lokasi di sekitar anda",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _safeImage(
              'https://upload.wikimedia.org/wikipedia/commons/1/1a/Tahu_Aci_Tegal.jpg',
              width: 90,
              height: 90,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tahu Aci Khas Tegal",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  "Kuliner favorit yang wajib dicoba saat berkunjung.",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.bookmark_outline, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Kumpulkan Lencana Budaya!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text(
              "Lihat",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String action = "Lihat Semua"}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
            action,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
