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
  const SearchTextPage({super.key});

  @override
  _SearchTextPageState createState() => _SearchTextPageState();
}

class _SearchTextPageState extends State<SearchTextPage> {
  List<Map<String, dynamic>> messages = []; // 메시지를 저장할 리스트
  TextEditingController textController =
      TextEditingController(); // 텍스트 입력을 위한 컨트롤러
  FocusNode textFocusNode = FocusNode(); // 텍스트 필드 포커스를 위한 FocusNode 추가
  bool isEnd = false;
  final ScrollController _scrollController = ScrollController();

  @override
  // 역이름 받아온 다음 렌더링
  void initState() {
    _initializeAsyncDependencies();
    super.initState();
  }

  Future<void> _initializeAsyncDependencies() async {
    await fetchStationNames();
    textFocusNode.addListener(() {
      print("Focus status: ${textFocusNode.hasFocus}");
    });
    setState(() {});
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 10초뒤에 navigation 페이지로 이동 하는 함수
  void navigateToNavigationPage() {
    Future.delayed(const Duration(seconds: 5), () {
      Get.to(() => const NavigationPage());
    });
  }

  // 메시지 추가 로직
  void manageMessageList(Map<String, dynamic> newMessage) {
    setState(() {
      messages.add(newMessage); // 새 메시지 추가
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      // if (messages.isNotEmpty && !messages.last['isUser'] && !isEnd) {
      //   textFocusNode.requestFocus();
      // }
    });
  }

  // API 요청 함수, Dio를 사용하여 역 이름을 가져오고 메시지 형식으로 가공
  Future<void> fetchStationNames() async {
    var tmpStation = Get.find<BeaconController>().stationName.value;
    var newMessages = {
      'text': '현재역은 $tmpStation 입니다 \n목적지역과 출구를 함께 말해주세요',
      'isUser': false
    };

    setState(() {
      manageMessageList(newMessages);
    });

    // // 임시 데이터
    // var newMessage = {'text': '현재 역은 하단역입니다 \n도착역을 말씀해주세요', 'isUser': false};

    // setState(() {
    //   manageMessageList(newMessage);
    // });
  }

  // 정규식을 사용하여 올바른 띄어쓰기로 수정
  String correctSpacing(String input) {
    // 공백 제거 후 정규식을 사용하여 올바른 띄어쓰기로 수정
    input = input.replaceAll(RegExp(r'\s+'), ''); // 모든 공백 제거
    final regex = RegExp(r'(\S+역)(\d+번)출구');
    return input.replaceAllMapped(regex, (match) {
      return '${match.group(1)} ${match.group(2)} 출구';
    });
  }

  // API 요청 함수, 입력한 데이터를 가지고 길찾기를 요청함
  Future findRoute(String stationName) async {
    Dio dio = Dio(); // Dio 인스턴스 생성
    String correctedStationName = correctSpacing(stationName);
    print('수정된 단어 : $correctedStationName');
    try {
      var response = await dio.get(
        '${dotenv.env['BASE_URL']}/navigation',
        queryParameters: {
          'beaconId': Get.find<BeaconController>().beaconId.value,
          'destStation': correctedStationName,
        },
      );

      if (response.statusCode == 200) {
        RouteController rc = Get.find<RouteController>();
        rc.setRoute1(response.data['object']['result1']);
        rc.setRoute2(response.data['object']['result2']);
        var newMessage = {
          'text': '잠시 후 $correctedStationName로 안내합니다',
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
            'text': '올바르지 않은 입력입니다 \na역 b번 출구 라고 입력해보세요',
            'isUser': false,
          };
          setState(() {
            manageMessageList(newMessage);
          });
        } else if (e.response?.statusCode == 403) {
          // 출구 체크
          var newMessage = {
            'text': '올바르지 않은 입력입니다 \na역 b번 출구 라고 입력해보세요',
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
                padding: const EdgeInsets.only(bottom: 30),
                width: double.infinity,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.isEmpty || messages.last['isUser']
                        ? messages.length
                        : messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index < messages.length) {
                        // 일반 메시지 처리
                        // 빈 텍스트 입력시 처리
                        if (messages[index]['text'] == '') {
                          return ChatBubble(
                            text: '입력된 값이 없습니다 \n다시 입력해주세요',
                            isUser: messages[index]['isUser'],
                          );
                        }
                        // 내가 친 채팅에 대해서는 띄어쓰기 수정
                        if (messages[index]['isUser']) {
                          String correctedText =
                              correctSpacing(messages[index]['text']);
                          return ChatBubble(
                            text: correctedText,
                            isUser: messages[index]['isUser'],
                          );
                        }
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
                            // TextField에 sematics 추가
                            child: Semantics(
                              label: '목적지 입력',
                              excludeSemantics: true,
                              textField: true,
                              child: TextField(
                                focusNode: textFocusNode,
                                controller: textController,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: InputDecoration(
                                  hintText: "목적지 입력",
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
                                  print('입력한 메시지: ${textController.text}');
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
