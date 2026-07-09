import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/service/auth_service.dart';

class VerifyOtpController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final otpController = TextEditingController();

  late final String email;
  late final String name;
  late final bool isRecovery;

  var isLoading = false.obs;
  var resendCooldown = 0.obs;
  var isResendEnabled = true.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> args = Get.arguments ?? {};
    email = args['email'] ?? '';
    name = args['name'] ?? '';
    isRecovery = args['isRecovery'] ?? false;
  }

  Future<void> verifyOtp() async {
    final code = otpController.text.trim();
    if (code.isEmpty || code.length < 6) {
      Get.snackbar(
        'Validasi Gagal',
        'Silakan masukkan 6 digit kode verifikasi dengan benar.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      if (isRecovery) {
        await _authService.verifyPasswordResetOtp(email, code);
        Get.snackbar(
          'Verifikasi Berhasil',
          'Silakan ubah kata sandi akun Anda.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offNamed('/update-password');
      } else {
        await _authService.verifyRegisterOtp(email, code);
      }
    } catch (e) {
      Get.snackbar(
        'Verifikasi Gagal',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!isResendEnabled.value) return;

    isLoading.value = true;
    try {
      if (isRecovery) {
        await _authService.sendPasswordResetOtp(email);
      } else {
        await _authService.resendRegisterOtp(email);
      }
      Get.snackbar(
        'OTP Dikirim',
        'Kode verifikasi baru telah dikirimkan ke email Anda.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      _startCooldownTimer();
    } catch (e) {
      Get.snackbar(
        'Gagal Mengirim',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _startCooldownTimer() {
    isResendEnabled.value = false;
    resendCooldown.value = 60;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldown.value > 1) {
        resendCooldown.value--;
      } else {
        isResendEnabled.value = true;
        resendCooldown.value = 0;
        _timer?.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    super.onClose();
  }
}
