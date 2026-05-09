import 'package:get/get.dart';

import 'package:cultural_tegal/app/modules/login/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
