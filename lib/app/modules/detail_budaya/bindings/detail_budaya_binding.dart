import 'package:get/get.dart';
import '../controllers/detail_budaya_controller.dart';

class DetailBudayaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailBudayaController>(
          () => DetailBudayaController(),
    );
  }
}