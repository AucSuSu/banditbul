import 'package:flutter/material.dart';
// tts package import
import 'package:flutter_tts/flutter_tts.dart';

// 추가했숑 real real real 마지막
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class TTSManager {
  // tts사용을 위해 FlutterTts 인스턴스 생성
  final FlutterTts tts = FlutterTts();

  TTSManager() {
    tts.setLanguage('ko-KR'); // 언어
    tts.setSpeechRate(0.4); // 읽기 속도 조절
  }

  void speak(String text) {
    tts.speak(text);
  }
}

class Home extends StatelessWidget {
  // 갖다쓸때 이거 갖다 쓰면됨
  final TTSManager ttsManager = TTSManager();
  // TextEditingController 인스턴스 -> 사용자의 입력을 받음
  final TextEditingController controller =
      TextEditingController(text: 'Hello world');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            // 입력받기
            controller: controller,
          ),
          ElevatedButton(
              // 읽기 버튼
              onPressed: () {
                // 읽기 호출시 이렇게
                ttsManager.speak(controller.text);
              },
              child: Text('Speak'))
        ],
      ),
    );
  }
}
