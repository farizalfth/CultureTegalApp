import 'package:cultural_tegal/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/app_colors.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Header Image - Dibuat JELAS
          Container(
            height: Get.height * 0.45, // Sedikit ditinggikan agar background lebih luas
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login/1.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.02), // Sangat transparan
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.8), // Mulai memutih di transisi kartu
                    Colors.white, 
                  ],
                ),
              ),
            ),
          ),
          
          SingleChildScrollView(
            child: Column(
              children: [
                // 2. SPACER DIPERBESAR (Dari 230 ke 300)
                // Angka ini yang membuat kartu putih turun ke bawah
                const SizedBox(height: 300), 
                
                // 3. Form Card (Kartu Putih)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: Offset(0, -5),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text("Selamat Datang!", 
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text("Masuk untuk melanjutkan perjalanan\nbudaya di Kota Tegal.", 
                        textAlign: TextAlign.center, 
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                      
                      const SizedBox(height: 30),
                      
                      // Google Login
                      OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.blue),
                        label: const Text("Masuk dengan Google", style: TextStyle(color: Colors.black)),
                      ),
                      
                      const SizedBox(height: 20),
                      const Text("atau", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 20),
                      
                      // Input Fields
                      _buildTextField(Icons.email_outlined, "Email atau Nomor Telepon"),
                      const SizedBox(height: 15),
                      _buildTextField(Icons.lock_outline, "Kata Sandi", isPassword: true),
                      
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {}, 
                          child: const Text("Lupa kata sandi?", 
                            style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600))),
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // TOMBOL MASUK
                      ElevatedButton(
                        onPressed: () => Get.offAllNamed(Routes.MAIN),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Masuk", 
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Belum punya akun? "),
                          GestureDetector(
                            onTap: () => Get.toNamed(Routes.REGISTER),
                            child: const Text("Daftar sekarang", 
                              style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: BorderSide(color: Colors.grey.shade200)),
        suffixIcon: isPassword ? const Icon(Icons.visibility_off_outlined, color: Colors.grey) : null,
      ),
    );
  }
}