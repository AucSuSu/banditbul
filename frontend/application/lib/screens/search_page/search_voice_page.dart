import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/navigation_page/navigation_page.dart';
import 'package:frontend/screens/search_page/widgets/chat_bubble.dart';
import 'package:frontend/store/BeaconController.dart';
import 'package:frontend/store/RouteController.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:frontend/util/voice_recognition_service.dart';
import 'package:get/get.dart';

class SearchVoicePage extends StatefulWidget {
  const SearchVoicePage({super.key});

  @override
  _SearchVoicePageState createState() => _SearchVoicePageState();
}

class _SearchVoicePageState extends State<SearchVoicePage> {
  List<Map<String, dynamic>> messages = []; // 메시지를 저장할 리스트
  bool isLoading = false;
  bool isEnd = false;
  bool isProcessing = false; // 음성 처리 상태를 추적하는 변수
  final VoiceRecognitionService _voiceService = VoiceRecognitionService();
  final ScrollController _scrollController =
      ScrollController(); // ScrollController 추가
  final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer 인스턴스 추가
  final FocusNode _focusNode = FocusNode(); // 포커스 노드 추가

  @override
  // 역이름 받아온 다음 렌더링
  void initState() {
    _initializeAsyncDependencies();
    super.initState();
  }

  Future<void> _initializeAsyncDependencies() async {
    await fetchStationNames();
    setState(() {});
  }

  @override
  void dispose() {
    _voiceService.dispose();
    _scrollController.dispose(); // ScrollController 해제
    _focusNode.dispose(); // 포커스 노드 해제
    super.dispose();
  }

  // 10초뒤에 navigation 페이지로 이동 하는 함수
  void navigateToNavigationPage() {
    Future.delayed(const Duration(seconds: 5), () {
      Get.to(() => const NavigationPage());
    });
  }

  // 메시지 리스트 관리
  void manageMessageList(Map<String, dynamic> newMessage) {
    setState(() {
      messages.add(newMessage); // 새 메시지 추가
    });
    // 새로운 메시지가 추가될 때마다 리스트 끝으로 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      // 메시지가 추가된 후 마지막 메시지로 포커스 이동
      FocusScope.of(context).requestFocus(_focusNode);
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
    String correctedStationName = correctSpacing(stationName); // 띄어쓰기 수정

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
        navigateToNavigationPage(); // 10초후 네비게이션으로 이동
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

  Future<void> playStartSound() async {
    // 시작 비프음 재생 함수
    await _audioPlayer.play(AssetSource('sounds/start_beep.mp3'));
  }

  Future<void> playStopSound() async {
    // 종료 비프음 재생 함수
    await _audioPlayer.play(AssetSource('sounds/stop_beep.mp3'));
  }

  void toggleRecording() async {
    if (_voiceService.isRecording) {
      setState(() {
        isProcessing = false; // 음성 인식 처리 시작
      });
      String filePath = await _voiceService
          .stopRecording(); // Assuming this now returns a Future<String>
      await playStopSound(); // 종료 비프음 재생
      setState(() {
        isLoading = true;
      });
      if (filePath.isNotEmpty) {
        String text = await _voiceService.convertSpeechToText(filePath);
        setState(() {
          isLoading = false;
          manageMessageList({'text': text, 'isUser': true});
          findRoute(text);
        });
      } else {
        setState(() {
          isLoading = false;
          isProcessing = false; // 파일이 비어있으면 처리 완료
        });
      }
    } else {
      setState(() {
        isProcessing = true; // 음성 인식 처리 시작
      });
      await playStartSound(); // 시작 비프음 재생
      await _voiceService.startRecording(); //녹음 시작
    }
    setState(() {}); // UI 갱신
  }

  @override
  Widget build(BuildContext context) {
    final double phoneHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
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
                      if (messages[index]['text'] == '') {
                        return ChatBubble(
                          text: '입력된 값이 없습니다 \n다시 입력해주세요',
                          isUser: messages[index]['isUser'],
                        );
                      }
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
                        focusNode: (index == messages.length - 1 &&
                                !messages[index]['isUser'])
                            ? _focusNode
                            : null, // 역순으로 두 번째 메시지에 포커스 노드 연결
                      );
                    } else if (messages.isNotEmpty &&
                        !messages.last['isUser'] &&
                        !isEnd) {
                      return ChatBubble(
                        text: isLoading
                            ? '음성 분석 중입니다 \n잠시만 기다려주세요'
                            : '화면 하단의 버튼을 눌러 \n음성검색을 진행해주세요',
                        isUser: true,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ),
          isProcessing
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        toggleRecording();
                      },
                      child: Container(
                        child: Image.asset(
                          'assets/images/voice_recording.gif',
                          width: 180,
                          height: 180,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 27),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        toggleRecording();
                      },
                      child: Semantics(
                        label: '음성 검색 버튼',
                        excludeSemantics: true,
                        child: Container(
                          child: Image.asset(
                            'assets/images/voice_button.png',
                            width: 140,
                            height: 140,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
        ],
      ),
    );
  }
}
