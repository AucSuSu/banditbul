import 'package:flutter/material.dart';
import 'package:frontend/scanBeacon/scan_screen.dart';
import 'package:frontend/screens/arrive_page/arrive_page.dart';
import 'package:frontend/screens/main_page/main_page.dart';
import 'package:frontend/screens/navigation_page/navigation_page.dart';
import 'package:frontend/screens/search_page/search_page.dart';
import 'package:frontend/screens/sos_page/sos_page.dart';
import 'package:frontend/screens/sos_page/widgets/sos_page_accept.dart';
import 'package:frontend/screens/sos_page/widgets/sos_page_wait.dart';
import 'package:frontend/test_page.dart';
import 'package:frontend/util/stt_function.dart';
import 'package:frontend/util/tts_function.dart';
import 'package:frontend/util/websocket.dart';
import 'package:get/get.dart';

class TestNavigatePage extends StatelessWidget {
  const TestNavigatePage({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp 대신 GetMaterialApp 사용 GetX 적용 하기 위함
    return Scaffold(
      appBar: AppBar(
        title: const Text('페이지 네비게이션'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
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
                Get.to(() => const ArrivePage(
                      ttsText: '비콘 정보가 나올거에요',
                    ));
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
                Get.to(() => const VoiceToTextPage());
              },
              child: const Text('STTFunction Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const SOSClient());
              },
              child: const Text('SOSClient Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const SosPage());
              },
              child: const Text('SOS Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const ScanScreen());
              },
              child: const Text('ScanScreen Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const TestPage());
              },
              child: const Text('Test Page'),
            ),
          ],
        ),
      ),
    );
  }
}
