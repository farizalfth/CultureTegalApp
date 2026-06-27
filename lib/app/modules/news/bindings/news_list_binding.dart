import 'package:get/get.dart';
import '../../../data/providers/news_provider.dart';
import '../controllers/news_list_controller.dart';

class NewsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsProvider>(() => NewsProvider());
    Get.lazyPut<NewsListController>(() => NewsListController());
  }
}
