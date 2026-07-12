import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  //==========================
  // Text Controllers
  //==========================

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();

  //==========================
  // Observable
  //==========================

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    loadProfile();
  }

  //==========================
  // Load Data
  //==========================

  void loadProfile() {
    // sementara dummy data

    nameController.text = "Nadhif Basalamah";
    usernameController.text = "nadhif.bas";
    emailController.text = "nadhif@email.com";
    phoneController.text = "081234567890";
    bioController.text =
        "Menjelajahi sejarah dan budaya Tegal melalui aplikasi Tegal Culture.";
  }

  //==========================
  // Change Photo
  //==========================

  Future<void> changePhoto() async {
    Get.snackbar(
      "Info",
      "Fitur ganti foto akan segera tersedia.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  //==========================
  // Save Profile
  //==========================

  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Nama lengkap tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (usernameController.text.trim().isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Username tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Email tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Nomor telepon tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    await Future.delayed(
      const Duration(seconds: 2),
    );

    isLoading.value = false;

    Get.snackbar(
      "Berhasil",
      "Profil berhasil diperbarui",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.back();
  }

  //==========================
  // Dispose
  //==========================

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();

    super.onClose();
  }
}