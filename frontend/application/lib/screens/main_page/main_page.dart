import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/screens/main_page/widgets/main_search_page.dart';
import 'package:frontend/screens/navigation_page/navigation_page.dart';
import 'package:frontend/screens/sos_page/widgets/sos_page_wait.dart';
import 'package:frontend/store/BeaconController.dart';
import 'package:frontend/store/RouteController.dart';
import 'package:frontend/util/dotted_border_text.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  DateTime? currentPress;

  void navigateToNavigationPage() {
    Future.delayed(const Duration(seconds: 1), () {
      Get.to(() => const NavigationPage());
    });
  }

  // 화장실 가는 함수
  Future findToiletRoute() async {
    Dio dio = Dio(); // Dio 인스턴스 생성

    try {
      var response = await dio.get(
        '${dotenv.env['BASE_URL']}/navigation/toilet',
        queryParameters: {
          'beaconId': Get.find<BeaconController>().beaconId.value,
        },
      );

      if (response.statusCode == 200) {
        RouteController rc = Get.find<RouteController>();
        rc.setRoute1(response.data['object']['result1']);
        rc.setRoute2([]);

        navigateToNavigationPage(); // 10초후 네비게이션으로 이동
      }
    } catch (e) {
      print('길찾기 api 에러 : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double phoneHeight = MediaQuery.of(context).size.height * 0.26;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (selectedIndex != 0) {
          setState(() {
            selectedIndex = 0;
          });
          return;
        } else {
          final now = DateTime.now();
          if (currentPress == null ||
              now.difference(currentPress!) > const Duration(seconds: 2)) {
            currentPress = now;
            Fluttertoast.showToast(
              msg: "다시 한번 눌러주세요",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
            return;
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        appBar: const TitleBar(),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 버튼의 가장 큰 부분을 GestureDetector로 감싸서 클릭 이벤트를 추가
                          GestureDetector(
                            onTap: () {
                              // 버튼을 클릭했을 때 수행하는 동작
                              print('도착역 안내받기 버튼 클릭');
                              Get.to(() => const MainSearchPage());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffF1FFCA),
                                borderRadius: BorderRadius.circular(
                                    35), // 버튼을 둥글게 만들기 위한 속성
                              ),
                              width: double.infinity,
                              height: phoneHeight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 0, 30, 35),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      child: Image.asset(
                                        'assets/images/search_road.png',
                                        width: phoneHeight * 0.8,
                                        height: phoneHeight * 0.6,
                                      ),
                                    ),
                                    // 이미지와 텍스트 사이의 간격(10%
                                    const Text(
                                      '도착역 안내받기',
                                      style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // 버튼의 가장 큰 부분을 GestureDetector로 감싸서 클릭 이벤트를 추가
                          GestureDetector(
                            onTap: () {
                              // 버튼을 클릭했을 때 수행하는 동작
                              print('화장실 안내받기 버튼 클릭');
                              findToiletRoute();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffF1FFCA),
                                borderRadius: BorderRadius.circular(
                                    35), // 버튼을 둥글게 만들기 위한 속성
                              ),
                              width: double.infinity,
                              height: phoneHeight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 0, 30, 35),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Image.asset(
                                        'assets/images/search_toilet.png',
                                        width: phoneHeight * 0.6,
                                        height: phoneHeight * 0.4,
                                      ),
                                    ),
                                    const Text(
                                      '화장실 안내받기',
                                      style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // 버튼을 클릭했을 때 수행하는 동작
                              Get.to(() => SosPageWait());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffF1FFCA),
                                borderRadius: BorderRadius.circular(
                                    35), // 버튼을 둥글게 만들기 위한 속성
                              ),
                              width: double.infinity,
                              height: phoneHeight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 0, 30, 35),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Image.asset(
                                        'assets/images/sos.png',
                                        width: phoneHeight * 0.6,
                                        height: phoneHeight * 0.4,
                                      ),
                                    ),
                                    const Text(
                                      '도움 요청하기',
                                      style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
