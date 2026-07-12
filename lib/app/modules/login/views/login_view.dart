import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final bool isShortScreen = context.height < 750;
    final double safeBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/login/cover_login.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                return wasSynchronouslyLoaded
                    ? child
                    : AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        child: child,
                      );
              },
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              physics: isShortScreen
                  ? const BouncingScrollPhysics()
                  : const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: context.height * (isShortScreen ? 0.25 : 0.30),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(30, 35, 30, 40 + safeBottom),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Selamat Datang!",
                          style: TextStyle(
                            fontSize: isShortScreen ? 20 : 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Masuk untuk melanjutkan perjalanan\nbudaya di Kota Tegal.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 30),
                        OutlinedButton(
                          onPressed: () => controller.loginWithGoogle(),
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
                              const SizedBox(width: 10),
                              const Text(
                                "Masuk dengan Google",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "atau",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          icon: Icons.email_outlined,
                          hint: "Email",
                          controller: controller.emailController,
                        ),
                        const SizedBox(height: 15),
                        Obx(
                          () => _buildTextField(
                            icon: Icons.lock_outline,
                            hint: "Kata Sandi",
                            controller: controller.passwordController,
                            isPassword: true,
                            obscureText: controller.isPasswordHidden.value,
                            onSuffixIconTap: () =>
                                controller.togglePasswordVisibility(),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(splashFactory: InkRipple.splashFactory),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => Get.toNamed('/forgot-password'),
                                borderRadius: BorderRadius.circular(25),
                                splashColor: AppColors.accent.withOpacity(0.15),
                                highlightColor: AppColors.accent.withOpacity(
                                  0.1,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    "Lupa kata sandi?",
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => controller.login(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: Size(
                              double.infinity,
                              isShortScreen ? 50 : 55,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Belum punya akun? ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                splashFactory: InkRipple.splashFactory,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    if (Get.currentRoute != Routes.REGISTER) {
                                      Get.toNamed(Routes.REGISTER);
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(25),
                                  splashColor: AppColors.accent.withOpacity(
                                    0.15,
                                  ),
                                  highlightColor: AppColors.accent.withOpacity(
                                    0.1,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      "Daftar sekarang",
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
                ],
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

  Widget _buildTextField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixIconTap,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: onSuffixIconTap,
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
    );
  }
}
