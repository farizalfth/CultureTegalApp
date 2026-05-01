import 'package:flutter/material.dart';
import '../../data/app_colors.dart';

class EventView extends StatelessWidget {
  const EventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategories(),
                  const SizedBox(height: 25),
                  _buildSectionHeader("Event Mendatang"),
                  const SizedBox(height: 15),
                  _buildEventList(),
                  const SizedBox(height: 25),
                  _buildSectionHeader("Berita Tegal"),
                  const SizedBox(height: 15),
                  _buildNewsList(),
                  const SizedBox(height: 30),
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
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        image: DecorationImage(
          image: AssetImage('assets/images/beranda/1.png'),
          fit: BoxFit.cover, // <--- TAMBAHKAN INI AGAR FULL
          opacity: 0.15, // Sedikit dinaikkan agar lebih terlihat
          // repeat: ImageRepeat.repeat, // <--- HAPUS ATAU KOMENTARI INI
        ),
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
                    "Event Tegal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Temukan berbagai event menarik di Kota Tegal",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
              Stack(
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        "1",
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ),
                  ),
                ],
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
                      hintText: "Cari event di Tegal...",
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.grey),
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

  Widget _buildCategories() {
    final categories = [
      {'icon': Icons.calendar_month, 'label': 'Semua', 'active': true},
      {'icon': Icons.temple_hindu, 'label': 'Budaya', 'active': false},
      {'icon': Icons.storefront, 'label': 'UMKM', 'active': false},
      {'icon': Icons.school, 'label': 'Edukasi', 'active': false},
      {'icon': Icons.terrain, 'label': 'Pariwisata', 'active': false},
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            width: 75,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cat['active'] as bool
                        ? AppColors.accent
                        : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Icon(
                    cat['icon'] as IconData,
                    color: cat['active'] as bool
                        ? Colors.white
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cat['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: cat['active'] as bool
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Lihat Semua",
          style: TextStyle(
            color: AppColors.accent,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return Column(
      children: [
        _eventCard(
          "Festival Bahari Tegal",
          "Alun-alun Kota Tegal",
          "25 Mei",
          "Festival budaya dan bahari dengan berbagai pertunjukan seni...",
          "09.00 - 22.00 WIB",
          "https://infotegal.com/wp-content/uploads/2016/08/karnaval-bahari-tegal.jpg",
        ),
        const SizedBox(height: 15),
        _eventCard(
          "Kirab Budaya Tegal",
          "Jl. Pancasila, Tegal",
          "01 Jun",
          "Kirab budaya tahunan yang menampilkan berbagai kesenian tradisional...",
          "08.00 - 12.00 WIB",
          "https://Pikiran-Rakyat.com/storage/visual/2022/04/kirab-budaya.jpg",
        ),
      ],
    );
  }

  Widget _eventCard(
    String title,
    String loc,
    String date,
    String desc,
    String time,
    String img,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  img,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        date.split(" ")[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        date.split(" ")[1],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      loc,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_filled,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    return Column(
      children: [
        _newsCard(
          "Gereja Blenduk Jadi Ikon Sejarah Kota Tegal",
          "Budaya",
          "20 Mei 2024",
          "https://pariwisata.tegalkota.go.id/upload/wisata/blenduk.jpg",
        ),
        const SizedBox(height: 12),
        _newsCard(
          "Tahu Aci Khas Tegal Semakin Diminati Wisatawan",
          "Kuliner",
          "19 Mei 2024",
          "https://upload.wikimedia.org/wikipedia/commons/1/1a/Tahu_Aci_Tegal.jpg",
        ),
      ],
    );
  }

  Widget _newsCard(String title, String cat, String date, String img) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              img,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) =>
                  Container(width: 80, height: 80, color: Colors.grey[200]),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    cat,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    const Icon(
                      Icons.bookmark_outline,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
