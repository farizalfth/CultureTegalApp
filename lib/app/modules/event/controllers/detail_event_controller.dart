import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/event_model.dart';
import '../../../data/service/auth_service.dart';
import '../../../data/app_colors.dart';

class DetailEventController extends GetxController {
  final String baseUrl = dotenv.env['FLASK_API_URL'] ?? '';
  final AuthService _authService = Get.find<AuthService>();

  late EventModel event;
  final isSaved = false.obs;

  @override
  void onInit() {
    super.onInit();
    event = Get.arguments as EventModel;
    _checkInitialSavedState();
  }

  void _checkInitialSavedState() async {
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
        final List<dynamic> events = body['data']?['events'] ?? [];
        final isFav = events.any((e) => e['id'] == event.id);
        isSaved.value = isFav;
      }
    } catch (_) {}
  }

  Future<void> toggleSave() async {
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http.post(
        Uri.parse('$cleanBase/users/favorites/toggle'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_authService.currentToken}',
        },
        body: json.encode({'target_type': 'event', 'target_id': event.id}),
      );

      if (response.statusCode == 200) {
        isSaved.value = !isSaved.value;
        Get.snackbar(
          isSaved.value ? "Tersimpan" : "Dihapus",
          isSaved.value
              ? "Event berhasil disimpan ke agenda favorit."
              : "Event dihapus dari agenda favorit.",
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Kesalahan", "Gagal menyimpan agenda event.");
    }
  }

  Future<void> openGoogleMapsRouting() async {
    double userLat = -6.8672;
    double userLng = 109.1380;
    try {
      Position position = await Geolocator.getCurrentPosition();
      userLat = position.latitude;
      userLng = position.longitude;
    } catch (_) {}

    final String destinationCoords = "${event.latitude},${event.longitude}";
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
}
