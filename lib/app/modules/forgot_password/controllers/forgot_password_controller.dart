import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/service/auth_service.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;

  final AuthService _authService = Get.find<AuthService>();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      Get.snackbar(
        'Kesalahan',
        'Masukkan alamat email yang valid.',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      isLoading.value = true;

      await _authService.sendPasswordResetEmail(email);

      Get.back();

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'Email Terkirim',
          'Tautan pemulihan telah dikirim ke kotak masuk atau folder spam Anda.',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );
      });

    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}