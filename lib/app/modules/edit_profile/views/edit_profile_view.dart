import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/app_colors.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 35),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                image: DecorationImage(
                  image: AssetImage("assets/images/beranda/cover_atas.png"),
                  fit: BoxFit.cover,
                  opacity: .15,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Edit Profil",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Obx(() {
                          final user = controller.userService.user.value;
                          final String? profilePic = user?.profilePicture;
                          final String? localPath =
                              controller.localImagePath.value;

                          ImageProvider imageProvider;
                          if (localPath != null) {
                            imageProvider = FileImage(File(localPath));
                          } else if (profilePic != null &&
                              profilePic.isNotEmpty) {
                            imageProvider = CachedNetworkImageProvider(
                              profilePic,
                            );
                          } else {
                            imageProvider = const AssetImage(
                              "assets/images/register/register_icon.png",
                            );
                          }

                          return CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: imageProvider,
                          );
                        }),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: controller.changePhoto,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Ubah Foto Profil",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildField(
                    title: "Nama Lengkap",
                    icon: Icons.person_outline,
                    textController: controller.nameController,
                  ),
                  const SizedBox(height: 18),
                  _buildField(
                    title: "Email (Read-only)",
                    icon: Icons.email_outlined,
                    textController: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Obx(() {
                      final bool isSaving = controller.isLoading.value;
                      return ElevatedButton.icon(
                        onPressed: isSaving
                            ? null
                            : () => controller.saveProfile(),
                        icon: isSaving
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.save_rounded,
                                color: Colors.white,
                              ),
                        label: Text(
                          isSaving ? "Menyimpan..." : "Simpan Perubahan",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close_rounded),
                      label: const Text(
                        "Batal",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String title,
    required IconData icon,
    required TextEditingController textController,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
            prefixIcon: Icon(icon, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.accent, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
