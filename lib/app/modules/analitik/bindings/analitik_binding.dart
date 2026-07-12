import 'package:get/get.dart';
import '../controllers/analitik_controller.dart';

class AnalitikBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalitikController>(() => AnalitikController());
  }
}
