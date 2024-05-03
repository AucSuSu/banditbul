import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/search_page/widgets/chat_bubble.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:frontend/util/voice_recognition_service.dart';

class SearchVoicePage extends StatefulWidget {
  const SearchVoicePage({super.key});

  @override
  _SearchVoicePageState createState() => _SearchVoicePageState();
}

class _SearchVoicePageState extends State<SearchVoicePage> {
  List<Map<String, dynamic>> messages = []; // 메시지를 저장할 리스트
  bool isEnd = false;
  final VoiceRecognitionService _voiceService = VoiceRecognitionService();

  @override
  // initState 함수를 사용하여 위젯이 생성될 때 API 요청 함수를 호출
  void initState() {
    super.initState();
    fetchStationNames();
  }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }

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
      'text': '$stationName 존재하지 않습니다. \n다시 입력해주세요',
      'isUser': false
    };

    setState(() {
      manageMessageList(newMessage);
    });
  }

  void toggleRecording() async {
    if (_voiceService.isRecording) {
      String filePath = await _voiceService
          .stopRecording(); // Assuming this now returns a Future<String>
      if (filePath.isNotEmpty) {
        String text = await _voiceService.convertSpeechToText(filePath);
        // if (text.isNotEmpty) {
        setState(() {
          manageMessageList({'text': text, 'isUser': true});
          findRoute(text);
        });
        // }
      }
    } else {
      await _voiceService
          .startRecording(); // Ensure this function starts recording and does not need to return anything
    }
    setState(() {}); // This will refresh the UI after recording status changes
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
                  // messages 리스트에 메시지가 없거나 마지막 메시지의 isUser가 false이고 isEnd가 false일 경우에만 음성입력 버튼을 표시
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
                      // 마지막 메시지의 isUser가 false이고 isEnd가 false인 경우, 마지막 아이템으로 button 추가
                      String buttonText =
                          _voiceService.isRecording ? '입력 완료' : '음성 입력';
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffFCF207),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: toggleRecording,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  buttonText,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
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
    );
  }
}
