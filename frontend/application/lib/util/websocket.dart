import 'package:flutter/material.dart';
// dio
import 'package:dio/dio.dart';
import 'package:web_socket_channel/io.dart';
// websocket
import 'package:web_socket_channel/web_socket_channel.dart';
// json
// Future -> 비동기 처리 하는 거
import 'dart:async';

class MessageDto {
  final String type;
  final String beaconId;
  final String sessionId;

  MessageDto(
      {required this.type, required this.beaconId, required this.sessionId});

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
        type: json['type'],
        beaconId: json['content'],
        sessionId: json["sessionId"]);
  }
}

class WebsocketManager {
  static final WebsocketManager _instance = WebsocketManager._internal();
  factory WebsocketManager() => _instance;

  WebSocketChannel? _channel;
  // WebSocketChannel get channel => _channel;

  WebsocketManager._internal();

  // 최초 연결할 때 쓰기
  void connect(String url) {
    _channel = IOWebSocketChannel.connect(url);
  }

  // 메세지 보내는 함수
  void sendMessage(MessageDto dto) {
    if (_channel == null) {
      throw Exception("WebSocket Channle 없음");
    } else {
      _channel!.sink.add(dto);
    }
  }

  // // 구독 형식
  // MessageDto listenToMessage(void Function(dynamic) onData) {
  //   if (_channel == null) {
  //     throw Exception("WebSocket Channle 없음");
  //   } else {
  //     return _channel!.stream.listen(onData);
  //   }
  // }

  // 구독 형식
  Future<void> listenToMessage(void Function(dynamic) onData) async {
    // 연결된 WebSocket 채널이 없는 경우 에러 처리
    if (_channel == null) {
      throw Exception("WebSocket Channle 없음");
    }

    // 데이터를 수신하고 해당 데이터를 반환하는 Future 생성
    Completer<void> completer = Completer<void>();
    _channel!.stream.listen((data) {
      onData(data); // 받은 데이터를 함수에 전달
      completer.complete(); // Future를 완료함으로써 함수가 완료되었음을 알림
    });

    return completer.future; // 완료될 때까지 기다리는 Future를 반환
  }
}

class SOSClient extends StatefulWidget {
  @override
  _SOSClientState createState() => _SOSClientState();

  const SOSClient({super.key});
}

class _SOSClientState extends State<SOSClient> {
  bool isSOS = false;
  final channel = IOWebSocketChannel.connect('ws://socket');
  final TextEditingController controller =
      TextEditingController(text: 'id1234');

  // flutter 생명 주기에서 제거하고 싶을때 사용하는 거
  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void postSOS(String uuid) async {
    try {
      Dio dio = Dio();
      final response = await dio.get(
        "https://k10e102.k.ssafy.io:8080/api/sos/$uuid",
      );
    } catch (error) {
      print("전송 실패 $error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // channel.stream.listen((msg) {
    //   Map<String, dynamic> jsonMap = json.decode(msg);
    //   MessageDto dto = MessageDto.fromJson(jsonMap);

    //   if (dto.type == "OK") {
    //     setState(() {
    //       isSOS = true;
    //     });

    //     print(dto.content); // 수락 하는 경우
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                postSOS(controller.text);
              },
              child: const Text("SOS")),
          TextField(
            // 입력받기
            controller: controller,
          ),
          isSOS == true
              ? ElevatedButton(onPressed: () {}, child: const Text('yes'))
              : const Text(''),
        ],
      ),
    );
  }
}
