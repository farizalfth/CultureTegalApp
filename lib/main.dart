import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart'; // Pastikan import ini benar

void main() {
  runApp(
    GetMaterialApp(
      title: "Cultural Tegal",
      debugShowCheckedModeBanner: false,
      // GANTI: Jangan tulis '/main' secara manual
      // Gunakan AppPages.INITIAL yang sudah kita set ke LOGIN
      initialRoute: AppPages.INITIAL, 
      
      // GANTI: Jangan buat list GetPage manual di sini
      // Ambil semua daftar rute dari file AppPages
      getPages: AppPages.routes, 
    ),
  );
}