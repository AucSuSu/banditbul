import 'package:flutter/material.dart';
import 'package:frontend/screens/main_page/main_page.dart';
import 'package:frontend/util/neon_border_button.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:get/get.dart';

class SosPageWait extends StatefulWidget {
  const SosPageWait({super.key});

  @override
  _SosPageWaitState createState() => _SosPageWaitState();
}

class _SosPageWaitState extends State<SosPageWait> {
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
                      '도움을',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '요청중입니다',
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
                    'assets/images/bandi_bug_light_red.png',
                    width: 150,
                  )
                ],
              ),
            ),
            const SizedBox(height: 50),
            NeonBorderButton(
              buttonText: '도움요청 취소하기',
              buttonColor: const Color(0xffEEFFBD),
              borderColor: const Color(0xff33E9E9),
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
