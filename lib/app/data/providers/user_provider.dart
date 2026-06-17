import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app_config.dart';

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

    httpClient.timeout = const Duration(seconds: 10);
  }

  Future<Response> getProfile() => get('/users/profile');
}
