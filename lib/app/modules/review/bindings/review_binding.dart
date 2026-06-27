import 'package:get/get.dart';
import '../../../data/providers/culture_provider.dart';
import '../../../data/providers/umkm_provider.dart';
import '../controllers/review_controller.dart';

class ReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CultureProvider>(() => CultureProvider());
    Get.lazyPut<UmkmProvider>(() => UmkmProvider());
    Get.lazyPut<ReviewController>(() => ReviewController());
  }
}
