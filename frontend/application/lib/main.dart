import 'package:flutter/material.dart';
import 'package:frontend/screens/arrive_page/arrive_page.dart';
import 'package:frontend/screens/main_page/main_page.dart';
import 'package:frontend/screens/navigation_page/navigagion_page.dart';
import 'package:frontend/screens/search_page/widgets/search_text_page.dart';
import 'package:frontend/screens/search_page/widgets/search_voice_page.dart';
import 'package:frontend/screens/search_page/search_page.dart';
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
                  Get.offAll(() => MainPage());
                },
                child: const Text('Main Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => SearchTextPage());
                },
                child: const Text('Search Text'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => SearchVoicePage());
                },
                child: const Text('Search Voice'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => SearchPage());
                },
                child: const Text('Search Nav Bar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => NavigationPage());
                },
                child: const Text('Navigation Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => ArrivePage());
                },
                child: const Text('Arrive Page'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
