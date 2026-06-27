import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../service/auth_service.dart';

class UmkmProvider {
  final String baseUrl = dotenv.env['FLASK_API_URL'] ?? '';
  final AuthService _authService = Get.find<AuthService>();

  Future<Map<String, dynamic>> getUmkms({
    String? category,
    String? search,
    String? sort,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      String url = '$cleanBase/umkm?page=$page&per_page=$perPage';
      if (category != null && category != 'Semua') {
        url += '&kategori=${Uri.encodeComponent(category)}';
      }
      if (search != null && search.isNotEmpty) {
        url += '&search=${Uri.encodeComponent(search)}';
      }
      if (sort != null && sort != 'Semua') {
        url += '&sort=${Uri.encodeComponent(sort)}';
      }
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw 'Gagal mengambil data dari server Flask.';
      }
    } catch (e) {
      throw 'Kesalahan koneksi provider: $e';
    }
  }

  Future<Map<String, dynamic>> getUmkmReviews(
    String umkmId, {
    int page = 1,
    int perPage = 5,
  }) async {
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http.get(
        Uri.parse(
          '$cleanBase/umkm/$umkmId/reviews/list?page=$page&per_page=$perPage',
        ),
        headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        return body['data'] ?? {};
      } else {
        throw 'Gagal memuat ulasan produk.';
      }
    } catch (e) {
      throw 'Kesalahan koneksi: $e';
    }
  }

  Future<bool> postReview(
    String umkmId,
    double rating,
    String comment, {
    List<String>? reviewImagesBase64,
  }) async {
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final String? token = _authService.currentToken;
      final response = await http.post(
        Uri.parse('$cleanBase/umkm/$umkmId/reviews'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'rating': rating,
          'komentar': comment,
          'review_images_base64': reviewImagesBase64 ?? [],
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        throw body['message'] ?? 'Gagal mengirim ulasan';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> putReview(
    String umkmId,
    double rating,
    String comment, {
    List<String>? reviewImagesBase64,
  }) async {
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final String? token = _authService.currentToken;
      final response = await http.put(
        Uri.parse('$cleanBase/umkm/$umkmId/reviews'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'rating': rating,
          'komentar': comment,
          'review_images_base64': reviewImagesBase64 ?? [],
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        throw body['message'] ?? 'Gagal memperbarui ulasan';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> deleteReview(String umkmId) async {
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final String? token = _authService.currentToken;
      final response = await http.delete(
        Uri.parse('$cleanBase/umkm/$umkmId/reviews'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        throw body['message'] ?? 'Gagal menghapus ulasan';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
