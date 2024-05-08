import 'package:flutter/material.dart';
import 'package:frontend/store/BeaconController.dart';
import 'package:frontend/store/SessionController.dart';
import 'package:frontend/util/neon_border_button.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:get/get.dart';
import 'package:frontend/util/websocket.dart';
import 'package:frontend/screens/sos_page/widgets/sos_page_accept.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class SosPageWait extends StatefulWidget {
  const SosPageWait({super.key});

  @override
  _SosPageWaitState createState() => _SosPageWaitState();
}

void getSessionId(String beaconId) async {
  try {
    Dio dio = Dio();
    final response = await dio.get(
      "https://banditbul.co.kr/api/sos/$beaconId",
    );

    print(response);
    var sessionId = response.data['object']['sessionId'];
    SessionController().setSessionId(sessionId);
  } catch (error) {
    print(error);
  }
}

class _SosPageWaitState extends State<SosPageWait> {
  // 페이지 들어오자마자 데이터 계속 받으면서
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    WebsocketManager manager = WebsocketManager();
    // _channel = manager.connect();
    _channel = IOWebSocketChannel.connect("wss://banditbul.co.kr/socket");
    print(_channel);

    // var stream = _channel.stream.asBroadcastStream();
    // final streamListener1 = stream.listen((val) {
    //   print("data");
    // });

    if (_channel == null) {
      _channel = IOWebSocketChannel.connect("wss://banditbul.co.kr/socket");
    } else {
      _channel.stream.listen((response) {
        print('데이터');
        print('웹소켓 응답 : $response');
      }, onDone: () {
        print('연결 종료 ');
        _channel = IOWebSocketChannel.connect("wss://banditbul.co.kr/socket");
      }, onError: (error) {
        print('소켓 통신에 실패했습니다. $error');
      });
    }

    // controller 등록
    Get.put(SessionController());
    Get.put(BeaconController());
    // beaconId -> 가장 까운거 넣어주기
    String beaconId = "11:22:34";
    getSessionId(beaconId); // -> 여기에 실제 탐지한 비콘 id가 들어가야됨 !!!!!!
    String sessionId = Get.find<SessionController>().sessionId.value;

    sendMessage(MessageDto(
        type: "ENTER",
        beaconId: beaconId,
        sessionId: "b",
        uuId: "1234",
        count: null));

    sendMessage(MessageDto(
        type: "SOS",
        beaconId: beaconId,
        sessionId: "b",
        uuId: "1234",
        count: null));
    // manager.listenToMessage((onData));
  }

  void startConnection() async {}

  void sendMessage(MessageDto dto) {
    if (_channel == null) {
      throw Exception("WebSocket Channle 없음");
    } else {
      print("message 전송");

      _channel = IOWebSocketChannel.connect("wss://banditbul.co.kr/socket",
          headers: {'Connection': 'upgrade', 'Upgrade': 'websocket'});

      _channel!.sink.add(
          '{"type" : "${dto.type}", "beaconId" : "${dto.beaconId}", "sessionId" : "${dto.sessionId}", "count" : null, "uuId" : "${dto.uuId}"}');
    }
  }

  // data 받기
  void onData(dynamic data) {
    print('$data');
    MessageDto messageDto = MessageDto.fromJson(data);
    print(Get.find<SessionController>().sessionId.value);
    // api 요청으로 받아오기
    print(Get.find<BeaconController>()
        .beaconId
        .value); // beaconId -> bluetooth로 받아오기

    // 만약 SOS_ACCEPT
    if (messageDto.type == "SOS_ACCEPT" &&
        messageDto.sessionId == Get.find<BeaconController>().beaconId.value &&
        messageDto.sessionId == Get.find<SessionController>().sessionId.value) {
      // 관리자가 승인했음 -> 승인완료로 돌아가기
      Get.to(() => const SosPageAccept());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const TitleBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 70, 30, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 텍스트 2개 담은 컨테이너
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xffFFF27A),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              width: double.infinity,
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      '도움을',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      '요청중입니다',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            // 가운데 벌레랑 벌레 그림자? 사진 2개를 container로 묶음
            Container(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/bandi_bug.png',
                    width: 200,
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/bandi_bug_light_red.png',
                    width: 150,
                  )
                ],
              ),
            ),
            const SizedBox(height: 50),
            NeonBorderButton(
              buttonText: '도움요청 취소하기',
              buttonColor: const Color(0xffEEFFBD),
              borderColor: const Color(0xff33E9E9),
              textColor: Colors.black,
              onPressed: () {
                // Get.back();

                // test mode ---
                Get.to(() => const SosPageAccept());
              },
            )
          ],
        ),
      ),
    );
  }
}
