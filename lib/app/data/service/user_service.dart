import 'package:get/get.dart';
import '../models/user_model.dart';

class UserService extends GetxService {
  final user = UserModel(
    id: "u1",
    name: "Nadhif Basalamah",
    email: "nadhif.b@email.com",
    profilePicture: "https://i.pinimg.com/236x/e5/7d/60/e57d6075d73f490fba9d8c61c14340f3.jpg",
    points: "1.250",
  ).obs;

  static UserService get to => Get.find();
}