import 'package:get/get.dart';
import '../../../data/providers/event_provider.dart';
import '../controllers/event_list_controller.dart';

class EventListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventProvider>(() => EventProvider());
    Get.lazyPut<EventListController>(() => EventListController());
  }
}
