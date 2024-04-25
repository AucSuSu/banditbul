import 'package:flutter/material.dart';
import 'package:frontend/screens/main_page/main_page.dart';
import 'package:frontend/util/neon_border_button.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:get/get.dart';

class ArrivePage extends StatefulWidget {
  const ArrivePage({super.key});

  @override
  _ArrivePageState createState() => _ArrivePageState();
}

class _ArrivePageState extends State<ArrivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: TitleBar(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 70, 30, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 텍스트 2개 담은 컨테이너
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xffFFF27A),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              width: double.infinity,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'ㅇㅇㅇ 역', // 여기 부분이 개찰구 비콘에 따라 다르게 바뀔듯
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '도착하였습니다',
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
            SizedBox(height: 50),
            // 가운데 벌레랑 벌레 그림자? 사진 2개를 container로 묶음
            Container(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/bandi_bug.png',
                    width: 200,
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/images/bandi_bug_light.png',
                    width: 150,
                  )
                ],
              ),
            ),
            SizedBox(height: 50),
            NeonBorderButton(
              buttonText: '메인으로',
              buttonColor: Color(0xffFFEF9D),
              borderColor: Color.fromARGB(255, 241, 245, 17),
              onPressed: () {
                Get.offAll(() => MainPage());
              },
            )
          ],
        ),
      ),
    );
  }
}
