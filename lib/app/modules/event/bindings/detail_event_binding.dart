import 'package:get/get.dart';
import '../controllers/detail_event_controller.dart';

class DetailEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailEventController>(
          () => DetailEventController(),
    );
  }
}