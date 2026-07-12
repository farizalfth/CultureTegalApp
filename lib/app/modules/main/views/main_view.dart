import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../../event/views/event_view.dart';
import '../../explore/views/explore_view.dart';
import '../../home/views/home_view.dart';
import '../../profile/view.dart';
import '../../umkm/views/umkm_view.dart';
import '../controllers/controller.dart';
import '../../../utils/shimmer_placeholder.dart';

class MainWrapper extends GetView<MainController> {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeView(),
      const ExploreView(),
      const UmkmView(),
      const EventView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            if (controller.bootError.value) {
              return _buildGlobalBootErrorState();
            }

            if (controller.isBooting.value) {
              return _buildGlobalBootingState(context);
            }

            return IndexedStack(
              index: controller.currentIndex.value,
              children: screens,
            );
          }),
          Obx(() {
            if (controller.isBooting.value || controller.bootError.value) {
              return const SizedBox.shrink();
            }
            return Stack(
              children: [
                _buildFabOverlay(),
                _buildRadialMenu(context),
                _buildGlobalScrollToTopButton(context),
              ],
            );
          }),
        ],
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) {
              if (!controller.isBooting.value && !controller.bootError.value) {
                controller.changePage(index);
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.accent,
            unselectedItemColor: Colors.grey.shade400,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            showUnselectedLabels: true,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_rounded),
                label: 'Jelajah',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_mall_rounded),
                label: 'UMKM',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event_note_rounded),
                label: 'Event',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Akun',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalScrollToTopButton(BuildContext context) {
    final double baseBottom = context.mediaQueryPadding.bottom + 20;

    return Obx(() {
      final bool isVisible = controller.showScrollToTop.value;

      return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        left: 20,
        bottom: isVisible ? baseBottom : -80,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: isVisible ? 1.0 : 0.0,
          child: GestureDetector(
            onTap: () => controller.scrollToTop(),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: AppColors.primary,
                size: 26,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildGlobalBootingState(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerPlaceholder(
              width: double.infinity,
              height: context.mediaQueryPadding.top + 160,
              borderRadius: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const ShimmerPlaceholder(
                    width: 150,
                    height: 24,
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      4,
                      (index) => const ShimmerPlaceholder(
                        width: 65,
                        height: 65,
                        borderRadius: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const ShimmerPlaceholder(
                    width: 180,
                    height: 24,
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 20),
                  const ShimmerPlaceholder(
                    width: double.infinity,
                    height: 180,
                    borderRadius: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalBootErrorState() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 72, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              "Gagal Memuat Sistem",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.bootErrorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => controller.initializeSystem(),
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text(
                "Coba Lagi",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFabOverlay() {
    return Obx(
      () => AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: controller.isFabExpanded.value ? 1 : 0,
        child: controller.isFabExpanded.value
            ? GestureDetector(
                onTap: () => controller.toggleFab(),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildRadialMenu(BuildContext context) {
    const double radius = 115.0;
    const double baseRight = 20.0;
    final double baseBottom = context.mediaQueryPadding.bottom + 20;

    return Obx(() {
      final bool isOpen = controller.isFabExpanded.value;

      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          _buildCustomFab(
            right: isOpen ? baseRight + radius : baseRight + 2,
            bottom: baseBottom + 2,
            icon: Icons.quiz_rounded,
            label: "Kuis",
            isOpen: isOpen,
            onTap: () => controller.goToQuiz(),
          ),
          _buildCustomFab(
            right: isOpen
                ? baseRight + (radius * math.cos(math.pi / 3.65))
                : baseRight + 2,
            bottom: isOpen
                ? baseBottom + (radius * math.sin(math.pi / 3.65))
                : baseBottom + 2,
            icon: Icons.qr_code_scanner_rounded,
            label: "Scan",
            isOpen: isOpen,
            onTap: () => controller.goToScan(),
          ),
          _buildCustomFab(
            right: baseRight + 2,
            bottom: isOpen ? baseBottom + radius : baseBottom + 2,
            icon: Icons.map_rounded,
            label: "Map",
            isOpen: isOpen,
            onTap: () => controller.goToMap(),
          ),
          Positioned(
            right: baseRight,
            bottom: baseBottom,
            child: GestureDetector(
              onTap: () => controller.toggleFab(),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: AnimatedRotation(
                  turns: isOpen ? 0.125 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCustomFab({
    required double right,
    required double bottom,
    required IconData icon,
    required String label,
    required bool isOpen,
    required VoidCallback onTap,
  }) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutQuart,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        ignoring: !isOpen,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: isOpen ? 1 : 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isOpen)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              GestureDetector(
                onTap: isOpen ? onTap : null,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
