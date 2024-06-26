import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/search_page/search_page.dart';
import 'package:frontend/screens/sos_page/widgets/sos_page_wait.dart';
import 'package:frontend/store/BeaconController.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:get/get.dart';

class MainSearchPage extends StatefulWidget {
  const MainSearchPage({super.key});

  @override
  _MainSearchPageState createState() => _MainSearchPageState();
}

class _MainSearchPageState extends State<MainSearchPage> {
  @override
  void initState() {
    super.initState();
    fetchStationName(); // 페이지 진입 시 API 호출
  }

  Future<void> fetchStationName() async {
    Dio dio = Dio(); // Dio 인스턴스 생성
    var tmpBeaconId =
        Get.find<BeaconController>().beaconId.value; // 비콘 ID 전역 가져오기
    try {
      var response =
          await dio.get('${dotenv.env['BASE_URL']}/stationinfo/$tmpBeaconId');
      if (response.statusCode == 200) {
        var tmpStation = response.data['object'];
        Get.find<BeaconController>()
            .setStationName(tmpStation); // 전역 상태에 지하철역명 저장
      }
    } catch (e) {
      print('역안내 API 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double phoneHeight = MediaQuery.of(context).size.height * 0.26;
    return Scaffold(
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
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 버튼의 가장 큰 부분을 GestureDetector로 감싸서 클릭 이벤트를 추가
                        GestureDetector(
                          onTap: () {
                            // 버튼을 클릭했을 때 수행하는 동작
                            print('음성으로 검색하기 버튼 클릭');
                            Get.to(
                              () => const SearchPage(
                                initialIndex: 0,
                              ),
                            );
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
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 35),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/images/search_voice.png',
                                    width: phoneHeight * 0.8,
                                    height: phoneHeight * 0.6,
                                  ),
                                  const Text(
                                    '음성으로 검색하기',
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
                            print('문자로 검색하기 버튼 클릭');
                            Get.to(
                              () => const SearchPage(initialIndex: 1),
                            );
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
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 35),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/images/search_text.png',
                                    width: phoneHeight * 0.8,
                                    height: phoneHeight * 0.6,
                                  ),
                                  const Text(
                                    '문자로 검색하기',
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
                            Get.to(() => const SosPageWait());
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
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 35),
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
    );
  }
}
