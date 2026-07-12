import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifikasiController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> notifications =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLocalNotifications();
  }

  Future<void> loadLocalNotifications() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> storedNotifs =
          prefs.getStringList('local_notifications') ?? [];

      List<Map<String, dynamic>> parsedList = [];
      for (String item in storedNotifs) {
        parsedList.add(jsonDecode(item));
      }

      if (parsedList.isEmpty) {
        parsedList = [
          {
            "title": "Selamat Datang di Tegal Culture!",
            "body":
                "Ayo mulai jelajahi kebudayaan, kuliner, dan event menarik di Kota Tegal. Kumpulkan poin dan dapatkan lencana eksklusif!",
            "time": DateTime.now().toIso8601String(),
          },
        ];
      }

      notifications.assignAll(parsedList);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('local_notifications');
      notifications.clear();
      Get.snackbar("Sukses", "Kotak masuk notifikasi telah dibersihkan.");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String formatTime(String isoString) {
    try {
      final DateTime parsed = DateTime.parse(isoString);
      final Duration diff = DateTime.now().difference(parsed);

      if (diff.inDays > 0) return "${diff.inDays} hari lalu";
      if (diff.inHours > 0) return "${diff.inHours} jam lalu";
      if (diff.inMinutes > 0) return "${diff.inMinutes} menit lalu";
      return "Baru saja";
    } catch (e) {
      return "Baru saja";
    }
  }
}
