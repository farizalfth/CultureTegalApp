import 'package:get/get.dart';
import '../../../data/providers/culture_provider.dart';
import '../controllers/explore_controller.dart';

class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CultureProvider>(() => CultureProvider());
    Get.lazyPut<ExploreController>(() => ExploreController());
  }
}
