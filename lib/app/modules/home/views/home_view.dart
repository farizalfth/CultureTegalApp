import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../../../data/service/user_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/main_header.dart';
import '../../main/controllers/controller.dart';
import '../controllers/home_controller.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/news_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = context.width;
    final double screenHeight = context.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () => controller.loadAllData(),
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final user = UserService.to.user.value;
                final displayName = user?.name ?? "Nadhif Basalamah";
                return MainHeader(
                  title: "Tegal Culture",
                  subtitle: "Halo, $displayName!",
                  hintText: "Cari budaya Tegal...",
                );
              }),
              _buildMenuGrid(),
              _buildSectionHeader("Event Budaya", () {
                Get.find<MainController>().currentIndex.value = 2;
              }),
              _buildRunningEvents(screenWidth, screenHeight),
              _buildSectionHeader("Marketplace UMKM", () {}),
              _buildHorizontalProducts(screenWidth, screenHeight),
              _buildSectionHeader(
                "Berita Tegal",
                () => Get.toNamed(Routes.NEWS_LIST),
              ),
              _buildNewsList(screenWidth),
              SizedBox(height: context.mediaQueryPadding.bottom + 110),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.count(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.45,
      children: [
        _menuCard(
          "Smart Culture",
          Icons.auto_awesome_rounded,
          AppColors.cardBlue,
        ),
        _menuCard(
          "Jelajah Budaya",
          Icons.explore_rounded,
          AppColors.cardOrange,
        ),
        _menuCard("Toko Budaya", Icons.local_mall_rounded, AppColors.cardRed),
        _menuCard("Kuis Budaya", Icons.quiz_rounded, AppColors.cardBrown),
      ],
    );
  }

  Widget _menuCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    icon,
                    color: Colors.white.withOpacity(0.3),
                    size: 46,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              letterSpacing: 0.2,
            ),
          ),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                "Lihat Semua",
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRunningEvents(double width, double height) {
    return SizedBox(
      height: height * 0.26,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 20),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.events.length,
          itemBuilder: (context, index) {
            final event = controller.events[index];
            return _eventCard(event, width);
          },
        ),
      ),
    );
  }

  Widget _eventCard(EventModel event, double width) {
    return Container(
      width: width * 0.78,
      margin: const EdgeInsets.only(right: 16, bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.toNamed(Routes.DETAIL_EVENT, arguments: event),
            child: Stack(
              children: [
                Positioned.fill(
                  child: event.imageUrl != null
                      ? Image.network(event.imageUrl!, fit: BoxFit.cover)
                      : Image.asset(
                          'assets/images/beranda/cover_atas.png',
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.85),
                          Colors.black.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  event.badgeTop,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  event.badgeBottom,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: event.isRecurring
                                  ? AppColors.cardBlue
                                  : (event.status == "Sedang Berjalan"
                                        ? Colors.red.shade400
                                        : AppColors.accent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              event.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                event.time,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Icon(
                                Icons.location_on_rounded,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  event.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalProducts(double width, double height) {
    return SizedBox(
      height: height * 0.34,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          _productCard(
            "Batik Tegalan",
            "Rp250.000",
            "Toko Batik Berkah",
            "https://www.wartabahari.com/wp-content/uploads/2017/10/baatik-tegal.jpg",
            width,
          ),
          _productCard(
            "Teh Poci Tanah",
            "Rp45.000",
            "Pusat Oleh-Oleh Tegal",
            "https://upload.wikimedia.org/wikipedia/commons/c/c3/Teh_Poci_Gula_Batu.jpg",
            width,
          ),
          _productCard(
            "Krupuk Antor",
            "Rp15.000",
            "Warung Ibu Siti",
            "https://rricoid-assets.obs.ap-southeast-4.myhuaweicloud.com/berita/Semarang/o/1722830394570-WhatsApp_Image_2024-08-05_at_10.24.02_(1)/1axbz9w27i10r66.jpeg",
            width,
          ),
        ],
      ),
    );
  }

  Widget _productCard(
    String name,
    String price,
    String storeName,
    String imgUrl,
    double width,
  ) {
    return Container(
      width: width * 0.55,
      margin: const EdgeInsets.only(right: 16, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(imgUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        price,
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.storefront_rounded,
                              size: 14,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                storeName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsList(double width) {
    final List<NewsModel> dummyNews = [
      NewsModel(
        id: "n1",
        title: "Gereja Blenduk Jadi Ikon Sejarah Kota Tegal",
        category: "Budaya",
        date: "20 Mei 2024",
        image:
            "https://radarcbs.com/assets/images/1770943164_1840ce5bbf3c827b7d85.jpg",
      ),
      NewsModel(
        id: "n2",
        title: "Tahu Aci Khas Tegal Semakin Diminati Wisatawan",
        category: "Kuliner",
        date: "19 Mei 2024",
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQviHVXAO_su-hxtU7dqtrRCwBZMM0BotQGBs1hwfk9b_4_uJ0e-Njlzm2_dIjurP5kD8-00rKiMNkG9XSjQ3sKxQr_Fs3Ig_FwD8p84g&s=10",
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: dummyNews
            .map(
              (news) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.NEWS_DETAIL, arguments: news),
                  child: _newsCard(news),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _newsCard(NewsModel news) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(Routes.NEWS_DETAIL, arguments: news),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(news.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          news.category,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        news.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 12,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                news.date,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
