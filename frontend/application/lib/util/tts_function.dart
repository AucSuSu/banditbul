import 'package:flutter/material.dart';
// tts package import
import 'package:flutter_tts/flutter_tts.dart';
// dio
import 'package:dio/dio.dart';
// audio Player
import 'package:audioplayers/audioplayers.dart';
// File
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

/** clova api문서 
 * curl -i -X POST \
	-H "Content-Type:application/x-www-form-urlencoded" \
	-H "X-NCP-APIGW-API-KEY-ID:{애플리케이션 등록 시 발급받은 client id값}" \
	-H "X-NCP-APIGW-API-KEY:{애플리케이션 등록 시 발급받은 client secret값}" \
	-d 'speaker=nara&text=만나서 반갑습니다&volume=0&speed=0&pitch=0&format=mp3' \
 'https://naveropenapi.apigw.ntruss.com/tts-premium/v1/tts'

 */

class ClovaTTSManager {
  // 필요한 값 ~ env가 있다면 거기서 관리해야한다고 생각하는디 물어봐야겠음 -> 일단 static const
  static const String url =
      'https://naveropenapi.apigw.ntruss.com/tts-premium/v1/tts';
  static const String clientId = "a1heb9p3pp";
  static const String clientSecret = "3WXoc82KoSEJvc7sM9vaXCVA3A84qCN2qcAyUgoo";
  static var prePath = "";

  // 헤더에 들어가야하는 값 ~ 얘도 고정이니까 이래 해놔
  static const Map<String, dynamic> requestHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'X-NCP-APIGW-API-KEY-ID': clientId,
    'X-NCP-APIGW-API-KEY': clientSecret,
  };

  static Dio dio = Dio();

  static void getTTS(String text) async {
    // 요청 데이터
    final Map<String, dynamic> requestData = {
      'speaker': 'ngaram', // -> 물어보고 뭐가 제일 나은지 정하기
      'text': text,
      'volume': '5', // -> 해보면서 조정
      'speed': '0', // -> 해보면서 조정
      'pitch': '0', // -> 해보면서 조정
      'format': 'mp3',
    };

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;

    try {
      final response = await dio.post(
        url,
        data: requestData,
        options:
            Options(headers: requestHeaders, responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        print("요청 성공!");

        // 임시 디렉토리에 MP3 파일 저장
        final String filePath = '$tempPath/audio.mp3';
        File file = File(filePath);
        prePath = filePath;
        await file.writeAsBytes(response.data);
        _playAudio(filePath);
      } else {
        print("clova api 요청중 에러 발생 => ${response.statusCode}");
      }
    } catch (error) {
      // 이거 Exception Handling 어떻게 할건지 정해야하나 ㅜ.ㅜ 내 알아서?
      print("clova api 요청중 에러 발생 => ${error}");
    }
  }

  // 오디오 재생하기 -> private 으로.. 어차피 딴데서 실행안할거니까 일단 이렇게
  static void _playAudio(String filePath) {
    try {
      print("재생중");
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer
          .play(UrlSource(filePath)); // audioPlayer.playBytes(audioData);
    } catch (error) {
      print("재생 중 에러 발생");
      print(error);
    }
  }

  static void prePlayAudio() {
    try {
      if (prePath != "") {
        _playAudio(prePath);
      } else {
        print("음성이 존재하지 않습니다.");
      }
    } catch (error) {
      print("이전 음성이 존재하지 않습니다.");
    }
  }
}

class TTSFunction extends StatelessWidget {
  // 갖다쓸때 이거 갖다 쓰면됨
  final TTSManager ttsManager = TTSManager();
  // TextEditingController 인스턴스 -> 사용자의 입력을 받음
  final TextEditingController controller =
      TextEditingController(text: 'Hello world');

  final ClovaTTSManager clovaTTSManager = ClovaTTSManager();

  TTSFunction({super.key});

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
              child: const Text('Speak')),
          ElevatedButton(
              onPressed: () => {ClovaTTSManager.getTTS(controller.text)},
              child: const Text("tts")),
          ElevatedButton(
              onPressed: () => {ClovaTTSManager.prePlayAudio()},
              child: const Text("tts 다시듣기"))
        ],
      ),
    );
  }
}
