import 'package:get/get.dart';

class MainController extends GetxController {
  var currentIndex = 0.obs;
  var isFabExpanded = false.obs;

  void toggleFab() {
    isFabExpanded.value = !isFabExpanded.value;
  }

  void goToUmkm() => print("Navigasi ke UMKM");
  void goToScan() => print("Navigasi ke Scan");
  void goToMap() => print("Navigasi ke Map");
}