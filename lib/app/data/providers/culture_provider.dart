import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/culture_model.dart';
import '../service/auth_service.dart';

class CultureProvider extends GetConnect {
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
      } catch (e) {
        token = null;
      }

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      return request;
    });

    super.onInit();
  }

  Future<List<CultureModel>> getCultures({String? category}) async {
    try {
      final String path = category != null && category != "Semua"
          ? '/explore?kategori=$category'
          : '/explore';

      final response = await get(path);

      if (response.status.hasError) {
        throw Exception("Gagal menghubungi server: ${response.statusText}");
      }

      final Map<String, dynamic>? body = response.body;
      if (body != null && body['status'] == 'success') {
        final List<dynamic> rawData = body['data'] ?? [];
        return rawData
            .map((item) => CultureModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(body?['message'] ?? "Format respon tidak valid");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> postReview(String siteId, double rating, String comment, {List<String>? reviewImagesBase64}) async {
    try {
      final response = await post('/explore/$siteId/reviews', {
        'rating': rating,
        'komentar': comment,
        'review_images_base64': reviewImagesBase64 ?? [],
      });

      if (response.status.hasError) {
        throw Exception(response.body?['message'] ?? "Gagal mengirim ulasan");
      }

      final Map<String, dynamic>? body = response.body;
      return body != null && body['status'] == 'success';
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> putReview(String siteId, double rating, String comment, {List<String>? reviewImagesBase64}) async {
    try {
      final response = await put('/explore/$siteId/reviews', {
        'rating': rating,
        'komentar': comment,
        'review_images_base64': reviewImagesBase64 ?? [],
      });

      if (response.status.hasError) {
        throw Exception(response.body?['message'] ?? "Gagal memperbarui ulasan");
      }

      final Map<String, dynamic>? body = response.body;
      return body != null && body['status'] == 'success';
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteReview(String siteId) async {
    try {
      final response = await delete('/explore/$siteId/reviews');

      if (response.status.hasError) {
        throw Exception(response.body?['message'] ?? "Gagal menghapus ulasan");
      }

      final Map<String, dynamic>? body = response.body;
      return body != null && body['status'] == 'success';
    } catch (e) {
      rethrow;
    }
  }
}
