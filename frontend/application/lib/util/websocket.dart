import 'package:flutter/material.dart';
// dio
import 'package:web_socket_channel/io.dart';
// websocket
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

// json
// Future -> 비동기 처리 하는 거
import 'dart:async';
// env

class MessageDto {
  final String type;
  final String beaconId;
  final String sessionId;
  final String uuId;
  final Map<String, int>? count;

  MessageDto(
      {required this.type,
      required this.beaconId,
      required this.sessionId,
      required this.uuId,
      required this.count});

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
        type: json['type'],
        beaconId: json['content'],
        sessionId: json["sessionId"],
        uuId: json['uuId'],
        count: json['count']);
  }
}

class WebsocketManager {
  static final WebsocketManager _instance = WebsocketManager._internal();
  factory WebsocketManager() => _instance;

  WebSocketChannel? _channel;
  bool? _connected;

  WebsocketManager._internal();

  // 최초 연결할 때 쓰기
  void connect() async {
    print("연결 시도 ---");
    _channel = IOWebSocketChannel.connect("wss://banditbul.co.kr/socket");

    print("connect");
    if (_channel != null) {
      print("data");

      _channel!.stream.listen(
        (data) {
          print("Connected to WebSocket server");
          _connected = true;
        },
        onError: (error) {
          print("Error connecting to WebSocket server: $error");
          _connected = false;
        },
        onDone: () {
          print("WebSocket connection closed");
          _connected = false;
          connect();
        },
      );
    }
  }

  void onConnectCallback(StompFrame connectFrame) {
    print("message 들어옴");
  }

  // 메세지 보내는 함수
  void sendMessage(MessageDto dto) {
    if (_channel == null) {
      throw Exception("WebSocket Channle 없음");
    } else {
      _channel = IOWebSocketChannel.connect("wss://banditbul.co.kr/socket",
          headers: {'Connection': 'upgrade', 'Upgrade': 'websocket'});
      // _channel!.sink.add(dto);

      _channel!.sink.add(
          '{"type" : "${dto.type}", "beaconId" : "${dto.beaconId}", "sessionId" : "${dto.sessionId}", "count" : null}');
    }
  }

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
  final TextEditingController controller =
      TextEditingController(text: 'id1234');

  void postSOS(String uuid) async {
    try {
      WebsocketManager().sendMessage(MessageDto(
          type: "ENTER",
          beaconId: "11:22:33:44",
          sessionId: "b",
          uuId: "beaconId",
          count: null));
    } catch (error) {
      print("전송 실패 $error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WebsocketManager websocketManager = WebsocketManager();
    websocketManager.connect();
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
