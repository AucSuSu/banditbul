import 'package:flutter/material.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:frontend/screens/search_page/widgets/chat_bubble.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchTextPage extends StatefulWidget {
  const SearchTextPage({super.key});

  @override
  _SearchTextPageState createState() => _SearchTextPageState();
}

class _SearchTextPageState extends State<SearchTextPage> {
  List<Map<String, dynamic>> messages = []; // 메시지를 저장할 리스트
  TextEditingController textController =
      TextEditingController(); // 텍스트 입력을 위한 컨트롤러

  @override
  // initState 함수를 사용하여 위젯이 생성될 때 API 요청 함수를 호출
  void initState() {
    super.initState();
    fetchStationNames();
  }

  // API 요청 함수, Dio를 사용하여 역 이름을 가져오고 메시지 형식으로 가공
  Future<void> fetchStationNames() async {
    // Dio dio = Dio(); // Dio 인스턴스 생성
    // try {
    //   var response = await dio
    //       .get('${dotenv.env['BASE_URL']!}/api/stationinfo/{beaconId}');
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
      messages.add(newMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TitleBar(),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView.builder(
                  itemCount:
                      messages.length + 1, // messages 수 + 1 (TextField를 위한 공간)
                  itemBuilder: (context, index) {
                    if (index < messages.length) {
                      // 일반 메시지 처리
                      return ChatBubble(
                        text: messages[index]['text'],
                        isUser: messages[index]['isUser'],
                      );
                    } else {
                      // 마지막 아이템으로 TextField 추가
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            color: const Color(0xffFCF207),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: textController,
                            decoration: InputDecoration(
                              hintText: "대화 입력",
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onSubmitted: (value) {
                              // TODO: 입력한 메시지 처리 로직
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
