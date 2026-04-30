import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/app_colors.dart';
import '../home/view.dart';
import 'controller.dart';

class MainWrapper extends StatelessWidget {
  // Masukkan View yang sudah dibuat di sini
  final List<Widget> screens = [
    HomeView(),
    Container(child: Center(child: Text("Explore View"))), // Placeholder
    Container(child: Center(child: Text("Event View"))),    // Placeholder
    Container(child: Center(child: Text("Profile View"))),  // Placeholder
  ];

  MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());
    return Scaffold(
      body: Obx(() => screens[controller.currentIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: (index) => controller.currentIndex.value = index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Jelajah'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Event'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      )),
    );
  }
}