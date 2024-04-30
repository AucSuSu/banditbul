import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/arrive_page/arrive_page.dart';
import 'package:frontend/screens/main_page/main_page.dart';
import 'package:frontend/screens/navigation_page/navigagion_page.dart';
import 'package:frontend/screens/search_page/widgets/search_text_page.dart';
import 'package:frontend/screens/search_page/widgets/search_voice_page.dart';
import 'package:frontend/screens/search_page/search_page.dart';
import 'package:frontend/screens/sos_page/widgets/sos_page_accept.dart';
import 'package:frontend/screens/sos_page/widgets/sos_page_wait.dart';
import 'package:frontend/util/tts_function.dart';
import 'package:frontend/util/websocket.dart';

import 'package:get/get.dart';

void main() async {
  await dotenv.load(fileName: '.env');
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
                  Get.offAll(() => const MainPage());
                },
                child: const Text('Main Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => const SearchTextPage());
                },
                child: const Text('Search Text'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => const SearchVoicePage());
                },
                child: const Text('Search Voice'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => const SearchPage());
                },
                child: const Text('Search Nav Bar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => const NavigationPage());
                },
                child: const Text('Navigation Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => const ArrivePage());
                },
                child: const Text('Arrive Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => const SosPageWait());
                },
                child: const Text('SosWait Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => const SosPageAccept());
                },
                child: const Text('SosAccept Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => TTSFunction());
                },
                child: const Text('TTSFunction Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => SOSClient());
                },
                child: const Text('SOSClient Page'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
