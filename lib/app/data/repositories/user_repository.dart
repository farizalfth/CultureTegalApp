import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserRepository {
  final UserProvider provider;
  UserRepository(this.provider);

  Future<UserModel?> getUserProfile() async {
    final response = await provider.getProfile();
    if (response.status.isOk) {
      return UserModel.fromJson(response.body['data']);
    } else {
      return null;
    }
  }
}
