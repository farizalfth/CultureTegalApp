import 'package:get/get.dart';
import '../../../data/models/news_model.dart';

class NewsDetailController extends GetxController {
  late NewsModel news;

  @override
  void onInit() {
    super.onInit();
    news = Get.arguments as NewsModel;
  }
}