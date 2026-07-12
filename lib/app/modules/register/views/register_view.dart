import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isShortScreen = context.height < 750;
    final double safeBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: isShortScreen
                  ? const BouncingScrollPhysics()
                  : const ClampingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  context.width * 0.07,
                  isShortScreen ? 15 : 20,
                  context.width * 0.07,
                  (isShortScreen ? 15 : 20) + safeBottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Buat Akun Baru",
                                style: TextStyle(
                                  fontSize: context.responsiveValue(
                                    mobile: 24.0,
                                    watch: 20.0,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Bergabunglah dan Mulai jelajahi budaya Kota Tegal.",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          'assets/images/register/cover_atas.png',
                          width: isShortScreen ? 60 : 70,
                          height: isShortScreen ? 60 : 70,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.account_balance,
                                size: 40,
                                color: AppColors.primary,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: isShortScreen ? 15 : 20),
                    _buildInputField(
                      Icons.person_outline,
                      "Nama Lengkap",
                      "Masukkan nama lengkap",
                      controller.nameController,
                      isShortScreen,
                    ),
                    _buildInputField(
                      Icons.email_outlined,
                      "Email",
                      "Masukkan email aktif",
                      controller.emailController,
                      isShortScreen,
                    ),
                    Obx(
                      () => _buildInputField(
                        Icons.lock_outline,
                        "Kata Sandi",
                        "Buat kata sandi",
                        controller.passwordController,
                        isShortScreen,
                        isPass: true,
                        obscureText: controller.isPasswordHidden.value,
                        onSuffixTap: () =>
                            controller.togglePasswordVisibility(),
                      ),
                    ),
                    Obx(
                      () => _buildInputField(
                        Icons.lock_reset_outlined,
                        "Konfirmasi Kata Sandi",
                        "Ulangi kata sandi",
                        controller.confirmPasswordController,
                        isShortScreen,
                        isPass: true,
                        obscureText: controller.isConfirmPasswordHidden.value,
                        onSuffixTap: () =>
                            controller.toggleConfirmPasswordVisibility(),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Obx(
                            () => Checkbox(
                              value: controller.isAgree.value,
                              onChanged: (v) => controller.toggleAgree(v),
                              activeColor: AppColors.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                height: 1.5,
                              ),
                              children: [
                                const TextSpan(text: "Saya setuju dengan "),
                                TextSpan(
                                  text: "Syarat & Ketentuan",
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
                                ),
                                const TextSpan(text: " dan "),
                                TextSpan(
                                  text: "Kebijakan Privasi",
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isShortScreen ? 15 : 20),
                    ElevatedButton(
                      onPressed: () => controller.register(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: Size(
                          double.infinity,
                          isShortScreen ? 45 : 50,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Daftar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Center(
                      child: Text(
                        "atau daftar dengan",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 15),
                    OutlinedButton(
                      onPressed: () => controller.registerWithGoogle(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(
                          double.infinity,
                          isShortScreen ? 45 : 50,
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/login/google_icon.png',
                            height: 22,
                            width: 22,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Daftar dengan Google",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isShortScreen ? 4 : 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah punya akun? ",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(splashFactory: InkRipple.splashFactory),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Get.back(),
                              borderRadius: BorderRadius.circular(25),
                              splashColor: AppColors.accent.withOpacity(0.15),
                              highlightColor: AppColors.accent.withOpacity(0.1),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Text(
                                  "Masuk di sini",
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Obx(
              () => controller.isLoading.value
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    IconData icon,
    String label,
    String hint,
    TextEditingController textController,
    bool isShort, {
    bool isPass = false,
    bool obscureText = false,
    VoidCallback? onSuffixTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isShort ? 8 : 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: textController,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.accent, size: 18),
              ),
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: EdgeInsets.symmetric(vertical: isShort ? 8 : 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              suffixIcon: isPass
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Icon(
                        obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
