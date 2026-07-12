import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../data/models/culture_model.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/umkm_model.dart';
import '../../../data/models/map_item_model.dart';
import '../../../data/providers/culture_provider.dart';
import '../../../data/providers/event_provider.dart';
import '../../../data/providers/umkm_provider.dart';
import '../../../data/service/auth_service.dart';

class MapExploreController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();

  final CultureProvider _cultureProvider = Get.find<CultureProvider>();
  final EventProvider _eventProvider = Get.find<EventProvider>();
  final UmkmProvider _umkmProvider = Get.find<UmkmProvider>();
  final AuthService _authService = Get.find<AuthService>();
  final String baseUrl = dotenv.env['FLASK_API_URL'] ?? '';

  final RxBool isLoading = false.obs;
  final RxString searchQuery = "".obs;
  final Rxn<MapItem> selectedItem = Rxn<MapItem>();
  final RxString activeFilter = "Semua".obs;

  final List<MapItem> allMapItems = <MapItem>[];
  final RxList<MapItem> filteredMapItems = <MapItem>[].obs;

  final RxDouble currentZoom = 13.5.obs;
  final RxBool isWordCloudLoading = false.obs;
  final RxList<Map<String, dynamic>> wordCloudData =
      <Map<String, dynamic>>[].obs;

  final Rxn<LatLng> userLocation = Rxn<LatLng>();
  final RxBool isNearSite = false.obs;
  final Rxn<MapItem> nearSiteItem = Rxn<MapItem>();
  final RxBool isClaimingGeofence = false.obs;

  Timer? _searchDebounce;
  AnimationController? _animationController;

  @override
  void onInit() {
    super.onInit();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    loadAllMapData();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    _animationController?.dispose();
    searchController.dispose();
    mapController.dispose();
    super.onClose();
  }

  Future<void> loadAllMapData() async {
    try {
      isLoading.value = true;
      allMapItems.clear();

      await _authService.waitForSession();

      final results = await Future.wait([
        _cultureProvider.getCultures(),
        _eventProvider.getEvents(perPage: 100),
        _umkmProvider.getUmkms(perPage: 100),
      ]);

      final List<CultureModel> cultures = results[0] as List<CultureModel>;

      final Map<String, dynamic> eventData = results[1] as Map<String, dynamic>;
      final List<dynamic> eventListRaw = eventData['items'] ?? [];
      final List<EventModel> events = eventListRaw
          .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final Map<String, dynamic> umkmResponse =
          results[2] as Map<String, dynamic>;
      final Map<String, dynamic> umkmData = umkmResponse['data'] ?? {};
      final List<dynamic> umkmListRaw = umkmData['items'] ?? [];
      final List<UmkmModel> umkms = umkmListRaw
          .map((u) => UmkmModel.fromJson(u as Map<String, dynamic>))
          .toList();

      for (var c in cultures) {
        allMapItems.add(
          MapItem(
            id: c.id,
            title: c.title,
            subtitle: c.subtitle,
            imageUrl: c.image,
            coordinate: LatLng(c.latitude, c.longitude),
            type: MapItemType.culture,
            infoTag: "Budaya Tegal",
            rating: 0.0,
            originalModel: c,
          ),
        );
      }

      for (var e in events) {
        allMapItems.add(
          MapItem(
            id: e.id,
            title: e.name,
            subtitle: e.location,
            imageUrl: e.imageUrl ?? "",
            coordinate: LatLng(e.latitude, e.longitude),
            type: MapItemType.event,
            infoTag: e.fullDate,
            rating: 0.0,
            originalModel: e,
          ),
        );
      }

      for (var u in umkms) {
        if (u.latitude != null && u.longitude != null) {
          allMapItems.add(
            MapItem(
              id: u.id,
              title: u.name,
              subtitle: u.storeName,
              imageUrl: u.image,
              coordinate: LatLng(u.latitude!, u.longitude!),
              type: MapItemType.umkm,
              infoTag: u.price,
              rating: u.rating,
              originalModel: u,
            ),
          );
        }
      }

      applyFilters();
      _handleIncomingArguments();
    } catch (e) {
      Get.snackbar(
        'Kesalahan Koneksi',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<MapItem> temp = List.from(allMapItems);

    if (activeFilter.value == "Budaya") {
      temp = temp.where((item) => item.type == MapItemType.culture).toList();
    } else if (activeFilter.value == "Event") {
      temp = temp.where((item) => item.type == MapItemType.event).toList();
    } else if (activeFilter.value == "UMKM") {
      temp = temp.where((item) => item.type == MapItemType.umkm).toList();
    }

    final query = searchQuery.value.toLowerCase().trim();
    if (query.isNotEmpty) {
      temp = temp
          .where(
            (item) =>
                item.title.toLowerCase().contains(query) ||
                item.subtitle.toLowerCase().contains(query),
          )
          .toList();
    }

    filteredMapItems.assignAll(temp);
  }

  void changeFilter(String category) {
    activeFilter.value = category;
    selectedItem.value = null;
    applyFilters();
  }

  void onSearchChanged(String val) {
    searchQuery.value = val;
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      applyFilters();
      if (filteredMapItems.isNotEmpty && val.trim().length > 2) {
        final matchedItem = filteredMapItems.first;
        selectItem(matchedItem);
      } else if (val.trim().isEmpty) {
        selectedItem.value = null;
      }
    });
  }

  void updateZoom(double zoom) {
    currentZoom.value = zoom;
  }

  double getMarkerSize(MapItem item) {
    double baseSize = 38.0;
    double scale = currentZoom.value / 13.5;
    return (baseSize * scale).clamp(26.0, 60.0);
  }

  void animateToLocation(LatLng target, double destZoom) {
    final latTween = Tween<double>(
      begin: mapController.camera.center.latitude,
      end: target.latitude,
    );
    final lngTween = Tween<double>(
      begin: mapController.camera.center.longitude,
      end: target.longitude,
    );
    final zoomTween = Tween<double>(
      begin: mapController.camera.zoom,
      end: destZoom,
    );

    _animationController?.reset();
    _animationController?.addListener(() {
      if (_animationController != null) {
        mapController.move(
          LatLng(
            latTween.transform(_animationController!.value),
            lngTween.transform(_animationController!.value),
          ),
          zoomTween.transform(_animationController!.value),
        );
      }
    });

    _animationController?.forward();
  }

  void selectItem(MapItem item) {
    selectedItem.value = item;
    animateToLocation(item.coordinate, 15.5);
    fetchWordCloud(item.title);
  }

  Future<void> fetchWordCloud(String locationName) async {
    isWordCloudLoading.value = true;
    wordCloudData.clear();
    try {
      final responseData = await _cultureProvider.getWordCloud(locationName);
      if (responseData.isNotEmpty) {
        wordCloudData.assignAll(List<Map<String, dynamic>>.from(responseData));
      } else {
        wordCloudData.assignAll(_getMockWordCloud(locationName));
      }
    } catch (e) {
      wordCloudData.assignAll(_getMockWordCloud(locationName));
    } finally {
      isWordCloudLoading.value = false;
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
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

  void getLiveUserLocation() async {
    try {
      Position position = await _determinePosition();
      userLocation.value = LatLng(position.latitude, position.longitude);
      animateToLocation(userLocation.value!, 16.0);
      checkGeofenceBoundary(userLocation.value!);
    } catch (err) {
      Get.snackbar(
        "GPS Tidak Aktif",
        "Gagal mendapatkan koordinat lokasi GPS fisik rill kamu.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void checkGeofenceBoundary(LatLng userPos) {
    isNearSite.value = false;
    nearSiteItem.value = null;

    for (var item in allMapItems) {
      double distance = calculateDistance(
        userPos.latitude,
        userPos.longitude,
        item.coordinate.latitude,
        item.coordinate.longitude,
      );
      if (distance <= 100.0) {
        isNearSite.value = true;
        nearSiteItem.value = item;
        break;
      }
    }
  }

  Future<void> claimGeofencePoints(String siteId) async {
    try {
      isClaimingGeofence.value = true;
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http.post(
        Uri.parse('$cleanBase/scans/geofence'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_authService.currentToken}',
        },
        body: jsonEncode({
          'site_id': siteId,
          'latitude': userLocation.value?.latitude ?? 0.0,
          'longitude': userLocation.value?.longitude ?? 0.0,
        }),
      );

      if (response.statusCode == 200) {
        isNearSite.value = false;
        nearSiteItem.value = null;
        Get.snackbar(
          "Verifikasi Berhasil!",
          "Kamu berhasil memverifikasi kunjungan dan mendapatkan 100 Poin!",
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          "Gagal Verifikasi",
          "Kamu sudah memverifikasi kunjungan di tempat ini sebelumnya.",
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Koneksi Gagal",
        "Gagal menghubungi server verifikasi.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isClaimingGeofence.value = false;
    }
  }

  List<Map<String, dynamic>> _getMockWordCloud(String name) {
    final cleanName = name.toLowerCase();
    if (cleanName.contains("masjid") || cleanName.contains("mosque")) {
      return [
        {"text": "damai", "value": 45},
        {"text": "sejarah", "value": 38},
        {"text": "megah", "value": 30},
        {"text": "bersih", "value": 26},
        {"text": "alun-alun", "value": 22},
        {"text": "sejuk", "value": 18},
        {"text": "sholat", "value": 15},
        {"text": "tenang", "value": 14},
        {"text": "arsitektur", "value": 12},
        {"text": "heritage", "value": 11},
      ];
    } else if (cleanName.contains("klenteng") || cleanName.contains("kiong")) {
      return [
        {"text": "toleransi", "value": 48},
        {"text": "indah", "value": 42},
        {"text": "budaya", "value": 35},
        {"text": "klenteng", "value": 28},
        {"text": "sejarah", "value": 24},
        {"text": "warna-warni", "value": 18},
        {"text": "klasik", "value": 15},
        {"text": "ibadah", "value": 14},
        {"text": "harmonis", "value": 13},
        {"text": "akulturasi", "value": 12},
      ];
    } else if (cleanName.contains("pantai") || cleanName.contains("alam")) {
      return [
        {"text": "sunset", "value": 52},
        {"text": "pantai", "value": 45},
        {"text": "ramai", "value": 32},
        {"text": "keluarga", "value": 28},
        {"text": "kuliner", "value": 24},
        {"text": "bermain", "value": 18},
        {"text": "ombak", "value": 15},
        {"text": "segar", "value": 14},
        {"text": "wisata", "value": 12},
        {"text": "pasir", "value": 11},
      ];
    } else if (cleanName.contains("tahu") || cleanName.contains("aci")) {
      return [
        {"text": "gurih", "value": 48},
        {"text": "enak", "value": 40},
        {"text": "renyah", "value": 35},
        {"text": "oleh-oleh", "value": 30},
        {"text": "aci", "value": 26},
        {"text": "panas", "value": 20},
        {"text": "cocolan", "value": 16},
        {"text": "nagih", "value": 15},
        {"text": "teh_poci", "value": 14},
        {"text": "murah", "value": 12},
      ];
    } else if (cleanName.contains("birao") || cleanName.contains("scs")) {
      return [
        {"text": "belanda", "value": 45},
        {"text": "sejarah", "value": 40},
        {"text": "kolonial", "value": 34},
        {"text": "megah", "value": 28},
        {"text": "arsitektur", "value": 25},
        {"text": "foto", "value": 20},
        {"text": "landmark", "value": 16},
        {"text": "kuno", "value": 15},
        {"text": "klasik", "value": 14},
        {"text": "kereta", "value": 12},
      ];
    }
    return [
      {"text": "menarik", "value": 28},
      {"text": "budaya", "value": 22},
      {"text": "lokal", "value": 18},
      {"text": "tegal", "value": 15},
      {"text": "wisata", "value": 12},
      {"text": "sejarah", "value": 10},
    ];
  }

  Future<void> openInGoogleMaps(double lat, double lng) async {
    final String coords = "$lat,$lng";
    final iosAppUrl = Uri.parse("comgooglemaps://?q=$coords");
    final androidAppUrl = Uri.parse("google.navigation:q=$coords");
    final webUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$coords",
    );

    try {
      if (await canLaunchUrl(iosAppUrl)) {
        await launchUrl(iosAppUrl);
      } else if (await canLaunchUrl(androidAppUrl)) {
        await launchUrl(androidAppUrl);
      } else {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.snackbar("Kesalahan", "Gagal membuka peta: $e");
    }
  }

  void _handleIncomingArguments() {
    final dynamic args = Get.arguments;
    if (args != null &&
        args is Map<String, dynamic> &&
        args.containsKey('targetId')) {
      final String targetId = args['targetId'];
      final foundItem = allMapItems.firstWhereOrNull(
        (item) => item.id == targetId,
      );

      if (foundItem != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          selectItem(foundItem);
        });
      }
    }
  }
}
