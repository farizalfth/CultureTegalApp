import 'package:get/get.dart';

import '../controllers/pencapaian_controller.dart';

class PencapaianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PencapaianController>(
      () => PencapaianController(),
    );
  }
}
