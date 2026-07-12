import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app_config.dart';
import '../service/auth_service.dart';

class UserProvider extends GetConnect {
  @override
  void onInit() {
    baseUrl = AppConfig.baseUrl;

    httpClient.addRequestModifier<dynamic>((request) {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        request.headers['Authorization'] = 'Bearer ${session.accessToken}';
      }
      return request;
    });

    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401 || response.statusCode == 403) {
        if (Get.isRegistered<AuthService>()) {
          Get.find<AuthService>().handleUnauthorizedOrBanned(
            response.statusCode!,
            response.bodyString ?? "",
          );
        }
      }
      return response;
    });

    httpClient.timeout = const Duration(seconds: 15);
  }

  Future<Response> getProfile() => get('/users/profile');

  Future<Response> getStats() => get('/users/stats');

  Future<Response> updateProfile(Map<String, dynamic> data) =>
      put('/users/profile', data);

  Future<Response> claimBadge(String badgeName) =>
      post('/users/claim-badge', {'badge_name': badgeName});
}
