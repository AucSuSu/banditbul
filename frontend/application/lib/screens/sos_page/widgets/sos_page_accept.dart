import 'package:flutter/material.dart';
import 'package:frontend/screens/main_page/main_page.dart';
import 'package:frontend/util/neon_border_button.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class SosPageAccept extends StatefulWidget {
  const SosPageAccept({super.key});

  @override
  _SosPageAcceptState createState() => _SosPageAcceptState();
}

class _SosPageAcceptState extends State<SosPageAccept> {
  @override
  void initState() {
    _playManagerAcceptVoice();
  }

  void _playManagerAcceptVoice() async {
    print("재생하기");
    AudioPlayer audioPlayer = AudioPlayer();
    try {
      // await audioPlayer.setSourceUrl(AssetSource(path))
      await audioPlayer.play(AssetSource('voice/accept.mp3'));
      print("재생 완료");
    } catch (error) {
      print(error);
    }

    // Future 비동기 작동 ! -> 넘어가기
    Future.delayed(const Duration(seconds: 20), () {
      print("메인으로 돌아가기");
      Get.off(() => const MainPage()); // Get 패키지를 사용하여 화면 전환
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
                      '관리자가',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '접수하였습니다',
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
            const NeonBorderButton(
              buttonText: '현재 위치에서\n대기해 주세요',
              buttonColor: Colors.black,
              borderColor: Color(0xff33E9E9),
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
