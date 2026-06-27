import 'package:get/get.dart';
import '../../../data/providers/umkm_provider.dart';
import '../controllers/umkm_detail_controller.dart';

class UmkmDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UmkmProvider>(() => UmkmProvider());
    Get.lazyPut<UmkmDetailController>(() => UmkmDetailController());
  }
}
