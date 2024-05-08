import 'package:flutter/material.dart';
import 'package:frontend/screens/main_page/main_page.dart';
import 'package:frontend/store/BeaconController.dart';
import 'package:frontend/store/RouteController.dart';
import 'package:frontend/store/SessionController.dart';
import 'package:frontend/util/neon_border_button.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:frontend/util/tts_function.dart';
import 'package:get/get.dart';
import 'package:frontend/screens/sos_page/widgets/sos_page_wait.dart';
import 'package:dio/dio.dart';
import 'package:frontend/util/websocket.dart';

class Object {
  final sessionId;
  Object({required this.sessionId});
}

class ResponseSOS {
  ResponseSOS(
      {required this.status, required this.message, required this.object});
  final String status;
  final String message;
  final Object object;
}

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final ClovaTTSManager clovaTTSManager = ClovaTTSManager();
  final RouteController _routeController = Get.find<RouteController>();

  // 메모리 관리를 위한 dispose
  @override
  void dispose() {
    clovaTTSManager.dispose();
    super.dispose();
  }

  void rePlay() {
    clovaTTSManager.replayAudio();
  }

  void sos() async {
    Get.to(() => const SosPageWait());
  }

  // 경로에 따른 text 설정
  String getTextFromRoute() {
    if (_routeController.currentRoute.isEmpty) {
      return '불법 침입용';
    }
    var _curIdx = _routeController.currentRouteIndex.value;
    var _nextIdx = _routeController.nextRouteIndex.value;
    var _curDist = _routeController.currentRoute[_curIdx]['distance'];

    if (_routeController.currentRoute[_curIdx]['directionInfo'] == '왼쪽') {
      var _text = '좌회전 후 \n${_curDist}m 이동하세요'; // text 설정
      clovaTTSManager.getTTS(_text); // TTS
      return _text;
    } else if (_routeController.currentRoute[_curIdx]['directionInfo'] ==
        '오른쪽') {
      var _text = '우회전 후 \n${_curDist}m 이동하세요';
      clovaTTSManager.getTTS(_text);
      return _text;
    } else {
      var _text = '다음 안내까지 \n${_curDist}m 직진입니다.';
      clovaTTSManager.getTTS(_text);
      return _text;
    }
  }

  // 경로에 따른 이미지 설정
  String getImageFromRoute() {
    if (_routeController.currentRoute.isEmpty) {
      return 'assets/images/navigation/left.png';
    }
    var _curIdx = _routeController.currentRouteIndex.value;

    if (_routeController.currentRoute[_curIdx]['directionInfo'] == '왼쪽') {
      return 'assets/images/navigation/left.png';
    } else if (_routeController.currentRoute[_curIdx]['directionInfo'] ==
        '오른쪽') {
      return 'assets/images/navigation/right.png';
    } else {
      return 'assets/images/navigation/straight.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const TitleBar(),
      body: Obx(
        () => Padding(
          // 제일 큰 conatiner를 padding을 넣어서 가로 세로에 여유공간
          padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
          child: Column(
            // Container와 button 3개를 묶은 Column을 띄우기 위한 설정
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                //텍스트의 테두리를 만들기 위한 container
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xffFFF27A),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    getTextFromRoute(), // 이부분이 나중에는 동적으로 바뀌어야 할 것
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Image.asset(
                getImageFromRoute(), // 이것도 api 통신에 따라서 직,좌,우로 바꿔여함
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              Column(
                // 고정값 버튼 3개를 담은 column
                children: [
                  NeonBorderButton(
                    buttonText: '다시 듣기',
                    buttonColor: const Color(0xffEEFFBD),
                    borderColor: const Color(0xff33e9e9),
                    textColor: Colors.black,
                    onPressed: () {
                      rePlay();
                    },
                  ),
                  const SizedBox(height: 40),
                  NeonBorderButton(
                    buttonText: '안내 종료',
                    buttonColor: const Color(0xff9DCAFF),
                    borderColor: const Color(0xff838fff),
                    textColor: Colors.black,
                    onPressed: () {
                      Get.to(() => const MainPage());
                    },
                  ),
                  const SizedBox(height: 40),
                  NeonBorderButton(
                    buttonText: '도움 요청',
                    buttonColor: const Color(0xffFF9F9F),
                    borderColor: const Color(0xffFF1C45),
                    textColor: Colors.black,
                    onPressed: () {
                      sos();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
