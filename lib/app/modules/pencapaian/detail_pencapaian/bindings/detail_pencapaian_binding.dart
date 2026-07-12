import 'package:get/get.dart';

import '../controllers/detail_pencapaian_controller.dart';

class DetailPencapaianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPencapaianController>(
      () => DetailPencapaianController(),
    );
  }
}
