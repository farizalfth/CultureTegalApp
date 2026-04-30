import 'package:get/get.dart';

class HomeController extends GetxController {
  // Fungsi untuk pindah ke halaman Scan Budaya
  void goToScan() {
    // Pastikan kamu sudah membuat route 'scan' di app_pages.dart
    Get.toNamed('/scan'); 
  }
}