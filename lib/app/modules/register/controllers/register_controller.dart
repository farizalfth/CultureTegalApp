import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/service/auth_service.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthService _authService = Get.find<AuthService>();

  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;
  final RxBool isAgree = true.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() =>
      isPasswordHidden.value = !isPasswordHidden.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  void toggleAgree(bool? value) => isAgree.value = value ?? false;

  Future<void> register() async {
    if (!isAgree.value) {
      Get.snackbar(
        'Peringatan',
        'Anda harus menyetujui Syarat & Ketentuan',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Kata sandi tidak cocok',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua kolom wajib diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      await _authService.registerWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
      );

      Get.snackbar(
        'Pendaftaran Berhasil',
        'Silakan cek kode OTP yang telah dikirimkan ke email Anda.',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
      );

      Get.toNamed(
        '/verify-otp',
        arguments: {
          'email': emailController.text.trim(),
          'name': nameController.text.trim(),
        },
      );
    } catch (e) {
      Get.snackbar(
        'Pendaftaran Gagal',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerWithGoogle() async {
    if (!isAgree.value) {
      Get.snackbar(
        'Peringatan',
        'Anda harus menyetujui Syarat & Ketentuan',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      await _authService.loginWithGoogle();
      Get.offAllNamed('/main');
    } catch (e) {
      Get.snackbar(
        'Google Register Gagal',
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
