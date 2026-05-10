import 'package:get/get.dart';
import '../controllers/news_list_controller.dart';

class NewsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsListController>(() => NewsListController());
  }
}
