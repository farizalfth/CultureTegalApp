import 'package:get/get.dart';
import '../../../data/models/models.dart';

class ReviewController extends GetxController {
  late CultureModel culture;

  @override
  void onInit() {
    super.onInit();
    culture = Get.arguments as CultureModel;
  }

  double get averageRating {
    if (culture.reviews.isEmpty) return 0.0;
    double total = 0;
    for (var review in culture.reviews) {
      total += review.rating;
    }
    return total / culture.reviews.length;
  }

  int countStars(int star) {
    return culture.reviews.where((r) => r.rating.toInt() == star).length;
  }

  double starPercentage(int star) {
    if (culture.reviews.isEmpty) return 0.0;
    return countStars(star) / culture.reviews.length;
  }
}