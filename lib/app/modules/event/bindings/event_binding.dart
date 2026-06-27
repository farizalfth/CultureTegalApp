import 'package:get/get.dart';
import '../../../data/providers/event_provider.dart';
import '../../../data/providers/news_provider.dart';
import '../controllers/event_controller.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventProvider>(() => EventProvider());
    Get.lazyPut<NewsProvider>(() => NewsProvider());
    Get.lazyPut<EventController>(() => EventController());
  }
}
