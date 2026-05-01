import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/app_colors.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});
  
  get image => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BAGIAN HEADER - SUDAH DIPERBAIKI AGAR TIDAK OVERFLOW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( // PENTING: Menghilangkan garis kuning-hitam
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Buat Akun Baru",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Bergabunglah dan mulai jelajahi budaya Kota Tegal.",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Gambar dengan penanganan Error jika link mati
                Image.asset(
                  'assets/images/register/1.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.account_balance, size: 50, color: AppColors.primary),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            _buildInputField(Icons.person_outline, "Nama Lengkap", "Masukkan nama lengkap"),
            _buildInputField(Icons.email_outlined, "Email", "Masukkan email aktif"),
            _buildInputField(Icons.phone_outlined, "Nomor Telepon", "Masukkan nomor telepon"),
            _buildInputField(Icons.lock_outline, "Kata Sandi", "Buat kata sandi", isPass: true),
            _buildInputField(Icons.lock_reset_outlined, "Konfirmasi Kata Sandi", "Ulangi kata sandi", isPass: true),
            
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(value: true, onChanged: (v){}, activeColor: AppColors.accent),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Saya setuju dengan Syarat & Ketentuan dan Kebijakan Privasi", 
                    style: TextStyle(fontSize: 11, color: Colors.grey)
                  ),
                )
              ],
            ),
            
            const SizedBox(height: 25),
            
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Daftar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            
            const SizedBox(height: 25),
            const Center(child: Text("atau daftar dengan", style: TextStyle(color: Colors.grey, fontSize: 12))),
            const SizedBox(height: 20),
            
            OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.blue),
              label: const Text("Daftar dengan Google", style: TextStyle(color: Colors.black)),
            ),
            
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sudah punya akun? "),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Text("Masuk di sini", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String label, String hint, {bool isPass = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            obscureText: isPass,
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: AppColors.accent, size: 20),
              ),
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              suffixIcon: isPass ? const Icon(Icons.visibility_off_outlined, color: Colors.grey) : null,
            ),
          ),
        ],
      ),
    );
  }
}