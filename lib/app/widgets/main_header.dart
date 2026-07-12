import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/app_colors.dart';
import '../data/service/user_service.dart';
import '../modules/event/controllers/event_controller.dart';
import '../modules/main/controllers/controller.dart';
import '../modules/explore/controllers/explore_controller.dart';
import '../modules/home/controllers/home_controller.dart';
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

  bool _checkIsLoading() {
    try {
      if (Get.isRegistered<ExploreController>() &&
          Get.find<ExploreController>().isLoading.value) {
        return true;
      }
    } catch (_) {}
    try {
      if (Get.isRegistered<HomeController>() &&
          Get.find<HomeController>().isLoading.value) {
        return true;
      }
    } catch (_) {}
    try {
      if (Get.isRegistered<EventController>() &&
          Get.find<EventController>().isLoading.value) {
        return true;
      }
    } catch (_) {}
    return false;
  }

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
                    Obx(() {
                      final user = UserService.to.user.value;
                      final displayName = user?.name ?? "Pengguna Aplikasi";

                      final displaySubtitle = title == "Tegal Culture"
                          ? "Halo, $displayName!"
                          : subtitle;

                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              displaySubtitle,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
                    final bool isLoading = _checkIsLoading();

                    return SpinningGlowAvatar(
                      imageUrl: user?.profilePicture,
                      radius: 20,
                      isRefreshing: isLoading,
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
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.NOTIFIKASI),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildQuizPointsCard(String points) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.KUIS_BUDAYA),
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

class SpinningGlowAvatar extends StatefulWidget {
  final String? imageUrl;
  final double radius;
  final bool isRefreshing;

  const SpinningGlowAvatar({
    super.key,
    this.imageUrl,
    this.radius = 20.0,
    this.isRefreshing = false,
  });

  @override
  State<SpinningGlowAvatar> createState() => _SpinningGlowAvatarState();
}

class _SpinningGlowAvatarState extends State<SpinningGlowAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isRefreshing) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant SpinningGlowAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRefreshing != oldWidget.isRefreshing) {
      if (widget.isRefreshing) {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPhoto =
        widget.imageUrl != null && widget.imageUrl!.isNotEmpty;

    final Widget innerAvatar = GestureDetector(
      onTap: () {
        Get.find<MainController>().changePage(4);
      },
      child: CircleAvatar(
        radius: widget.radius,
        backgroundColor: Colors.white24,
        child: ClipOval(
          child: hasPhoto
              ? CachedNetworkImage(
                  imageUrl: widget.imageUrl!,
                  fit: BoxFit.cover,
                  width: widget.radius * 2,
                  height: widget.radius * 2,
                  placeholder: (context, url) => const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.white70,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                )
              : const Icon(Icons.person_rounded, color: Colors.white, size: 20),
        ),
      ),
    );

    return SizedBox(
      width: (widget.radius + 3) * 2,
      height: (widget.radius + 3) * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            opacity: widget.isRefreshing ? 1.0 : 0.0,
            onEnd: () {
              if (!widget.isRefreshing) {
                _controller.stop();
                _controller.reset();
              }
            },
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: Container(
                    width: (widget.radius + 3) * 2,
                    height: (widget.radius + 3) * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.6),
                          Colors.white,
                        ],
                        stops: const [0.0, 0.4, 0.8, 1.0],
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(0.8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: widget.isRefreshing ? 0.0 : 1.0,
            child: Container(
              width: (widget.radius + 3) * 2,
              height: (widget.radius + 3) * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 0.8,
                ),
              ),
            ),
          ),
          innerAvatar,
        ],
      ),
    );
  }
}
