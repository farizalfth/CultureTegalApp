import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserRepository {
  final UserProvider provider;

  UserRepository(this.provider);

  final String baseUrl = dotenv.env['FLASK_API_URL'] ?? '';

  Future<UserModel?> getUserProfile() async {
    final response = await provider.getProfile();
    if (response.status.isOk) {
      return UserModel.fromJson(response.body['data']);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserStats() async {
    final response = await provider.getStats();
    if (response.status.isOk) {
      return response.body['data'] as Map<String, dynamic>?;
    } else {
      return null;
    }
  }

  Future<bool> updateProfile(String name) async {
    final response = await provider.updateProfile({
      'nama': name,
      'no_telp': '',
    });
    return response.status.isOk;
  }

  Future<void> claimActionBadge(String badgeName) async {
    try {
      await provider.claimBadge(badgeName);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String?> updateProfilePicture(String filePath, String token) async {
    try {
      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$cleanBase/users/profile/picture'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        return body['data']?['profile_picture']?.toString();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
