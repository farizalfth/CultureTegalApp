import 'package:get/get.dart';
import '../../../data/providers/culture_provider.dart';
import '../../../data/providers/event_provider.dart';
import '../../../data/providers/news_provider.dart';
import '../../../data/providers/umkm_provider.dart';
import '../../event/controllers/detail_event_controller.dart';
import '../../event/controllers/event_controller.dart';
import '../../explore/controllers/explore_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../main/controllers/controller.dart';
import '../../umkm/controllers/umkm_controller.dart';
import '../controllers/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CultureProvider>(() => CultureProvider());
    Get.lazyPut<EventProvider>(() => EventProvider());
    Get.lazyPut<NewsProvider>(() => NewsProvider());
    Get.lazyPut<UmkmProvider>(() => UmkmProvider());
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ExploreController>(() => ExploreController());
    Get.lazyPut<DetailEventController>(() => DetailEventController());
    Get.lazyPut<EventController>(() => EventController());
    Get.lazyPut<UmkmController>(() => UmkmController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
