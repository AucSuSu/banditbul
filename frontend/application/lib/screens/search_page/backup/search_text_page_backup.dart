import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/navigation_page/navigation_page.dart';
import 'package:frontend/store/BeaconController.dart';
import 'package:frontend/store/RouteController.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:frontend/screens/search_page/widgets/chat_bubble.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SearchTextPage extends StatefulWidget {
  const SearchTextPage({super.key, required this.toggleFloatingActionButton});

  final Function(bool) toggleFloatingActionButton;

  @override
  _SearchTextPageState createState() => _SearchTextPageState();
}

class _SearchTextPageState extends State<SearchTextPage> {
  List<Map<String, dynamic>> messages = []; // 메시지를 저장할 리스트
  TextEditingController textController =
      TextEditingController(); // 텍스트 입력을 위한 컨트롤러
  FocusNode textFocusNode = FocusNode(); // 텍스트 필드 포커스를 위한 FocusNode 추가
  bool isEnd = false;

  @override
  // initState 함수를 사용하여 위젯이 생성될 때 API 요청 함수를 호출
  void initState() {
    super.initState();
    fetchStationNames();
    textFocusNode.addListener(() {
      print("Focus status: ${textFocusNode.hasFocus}");
      widget.toggleFloatingActionButton(!textFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    super.dispose();
  }

  // 10초뒤에 navigation 페이지로 이동 하는 함수
  void navigateToNavigationPage() {
    Future.delayed(const Duration(seconds: 5), () {
      Get.to(() => const NavigationPage());
    });
  }

  // 메시지 개수를 3개이하로 유지
  void manageMessageList(Map<String, dynamic> newMessage) {
    setState(() {
      if (messages.length >= 3) {
        messages.removeAt(0); // 오래된 메시지 삭제
      }
      messages.add(newMessage); // 새 메시지 추가
    });
  }

  // API 요청 함수, Dio를 사용하여 역 이름을 가져오고 메시지 형식으로 가공
  Future<void> fetchStationNames() async {
    Dio dio = Dio(); // Dio 인스턴스 생성
    var tmpBeaconId =
        Get.find<BeaconController>().beaconId.value; // 비콘 ID 전역 가져오기
    try {
      print(tmpBeaconId);
      var response =
          await dio.get('${dotenv.env['BASE_URL']}/stationinfo/$tmpBeaconId');
      if (response.statusCode == 200) {
        var tmpStation = response.data['object'];
        var newMessages = {
          'text': '현재역은 $tmpStation 입니다 \n도착역을 말씀해주세요',
          'isUser': false
        };

        setState(() {
          manageMessageList(newMessages);
        });
      }
    } catch (e) {
      print('역안내 api 에러 : $e');
    }

    // // 임시 데이터
    // var newMessage = {'text': '현재 역은 하단역입니다 \n도착역을 말씀해주세요', 'isUser': false};

    // setState(() {
    //   manageMessageList(newMessage);
    // });
  }

  // API 요청 함수, 입력한 데이터를 가지고 길찾기를 요청함
  Future findRoute(String stationName) async {
    Dio dio = Dio(); // Dio 인스턴스 생성

    try {
      var response = await dio.get(
        '${dotenv.env['BASE_URL']}/navigation',
        queryParameters: {
          'beaconId': Get.find<BeaconController>().beaconId.value,
          'destStation': stationName,
        },
      );

      if (response.statusCode == 200) {
        RouteController rc = Get.find<RouteController>();
        rc.setRoute1(response.data['object']['result1']);
        rc.setRoute2(response.data['object']['result2']);
        var newMessage = {
          'text': '잠시 후 $stationName로 안내합니다',
          'isUser': false,
        };
        setState(() {
          isEnd = true;
          manageMessageList(newMessage);
        });
        navigateToNavigationPage(); // 5초후 네비게이션으로 이동
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          // 역 이름 체크
          var newMessage = {
            'text': '올바르지 않은 입력입니다. \na역 b번 출구 형태로 입력해주세요.',
            'isUser': false,
          };
          setState(() {
            manageMessageList(newMessage);
          });
        } else if (e.response?.statusCode == 403) {
          // 출구 체크
          var newMessage = {
            'text': '올바르지 않은 입력입니다. \na역 b번 출구 형태로 입력해주세요.',
            'isUser': false,
          };
          setState(() {
            manageMessageList(newMessage);
          });
        } else {
          print('다른 HTTP 에러 : ${e.response?.statusCode}');
        }
      } else {
        print('길찾기 api 에러 : $e');
      }
    }

    // // 임시 데이터
    // var newMessage = {
    //   'text': '$stationName 존재하지 않습니다. \n다시 입력해주세요',
    //   'isUser': false
    // };

    // setState(() {
    //   manageMessageList(newMessage);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // 현재 포커스를 해제하여 키보드를 숨깁니다
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            const TitleBar(),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    // messages 리스트에 메시지가 없거나 마지막 메시지의 isUser가 false이고 isEnd가 false일 경우에만 TextField를 추가합니다.
                    itemCount: messages.isEmpty || messages.last['isUser']
                        ? messages.length
                        : messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index < messages.length) {
                        // 일반 메시지 처리
                        return ChatBubble(
                          text: messages[index]['text'],
                          isUser: messages[index]['isUser'],
                        );
                      } else if (messages.isNotEmpty &&
                          !messages.last['isUser'] &&
                          !isEnd) {
                        // 마지막 메시지의 isUser가 false이고 isEnd가 false인 경우, 마지막 아이템으로 TextField 추가
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            margin: const EdgeInsets.only(bottom: 18),
                            decoration: BoxDecoration(
                              color: const Color(0xffFCF207),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              focusNode: textFocusNode,
                              controller: textController,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: InputDecoration(
                                hintText: "대화 입력",
                                hintStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onSubmitted: (value) {
                                // 입력한 메시지 처리 로직
                                print(textController.text);
                                var newMessage = {
                                  'text': textController.text,
                                  'isUser': true
                                };
                                setState(() {
                                  manageMessageList(newMessage);
                                  findRoute(textController.text); // 길찾기 요청
                                  textController.clear(); // 입력 필드 초기화
                                });
                              },
                            ),
                          ),
                        );
                      } else {
                        // 조건에 따라 TextField를 표시하지 않는 경우 여기에 로직 추가
                        return Container(); // 아무 것도 표시하지 않음
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
