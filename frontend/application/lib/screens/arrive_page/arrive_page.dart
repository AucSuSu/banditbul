import 'package:flutter/material.dart';
import 'package:frontend/screens/main_page/main_page.dart';
import 'package:frontend/util/neon_border_button.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:frontend/util/tts_function.dart';
import 'package:get/get.dart';

class ArrivePage extends StatefulWidget {
  const ArrivePage({super.key});

  @override
  _ArrivePageState createState() => _ArrivePageState();
}

class _ArrivePageState extends State<ArrivePage> {
  final ClovaTTSManager clovaTTSManager = ClovaTTSManager();

  @override
  void initState() {
    super.initState();
    clovaTTSManager.getTTS('목적지에 도착 하였습니다. 잠시 후 메인페이지로 이동합니다.');
    // 7초 후 메인페이지로 이동
    Future.delayed(const Duration(seconds: 7), () {
      Get.offAll(() => const MainPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const TitleBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 70, 30, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 텍스트 2개 담은 컨테이너
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xffFFF27A),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              width: double.infinity,
              child: const Center(
                child: Column(
                  children: [
                    Text(
                      '목적지에', // 여기 부분이 개찰구 비콘에 따라 다르게 바뀔듯
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '도착 하였습니다',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            // 가운데 벌레랑 벌레 그림자? 사진 2개를 container로 묶음
            Container(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/bandi_bug.png',
                    width: 200,
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/bandi_bug_light.png',
                    width: 150,
                  )
                ],
              ),
            ),
            const SizedBox(height: 50),
            NeonBorderButton(
              buttonText: '메인으로',
              buttonColor: const Color(0xffFFEF9D),
              borderColor: const Color.fromARGB(255, 241, 245, 17),
              textColor: Colors.black,
              onPressed: () {
                Get.offAll(() => const MainPage());
              },
            )
          ],
        ),
      ),
    );
  }
}
