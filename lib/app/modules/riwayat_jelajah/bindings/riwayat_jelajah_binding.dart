import 'package:get/get.dart';
import '../controllers/riwayat_jelajah_controller.dart';

class RiwayatJelajahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatJelajahController>(() => RiwayatJelajahController());
  }
}
