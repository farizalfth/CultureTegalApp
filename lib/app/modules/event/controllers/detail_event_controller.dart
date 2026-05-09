import 'package:get/get.dart';
import '../../../data/models/event_model.dart';

class DetailEventController extends GetxController {
  late EventModel event;
  final isSaved = false.obs;

  @override
  void onInit() {
    super.onInit();
    event = Get.arguments as EventModel;
  }

  void toggleSave() {
    isSaved.value = !isSaved.value;
  }
}