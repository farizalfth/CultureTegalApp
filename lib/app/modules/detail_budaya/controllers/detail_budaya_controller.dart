import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../data/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../data/service/auth_service.dart';
import '../../../data/service/user_service.dart';
import '../../../routes/app_pages.dart';

class DetailBudayaController extends GetxController {
  final PageController pageController = PageController();
  final AuthService _authService = Get.find<AuthService>();
  final String baseUrl = dotenv.env['FLASK_API_URL'] ?? '';

  CultureModel? culture;
  final currentIndex = 0.obs;
  final isExpanded = false.obs;
  final isFavorite = false.obs;

  final Rxn<double> dynamicDistance = Rxn<double>();
  final RxBool isClaimingGeofence = false.obs;
  final RxBool isCalculatingDistance = false.obs;
  final RxBool isLoadingSiteDetails = false.obs;

  final RxBool isWordCloudLoading = false.obs;
  final RxList<Map<String, dynamic>> wordCloudData =
      <Map<String, dynamic>>[].obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final dynamic argument = Get.arguments;
    if (argument is CultureModel) {
      culture = argument;
      _initializeDetailsFlow();
    } else if (argument is String) {
      _loadCultureSiteById(argument);
    }
  }

  void _initializeDetailsFlow() {
    _checkInitialFavoriteState();
    _calculateDynamicDistance();
    _startAutoSlide();
    _awardReadingPointsSecurely();
    _fetchWordCloud();
  }

  Future<void> _fetchWordCloud() async {
    if (culture == null) return;
    isWordCloudLoading.value = true;
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http
          .get(
            Uri.parse(
              '$cleanBase/explore/wordcloud/${Uri.encodeComponent(culture!.title)}',
            ),
            headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> data = body['data'] ?? [];
        wordCloudData.assignAll(List<Map<String, dynamic>>.from(data));
      } else {
        wordCloudData.clear();
      }
    } catch (e) {
      wordCloudData.clear();
    } finally {
      isWordCloudLoading.value = false;
    }
  }

  Future<void> _loadCultureSiteById(String siteId) async {
    try {
      isLoadingSiteDetails.value = true;
      await _authService.waitForSession();

      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http
          .get(
            Uri.parse('$cleanBase/explore/$siteId'),
            headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        culture = CultureModel.fromJson(body['data']);
        _initializeDetailsFlow();
        update();
      }
    } catch (_) {
      Get.back();
      Get.snackbar("Kesalahan", "Gagal memuat detail objek sejarah.");
    } finally {
      isLoadingSiteDetails.value = false;
    }
  }

  void _checkInitialFavoriteState() async {
    await _authService.waitForSession();
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http.get(
        Uri.parse('$cleanBase/users/favorites'),
        headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> cultures = body['data']?['cultures'] ?? [];
        final isFav = cultures.any((c) => c['id'] == culture!.id);
        isFavorite.value = isFav;
      }
    } catch (_) {}
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _calculateDynamicDistance() async {
    try {
      isCalculatingDistance.value = true;
      Position position = await _determinePosition();
      double distanceInMeters = _calculateDistanceMath(
        position.latitude,
        position.longitude,
        culture!.latitude,
        culture!.longitude,
      );
      dynamicDistance.value = distanceInMeters / 1000.0;
    } catch (_) {
      dynamicDistance.value = null;
    } finally {
      isCalculatingDistance.value = false;
    }
  }

  Future<void> recalculateDistance() async {
    await _calculateDynamicDistance();
    if (dynamicDistance.value != null) {
      Get.snackbar(
        "GPS Diperbarui",
        "Jarak ke lokasi budaya berhasil dihitung ulang menggunakan koordinat rill kamu!",
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "GPS Gagal",
        "Gagal mendapatkan koordinat GPS terbaru perangkat. Pastikan GPS aktif.",
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
      );
    }
  }

  double _calculateDistanceMath(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const r = 6371000.0;
    final phi1 = lat1 * math.pi / 180.0;
    final phi2 = lat2 * math.pi / 180.0;
    final deltaPhi = (lat2 - lat1) * math.pi / 180.0;
    final deltaLambda = (lon2 - lon1) * math.pi / 180.0;
    final a =
        math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
        math.cos(phi1) *
            math.cos(phi2) *
            math.sin(deltaLambda / 2) *
            math.sin(deltaLambda / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  Future<void> shareCultureSite() async {
    final String shareText =
        "Ayo jelajahi dan pelajari sejarah '${culture!.title}' di Tegal Culture! Klik tautan untuk melihat lokasi: https://www.google.com/maps/search/?api=1&query=${culture!.latitude},${culture!.longitude}";
    await Clipboard.setData(ClipboardData(text: shareText));
    Get.snackbar(
      "Tautan Disalin",
      "Informasi objek sejarah berhasil disalin ke papan klip. Silakan bagikan ke teman-temanmu!",
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  Future<void> _awardReadingPointsSecurely() async {
    await _authService.waitForSession();
    await Future.delayed(const Duration(seconds: 2));
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http
          .post(
            Uri.parse('$cleanBase/scans/read'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${_authService.currentToken}',
            },
            body: json.encode({'site_id': culture!.id}),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        final int earned = result['points_earned'] ?? 0;
        if (earned > 0) {
          await UserService.to.refreshUserData();
          Get.snackbar(
            "Apresiasi Literasi",
            "Kamu mendapatkan +10 Poin Budaya karena meluangkan waktu mempelajari sejarah objek ini!",
            backgroundColor: Colors.amber.shade700,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        }
      }
    } catch (_) {}
  }

  Future<void> toggleFavorite() async {
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http
          .post(
            Uri.parse('$cleanBase/users/favorites/toggle'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${_authService.currentToken}',
            },
            body: json.encode({
              'target_type': 'culture',
              'target_id': culture!.id,
            }),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        isFavorite.value = !isFavorite.value;
        Get.snackbar(
          isFavorite.value ? "Ditambahkan" : "Dihapus",
          isFavorite.value
              ? "Berhasil disimpan ke favorit."
              : "Berhasil dihapus dari favorit.",
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Kesalahan", "Gagal memproses favorit.");
    }
  }

  Future<void> openGoogleMapsRouting() async {
    double userLat = -6.8672;
    double userLng = 109.1380;

    try {
      Position position = await _determinePosition();
      userLat = position.latitude;
      userLng = position.longitude;
    } catch (_) {}

    final String destinationCoords =
        "${culture!.latitude},${culture!.longitude}";
    final String originCoords = "$userLat,$userLng";

    final iosAppUrl = Uri.parse(
      "comgooglemaps://?saddr=$originCoords&daddr=$destinationCoords&directionsmode=driving",
    );
    final androidAppUrl = Uri.parse(
      "google.navigation:q=$destinationCoords&mode=d",
    );
    final webUrlWithOrigin = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&origin=$originCoords&destination=$destinationCoords&travelmode=driving",
    );
    final webUrlNoOrigin = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$destinationCoords",
    );

    try {
      if (await canLaunchUrl(iosAppUrl)) {
        await launchUrl(iosAppUrl);
      } else if (await canLaunchUrl(androidAppUrl)) {
        await launchUrl(androidAppUrl);
      } else {
        await launchUrl(webUrlWithOrigin, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      try {
        await launchUrl(webUrlNoOrigin, mode: LaunchMode.externalApplication);
      } catch (e) {
        Get.snackbar("Kesalahan", "Tidak dapat membuka aplikasi peta.");
      }
    }
  }

  void openNavigationChoice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pilihan Rute Perjalanan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.navigation_rounded,
                    color: Colors.blue.shade700,
                  ),
                ),
                title: const Text(
                  "Buka Navigasi (Google Maps)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: const Text(
                  "Mulai rute navigasi berkendara ke lokasi rill",
                  style: TextStyle(fontSize: 11),
                ),
                onTap: () {
                  Get.back();
                  openGoogleMapsRouting();
                },
              ),
              const Divider(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.map_rounded, color: AppColors.accent),
                ),
                title: const Text(
                  "Lihat di Peta Tegal Culture",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: const Text(
                  "Tinjau sebaran lokasi budaya di peta interaktif kita",
                  style: TextStyle(fontSize: 11),
                ),
                onTap: () {
                  Get.back();
                  Get.toNamed(
                    Routes.MAP_EXPLORE,
                    arguments: {'targetId': culture!.id},
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> claimGeofenceVisit() async {
    double userLat = 0.0;
    double userLng = 0.0;

    try {
      Position position = await _determinePosition();
      userLat = position.latitude;
      userLng = position.longitude;
    } catch (err) {
      Get.snackbar(
        "GPS Tidak Aktif",
        "Gagal mendapatkan koordinat lokasi GPS fisik rill kamu.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    double distanceInMeters = _calculateDistanceMath(
      userLat,
      userLng,
      culture!.latitude,
      culture!.longitude,
    );

    if (distanceInMeters > 100.0) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            "Verifikasi Gagal",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Kamu berada sejauh ${distanceInMeters.toStringAsFixed(0)} meter dari lokasi. Untuk memverifikasi kunjungan fisik, kamu harus berada di dalam radius 100 meter dari objek budaya ini.",
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                "Mengerti",
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    try {
      isClaimingGeofence.value = true;
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http
          .post(
            Uri.parse('$cleanBase/scans/geofence'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${_authService.currentToken}',
            },
            body: json.encode({
              'site_id': culture!.id,
              'latitude': userLat,
              'longitude': userLng,
            }),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        await UserService.to.refreshUserData();
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Text(
              "Berhasil Verifikasi!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            content: const Text(
              "Selamat! Kehadiran fisikmu terverifikasi secara geofencing rill. +100 Poin Budaya telah ditambahkan ke akunmu.",
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  "Selesai",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar(
          "Info Kunjungan",
          "Kamu sudah memverifikasi kunjungan fisik di lokasi ini sebelumnya.",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menghubungi server verifikasi.");
    } finally {
      isClaimingGeofence.value = false;
    }
  }

  void _startAutoSlide() {
    if (culture!.gallery.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (pageController.hasClients) {
          int nextIndex = (currentIndex.value + 1) % culture!.gallery.length;
          if (nextIndex < 5) {
            pageController.animateToPage(
              nextIndex,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
            );
          } else {
            pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    }
  }

  void toggleExpand() => isExpanded.value = !isExpanded.value;

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
