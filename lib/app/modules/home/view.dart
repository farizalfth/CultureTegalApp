import 'package:flutter/material.dart';
import '../../data/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // QR Bawah sudah dihapus sepenuhnya
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildMenuGrid(),
            _buildMarketplaceHeader(),
            _buildHorizontalProducts(),
            const SizedBox(height: 30), // Ruang ekstra di bawah agar UX lebih lega
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tegal Culture",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Selamat Datang, Nadhif Basalamah!",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => print("Buka Scan Budaya"),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person_rounded, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari budaya Tegal...",
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
                icon: const Icon(Icons.search_rounded, color: Colors.grey),
                suffixIcon: IntrinsicWidth(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.monetization_on, size: 14, color: Colors.white),
                        Text(
                          " 1.250",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.4, // Sedikit lebih tinggi untuk UX yang lebih baik
      children: [
        _menuCard("Smart Culture", Icons.auto_awesome_rounded, AppColors.cardBlue),
        _menuCard("Jelajah Budaya", Icons.explore_rounded, AppColors.cardOrange),
        _menuCard("Toko Budaya", Icons.local_mall_rounded, AppColors.cardRed),
        _menuCard("Kuis Budaya", Icons.quiz_rounded, AppColors.cardBrown),
      ],
    );
  }

  Widget _menuCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18), // Lebih membulat agar modern
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Icon(icon, color: Colors.white.withOpacity(0.4), size: 45),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketplaceHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Marketplace UMKM Tegal",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "See all >",
            style: TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalProducts() {
    return Container(
      height: 290, // Sangat besar agar memenuhi tampilan bawah
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        children: [
          // Gambar Ciri Khas Tegal diambil dari aset budaya publik
          _productCard(
              "Batik Tegalan", 
              "Rp250.000", 
              "https://www.wartabahari.com/wp-content/uploads/2017/10/baatik-tegal.jpg"),
          _productCard(
              "Teh Poci Tanah", 
              "Rp45.000", 
              "https://upload.wikimedia.org/wikipedia/commons/c/c3/Teh_Poci_Gula_Batu.jpg"),
          _productCard(
              "Krupuk Antor", 
              "Rp15.000", 
              "https://rricoid-assets.obs.ap-southeast-4.myhuaweicloud.com/berita/Semarang/o/1722830394570-WhatsApp_Image_2024-08-05_at_10.24.02_(1)/1axbz9w27i10r66.jpeg"),
        ],
      ),
    );
  }

  Widget _productCard(String name, String price, String imageUrl) {
    return Container(
      width: 210, 
      margin: const EdgeInsets.only(right: 18),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 5),
                Text(price,
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }
}