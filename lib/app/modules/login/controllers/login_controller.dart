import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/service/auth_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = Get.find<AuthService>();

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() =>
      isPasswordHidden.value = !isPasswordHidden.value;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Email dan kata sandi wajib diisi.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      await _authService.loginWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } catch (e) {
      final errorMsg = e.toString();
      if (errorMsg.contains('belum dikonfirmasi') ||
          errorMsg.contains('not confirmed')) {
        Get.snackbar(
          'Konfirmasi Tertunda',
          'Silakan lakukan verifikasi kode OTP terlebih dahulu.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        Get.toNamed(
          '/verify-otp',
          arguments: {'email': emailController.text.trim()},
        );
      } else {
        Get.snackbar(
          'Login Gagal',
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      await _authService.loginWithGoogle();
      Get.offAllNamed('/main');
    } catch (e) {
      Get.snackbar(
        'Google Login Gagal',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
