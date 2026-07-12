import 'package:get/get.dart';
import '../controllers/scan_history_controller.dart';

class ScanHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanHistoryController>(() => ScanHistoryController());
  }
}
