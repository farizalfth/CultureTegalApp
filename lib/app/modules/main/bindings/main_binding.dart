import 'package:cultural_tegal/app/modules/event/controllers/event_controller.dart';
import 'package:get/get.dart';
import '../../../data/providers/user_provider.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/service/user_service.dart';
import '../../event/controllers/detail_event_controller.dart';
import '../../explore/controllers/explore_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../umkm/controllers/umkm_controller.dart';
import '../controllers/controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ExploreController>(() => ExploreController());
    Get.lazyPut<DetailEventController>(() => DetailEventController());
    Get.lazyPut<EventController>(() => EventController());
    Get.lazyPut<UmkmController>(() => UmkmController());
  }
}
