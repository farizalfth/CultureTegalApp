import 'package:cultural_tegal/app/modules/main/view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Cultural Tegal",
      debugShowCheckedModeBanner: false,
      initialRoute: '/main',
      getPages: [
        GetPage(name: '/main', page: () => MainWrapper()),
      ],
    ),
  );
}