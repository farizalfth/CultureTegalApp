import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_pencapaian_controller.dart';

class DetailPencapaianView extends GetView<DetailPencapaianController> {
  const DetailPencapaianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailPencapaianView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailPencapaianView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
