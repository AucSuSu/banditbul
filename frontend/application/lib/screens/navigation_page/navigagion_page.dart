import 'package:flutter/material.dart';
import 'package:frontend/screens/navigation_page/widgets/navigation_button.dart';
import 'package:frontend/util/title_bar.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: TitleBar(),
      body: Padding(
        // 제일 큰 conatiner를 padding을 넣어서 가로 세로에 여유공간
        padding: EdgeInsets.fromLTRB(30, 50, 30, 50),
        child: Column(
          // Container와 button 3개를 묶은 Column을 띄우기 위한 설정
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              //텍스트의 테두리를 만들기 위한 container
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xffFFF27A),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  '다음 안내까지 직진입니다.', // 이부분이 나중에는 동적으로 바뀌어야 할 것
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Image.asset(
              'assets/images/navigation/straight.png', // 이것도 api 통신에 따라서 직,좌,우로 바꿔여함
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            Column(
              // 고정값 버튼 3개를 담은 column
              children: [
                NavigationButton(
                  buttonText: '다시 듣기',
                  buttonColor: Color(0xffEEFFBD),
                  borderColor: Color(0xff33e9e9),
                ),
                SizedBox(height: 40),
                NavigationButton(
                  buttonText: '안내 종료',
                  buttonColor: Color(0xff9DCAFF),
                  borderColor: Color(0xff838fff),
                ),
                SizedBox(height: 40),
                NavigationButton(
                  buttonText: '도움 요청',
                  buttonColor: Color(0xffFF9F9F),
                  borderColor: Color(0xffFF1C45),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
