import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/service/user_service.dart';
import '../../../data/service/auth_service.dart';

class EditProfileController extends GetxController {
  final UserRepository _userRepository = Get.find<UserRepository>();
  final UserService userService = UserService.to;

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxnString localImagePath = RxnString();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  void loadProfileData() {
    final user = userService.user.value;
    nameController.text = user?.name ?? '';
    emailController.text = user?.email ?? '';
  }

  Future<void> changePhoto() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );
      if (file != null) {
        localImagePath.value = file.path;
      }
    } catch (e) {
      Get.snackbar(
        "Gagal Memilih Foto",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> saveProfile() async {
    final String name = nameController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Nama lengkap wajib diisi.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final String? token = Get.find<AuthService>().currentToken;
      if (token == null) {
        throw Exception("Sesi otentikasi kedaluwarsa. Silakan login kembali.");
      }

      if (localImagePath.value != null) {
        final newPic = await _userRepository.updateProfilePicture(
          localImagePath.value!,
          token,
        );
        if (newPic == null) {
          throw Exception("Gagal mengunggah foto profil ke server.");
        }
      }

      final bool success = await _userRepository.updateProfile(name);
      if (success) {
        await _userRepository.claimActionBadge("Identitas Baru");

        await userService.refreshUserData();
        Get.back();
        Get.snackbar(
          "Sukses",
          "Profil Anda berhasil diperbarui.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception("Gagal menyinkronkan data profil.");
      }
    } catch (e) {
      Get.snackbar(
        "Pembaruan Gagal",
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
    super.onClose();
  }
}
