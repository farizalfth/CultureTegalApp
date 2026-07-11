import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/models/culture_model.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/umkm_model.dart';
import '../../../data/models/map_item_model.dart';
import '../../../data/providers/culture_provider.dart';
import '../../../data/providers/event_provider.dart';
import '../../../data/providers/umkm_provider.dart';

class MapExploreController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();

  final CultureProvider _cultureProvider = Get.find<CultureProvider>();
  final EventProvider _eventProvider = Get.find<EventProvider>();
  final UmkmProvider _umkmProvider = Get.find<UmkmProvider>();

  final RxBool isLoading = false.obs;
  final RxString searchQuery = "".obs;
  final Rxn<MapItem> selectedItem = Rxn<MapItem>();
  final RxString activeFilter = "Semua".obs;

  final List<MapItem> allMapItems = <MapItem>[];
  final RxList<MapItem> filteredMapItems = <MapItem>[].obs;

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
    _animationController?.dispose();
    searchController.dispose();
    mapController.dispose();
    super.onClose();
  }

  Future<void> loadAllMapData() async {
    try {
      isLoading.value = true;
      allMapItems.clear();

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
    applyFilters();
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
