import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService extends GetxService {
  final SupabaseClient supabase = Supabase.instance.client;
  late final String apiUrl;

  Future<AuthService> init() async {
    apiUrl = dotenv.env['FLASK_API_URL']!;

    final String webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID']!;

    await GoogleSignIn.instance.initialize(
      serverClientId: webClientId,
    );

    return this;
  }

  Future<void> registerWithEmail(String email, String password, String name) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );

      if (res.session != null) {
        print(res.session!.accessToken); // cek jwt
        await _syncUserToBackend(res.session!.accessToken, name, 'email');
      }
    } on AuthException catch (e) {
      if (e.message.contains('already registered')) {
        throw 'Email ini sudah terdaftar. Silakan gunakan email lain.';
      } else if (e.message.contains('Password should be')) {
        throw 'Kata sandi minimal harus 6 karakter.';
      }
      throw e.message;
    } catch (e) {
      throw 'Terjadi kesalahan sistem: $e';
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.session != null) {
        print(res.session!.accessToken); // cek jwt
        await _syncUserToBackend(res.session!.accessToken, null, 'email');
      }
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        throw 'Email atau kata sandi salah.';
      } else if (e.message.contains('Email not confirmed')) {
        throw 'Email belum dikonfirmasi.';
      }
      throw e.message;
    } catch (e) {
      throw 'Terjadi kesalahan sistem: $e';
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw 'Gagal mendapatkan ID Token dari Google.';
      }

      final authorization = await googleUser.authorizationClient.authorizationForScopes(['email', 'profile']);
      final String? accessToken = authorization?.accessToken;

      if (accessToken == null) {
        throw 'Gagal mendapatkan Access Token dari Google.';
      }

      final AuthResponse res = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (res.session != null) {
        print(res.session!.accessToken); // cek jwt
        await _syncUserToBackend(
            res.session!.accessToken,
            googleUser.displayName ?? 'Pengguna Google',
            'google',
            googleUser.photoUrl
        );
      }
    } on AuthException catch (e) {
      await GoogleSignIn.instance.signOut();
      throw 'Akses ditolak oleh server otentikasi: ${e.message}';
    } catch (e) {
      await GoogleSignIn.instance.signOut();
      throw e.toString();
    }
  }

  Future<void> _syncUserToBackend(String token, String? name, String provider, [String? profilePicture]) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/sync'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nama': name,
          'provider': provider,
          'profile_picture': profilePicture,
        }),
      );

      if (response.statusCode != 200) {
        throw 'Gagal menyinkronkan data pengguna dengan server Flask.';
      }
    } catch (e) {
      throw 'Kesalahan sinkronisasi server: $e';
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    await GoogleSignIn.instance.signOut();
    Get.offAllNamed('/login');
  }

  bool get isLoggedIn => supabase.auth.currentSession != null;
  String? get currentToken => supabase.auth.currentSession?.accessToken;
}