import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../data/providers/user_provider.dart';
import '../data/repositories/user_repository.dart';
import '../data/service/user_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserProvider());
    Get.lazyPut(() => UserRepository(Get.find<UserProvider>()));

    Get.put(UserService(Get.find<UserRepository>()));
  }
}
