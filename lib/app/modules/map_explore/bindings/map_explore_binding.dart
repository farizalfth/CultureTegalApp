import 'package:get/get.dart';
import '../../../data/providers/culture_provider.dart';
import '../../../data/providers/event_provider.dart';
import '../../../data/providers/umkm_provider.dart';
import '../controllers/map_explore_controller.dart';

class MapExploreBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CultureProvider>()) {
      Get.lazyPut<CultureProvider>(() => CultureProvider());
    }
    if (!Get.isRegistered<EventProvider>()) {
      Get.lazyPut<EventProvider>(() => EventProvider());
    }
    if (!Get.isRegistered<UmkmProvider>()) {
      Get.lazyPut<UmkmProvider>(() => UmkmProvider());
    }

    Get.lazyPut<MapExploreController>(() => MapExploreController());
  }
}
