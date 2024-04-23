import 'package:flutter/material.dart';
import 'package:frontend/screens/main_page/main_page.dart';
import 'package:frontend/util/nav_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() {
  runApp(
    GetMaterialApp(
      // MaterialApp 대신 GetMaterialApp 사용 GetX 적용 하기 위함
      home: Scaffold(
        appBar: AppBar(
          title: const Text('페이지 네비게이션'),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        // GetX 네비게이션으로 페이지 링크 걸어두고 각 페이지를 완성한 다음에 모을 예정!
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.to(() => MainPage());
                },
                child: const Text('Main Page'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.to(() => NavBar());
                  },
                  child: const Text('NavBar'))
            ],
          ),
        ),
      ),
    ),
  );
}
