import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/service/auth_service.dart';

class UpdatePasswordController extends GetxController {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  final AuthService _authService = Get.find<AuthService>();

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> updatePassword() async {
    final newPass = newPasswordController.text;
    final confirmPass = confirmPasswordController.text;

    if (newPass.length < 6) {
      Get.snackbar(
        'Peringatan',
        'Kata sandi minimal 6 karakter.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    if (newPass != confirmPass) {
      Get.snackbar(
        'Peringatan',
        'Konfirmasi kata sandi tidak cocok.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _authService.updatePassword(newPass);

      Get.snackbar(
        'Berhasil',
        'Kata sandi berhasil diperbarui.',
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
      );

      Get.offAllNamed('/main');
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
