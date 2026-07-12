// lib/app/data/service/auth_service.dart

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService extends GetxService {
  final SupabaseClient supabase = Supabase.instance.client;
  late final String apiUrl;

  bool _isRecoveringPassword = false;

  Future<AuthService> init() async {
    apiUrl = dotenv.env['FLASK_API_URL']!;
    final String webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID']!;
    final String? iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'];

    await GoogleSignIn.instance.initialize(
      serverClientId: webClientId,
      clientId: Platform.isIOS ? iosClientId : null,
    );

    supabase.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.passwordRecovery) {
        developer.log("Event Lupa Sandi Terdeteksi");
        _isRecoveringPassword = true;
        Get.toNamed('/update-password');
      } else if (event == AuthChangeEvent.signedIn && session != null) {
        developer.log("Event Pengguna Masuk/Terverifikasi Terdeteksi");

        if (_isRecoveringPassword) {
          developer.log(
            "Mengalihkan ke halaman pembaruan sandi tanpa melakukan sinkronisasi backend.",
          );
          _isRecoveringPassword = false;
          Get.offAllNamed('/update-password');
          return;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          Get.dialog(
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFE67E22)),
            ),
            barrierDismissible: false,
            barrierColor: Colors.white.withOpacity(0.8),
          );

          try {
            final user = session.user;
            final name =
                user.userMetadata?['full_name'] ?? user.email?.split('@')[0];

            await _syncUserToBackend(session.accessToken, name, 'email');
            developer.log("Sinkronisasi berhasil!");

            Get.offAllNamed('/main');
          } catch (e) {
            developer.log("Gagal sinkronisasi otomatis: $e");
            Get.back();
            Get.snackbar(
              'Kesalahan Sistem',
              'Gagal menyinkronkan data: $e',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        });
      }
    });

    return this;
  }

  // Menyediakan mekanisme tunggu yang andal untuk pemulihan sesi asinkronus Supabase
  Future<void> waitForSession() async {
    if (supabase.auth.currentSession != null) return;
    for (int i = 0; i < 30; i++) {
      if (supabase.auth.currentSession != null) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> registerWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );

      if (res.session != null) {
        developer.log("=== TOKEN PENDAFTARAN UTUH ===");
        developer.log(res.session!.accessToken);
        developer.log("===============================");
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

  Future<void> verifyRegisterOtp(String email, String token) async {
    try {
      final AuthResponse res = await supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.signup,
      );

      if (res.session == null) {
        throw 'Gagal mendapatkan sesi aktif setelah verifikasi.';
      }
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Terjadi kesalahan sistem: $e';
    }
  }

  Future<void> resendRegisterOtp(String email) async {
    try {
      await supabase.auth.resend(type: OtpType.signup, email: email);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Terjadi kesalahan sistem: $e';
    }
  }

  Future<void> sendPasswordResetOtp(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      if (e.message.contains('not found')) {
        throw 'Email tidak terdaftar di sistem kami.';
      }
      throw 'Gagal mengirim OTP reset sandi: ${e.message}';
    } catch (e) {
      throw 'Terjadi kesalahan sistem: $e';
    }
  }

  Future<void> verifyPasswordResetOtp(String email, String token) async {
    try {
      _isRecoveringPassword = true;
      final AuthResponse res = await supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.recovery,
      );

      if (res.session == null) {
        throw 'Gagal mendapatkan sesi aktif untuk pemulihan kata sandi.';
      }
    } on AuthException catch (e) {
      _isRecoveringPassword = false;
      throw e.message;
    } catch (e) {
      _isRecoveringPassword = false;
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
        developer.log("=== TOKEN MASUK UTUH ===");
        developer.log(res.session!.accessToken);
        developer.log("=========================");
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
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw 'Gagal mendapatkan ID Token dari Google.';
      }

      final authorization = await googleUser.authorizationClient
          .authorizationForScopes(['email', 'profile']);
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
        developer.log("=== TOKEN GOOGLE UTUH ===");
        developer.log(res.session!.accessToken);
        developer.log("=========================");
        await _syncUserToBackend(
          res.session!.accessToken,
          googleUser.displayName ?? 'Pengguna Google',
          'google',
          googleUser.photoUrl,
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

  Future<void> _syncUserToBackend(
    String token,
    String? name,
    String provider, [
    String? profilePicture,
  ]) async {
    try {
      String? oneSignalId;
      final pushSubscription = OneSignal.User.pushSubscription;
      if (pushSubscription.optedIn == true && pushSubscription.id != null) {
        oneSignalId = pushSubscription.id;
      }

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
          'onesignal_id': oneSignalId,
        }),
      );

      if (response.statusCode != 200) {
        throw 'Gagal menyinkronkan data pengguna dengan server Flask.';
      }
    } catch (e) {
      throw 'Kesalahan sinkronisasi server: $e';
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'culturaltegal://login-callback',
      );
    } on AuthException catch (e) {
      if (e.message.contains('not found')) {
        throw 'Email tidak terdaftar di sistem kami.';
      }
      throw 'Gagal mengirim email reset sandi: ${e.message}';
    } catch (e) {
      throw 'Terjadi kesalahan sistem: $e';
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      throw 'Gagal memperbarui kata sandi: ${e.message}';
    } catch (e) {
      throw 'Terjadi kesalahan sistem: $e';
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    await GoogleSignIn.instance.signOut();
    Get.offAllNamed('/login');
  }

  bool get isLoggedIn => supabase.auth.currentSession != null;

  String? get currentToken => supabase.auth.currentSession?.accessToken;

  String? get currentUserId => supabase.auth.currentUser?.id;
}
