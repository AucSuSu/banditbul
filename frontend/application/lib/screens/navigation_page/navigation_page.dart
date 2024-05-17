import 'package:flutter/material.dart';
import 'package:frontend/screens/main_page/main_page.dart';
import 'package:frontend/store/BeaconController.dart';
import 'package:frontend/store/RouteController.dart';
import 'package:frontend/util/neon_border_button.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:frontend/util/tts_function.dart';
import 'package:get/get.dart';
import 'package:frontend/screens/sos_page/widgets/sos_page_wait.dart';

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
  final BeaconController _beaconController = Get.find<BeaconController>();
  String currentRouteText = '';

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
  String getTextFromRoute(bool isTalkBackMode) {
    if (_routeController.currentRoute.isEmpty) {
      return _beaconController.beaconId.value;
    }
    var curRoute = _routeController.currentRoute;
    var curIdx = _routeController.currentRouteIndex.value;
    var curDist = _routeController.currentRoute[curIdx]['distance'];
    if (curRoute == _routeController.route2 && curIdx == 0) {
      return '지하철 탑승 중입니다';
    }

    String text;
    if (_routeController.currentRoute[curIdx]['directionInfo'] == '왼쪽') {
      text = '좌회전 후 \n${curDist}m 이동하세요';
    } else if (_routeController.currentRoute[curIdx]['directionInfo'] ==
        '오른쪽') {
      text = '우회전 후 \n${curDist}m 이동하세요';
    } else {
      text = '다음 안내까지 \n${curDist}m 직진입니다.';
    }

    if (!isTalkBackMode) {
      clovaTTSManager.getTTS(text);
    }

    return text;
  }

  // 경로에 따른 이미지 설정
  String getImageFromRoute() {
    if (_routeController.currentRoute.isEmpty) {
      return 'assets/images/navigation/left.png';
    }
    var curIdx = _routeController.currentRouteIndex.value;
    var curRoute = _routeController.currentRoute;

    if (curRoute == _routeController.route2 && curIdx == 0) {
      return 'assets/images/navigation/subway.png';
    }

    if (_routeController.currentRoute[curIdx]['directionInfo'] == '왼쪽') {
      return 'assets/images/navigation/left.png';
    } else if (_routeController.currentRoute[curIdx]['directionInfo'] ==
        '오른쪽') {
      return 'assets/images/navigation/right.png';
    } else {
      return 'assets/images/navigation/straight.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTalkBackMode = WidgetsBinding
        .instance.window.accessibilityFeatures.accessibleNavigation;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const TitleBar(),
      body: Obx(
        () {
          String newRouteText = getTextFromRoute(isTalkBackMode);
          if (currentRouteText != newRouteText) {
            setState(() {
              currentRouteText = newRouteText;
            });
          }
          return Padding(
            padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
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
                    child: Semantics(
                      key: ValueKey(
                          currentRouteText), // 변경된 텍스트마다 새로운 키를 설정하여 TalkBack이 인식하게 함
                      liveRegion: true, // TalkBack이 텍스트 변경 사항을 읽도록 함
                      child: Text(
                        currentRouteText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Image.asset(
                  getImageFromRoute(),
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                Column(
                  children: [
                    NeonBorderButton(
                      buttonText: '다시 듣기',
                      buttonColor: const Color(0xffEEFFBD),
                      borderColor: const Color(0xff33e9e9),
                      textColor: Colors.black,
                      onPressed: () {
                        if (!isTalkBackMode) {
                          rePlay();
                        } else {
                          clovaTTSManager
                              .getTTS(getTextFromRoute(isTalkBackMode));
                          setState(() {
                            currentRouteText = getTextFromRoute(isTalkBackMode);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                    NeonBorderButton(
                      buttonText: '안내 종료',
                      buttonColor: const Color(0xff9DCAFF),
                      borderColor: const Color(0xff838fff),
                      textColor: Colors.black,
                      onPressed: () {
                        Get.offAll(() => const MainPage());
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
          );
        },
      ),
    );
  }
}
