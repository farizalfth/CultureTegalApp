import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/news_model.dart';
import '../service/auth_service.dart';

class NewsProvider extends GetConnect {
  @override
  void onInit() {
    final String apiHost =
        dotenv.env['FLASK_API_URL'] ?? 'http://127.0.0.1:5000';

    httpClient.baseUrl = apiHost;
    httpClient.timeout = const Duration(seconds: 10);

    httpClient.addRequestModifier<dynamic>((request) async {
      request.headers['Accept'] = 'application/json';

      String? token;
      try {
        if (Get.isRegistered<AuthService>()) {
          token = Get.find<AuthService>().currentToken;
        } else {
          token = Supabase.instance.client.auth.currentSession?.accessToken;
        }
      } catch (_) {}

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    super.onInit();
  }

  Future<Map<String, dynamic>> getNews({
    String? category,
    String? search,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      String path = '/news?page=$page&per_page=$perPage';
      if (category != null && category != "Semua") {
        path += '&kategori=${Uri.encodeComponent(category)}';
      }
      if (search != null && search.isNotEmpty) {
        path += '&search=${Uri.encodeComponent(search)}';
      }

      final response = await get(path);

      if (response.status.hasError) {
        throw Exception("Gagal menghubungi server: ${response.statusText}");
      }

      final Map<String, dynamic>? body = response.body;
      if (body != null && body['status'] == 'success') {
        return body['data'] ?? {};
      } else {
        throw Exception(body?['message'] ?? "Format respon tidak valid");
      }
    } catch (e) {
      rethrow;
    }
  }
}
