import 'package:cultural_tegal/app/modules/event/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/app_colors.dart';
import '../home/view.dart';
import '../explore/view.dart'; // Pastikan import ini ada
import '../profile/view.dart'; // Pastikan import ini ada
import 'controller.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Memanggil controller untuk navigasi
    final controller = Get.put(MainController());

    // Daftar halaman harus berjumlah 4 sesuai dengan item di BottomNavigationBar
    final List<Widget> screens = [
      const HomeView(),    // Index 0: Beranda
      const ExploreView(), // Index 1: Jelajah
      const EventView(),  // Index 2: Event (Pastikan EventView sudah dibuat di folder event)
      const ProfileView(), // Index 3: Akun
    ];

    return Scaffold(
      // Obx digunakan agar tampilan berubah saat currentIndex di controller berubah
      body: Obx(() => screens[controller.currentIndex.value]),
      
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: (index) => controller.currentIndex.value = index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), 
            label: 'Beranda'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded), 
            label: 'Jelajah'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_rounded), 
            label: 'Event'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded), 
            label: 'Akun'
          ),
        ],
      )),
    );
  }
}