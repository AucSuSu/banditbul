import 'package:flutter/material.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:frontend/screens/search_page/widgets/chat_bubble.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  // 메시지 개수를 3개이하로 유지
  void manageMessageList(Map<String, dynamic> newMessage) {
    setState(() {
      if (messages.length >= 3) {
        messages.removeAt(0); // Remove the oldest message
      }
      messages.add(newMessage); // Add the new message
    });
  }

  // API 요청 함수, Dio를 사용하여 역 이름을 가져오고 메시지 형식으로 가공
  Future<void> fetchStationNames() async {
    // Dio dio = Dio(); // Dio 인스턴스 생성
    // try {
    //   var response = await dio
    //       .get('${dotenv.env['BASE_URL']!}/stationinfo/{beaconId}');
    //   if (response.statusCode == 200) {
    //     var data = response.data;
    //     List<dynamic> stations =
    //         data['stations']; // Adjust based on actual API response structure
    //     var newMessages = stations.map((station) {
    //       return {
    //         'text':
    //             '지금 역은 ${station['name']} 역입니다', // Adjust the key according to your data
    //         'isUser': false
    //       };
    //     }).toList();

    //     setState(() {
    //       messages.addAll(newMessages);
    //     });
    //   } else {
    //     throw Exception('Failed to load station names');
    //   }
    // } catch (e) {
    //   setState(() {
    //     messages.add({'text': 'Error: ${e.toString()}', 'isUser': false});
    //   });
    // }

    // 임시 데이터
    var newMessage = {'text': '현재 역은 하단역입니다 \n도착역을 말씀해주세요', 'isUser': false};

    setState(() {
      manageMessageList(newMessage);
    });
  }

  // API 요청 함수, 입력한 데이터를 가지고 길찾기를 요청함
  Future findRoute(String stationName) async {
    Dio dio = Dio(); // Dio 인스턴스 생성

    // try {
    //   var queryParams = {
    //     'beacon_id': 'beaconId',
    //     'destStation': textController.text,
    //   };
    //   var response = await dio.get('${dotenv.env['BASE_URL']}/navigation/');
    // } catch (e) {
    //   print(e);
    // }
    var newMessage = {
      'text': '${stationName} 존재하지 않습니다. \n다시 입력해주세요',
      'isUser': false
    };

    setState(() {
      manageMessageList(newMessage);
    });
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
                    // messages 리스트에 메시지가 없거나 마지막 메시지의 isUser가 false일 경우에만 TextField를 추가합니다.
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
                      } else if (!messages.isEmpty &&
                          !messages.last['isUser']) {
                        // 마지막 메시지의 isUser가 false인 경우, 마지막 아이템으로 TextField 추가
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
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: InputDecoration(
                                hintText: "대화 입력",
                                hintStyle: TextStyle(
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
