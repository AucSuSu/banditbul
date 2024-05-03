import 'package:flutter/material.dart';
// tts package import
// import 'package:flutter_tts/flutter_tts.dart';
// dio
import 'package:dio/dio.dart';
// audio Player
import 'package:audioplayers/audioplayers.dart';
// File
import 'package:path_provider/path_provider.dart';
import 'dart:io';
//env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// class TTSManager {
//   // tts사용을 위해 FlutterTts 인스턴스 생성
//   final FlutterTts tts = FlutterTts();

//   TTSManager() {
//     tts.setLanguage('ko-KR'); // 언어
//     tts.setSpeechRate(0.4); // 읽기 속도 조절
//   }

//   void speak(String text) {
//     tts.speak(text);
//   }
// }

/** clova api문서 
 * curl -i -X POST \
	-H "Content-Type:application/x-www-form-urlencoded" \
	-H "X-NCP-APIGW-API-KEY-ID:{애플리케이션 등록 시 발급받은 client id값}" \
	-H "X-NCP-APIGW-API-KEY:{애플리케이션 등록 시 발급받은 client secret값}" \
	-d 'speaker=nara&text=만나서 반갑습니다&volume=0&speed=0&pitch=0&format=mp3' \
 'https://naveropenapi.apigw.ntruss.com/tts-premium/v1/tts'
 */

class ClovaTTSManager {
  String prePath = "";
  late final String url;
  late final String clientId;
  late final String clientSecret;
  late final Map<String, dynamic> requestHeaders;

  ClovaTTSManager() {
    try {
      print("초기화");
      print(dotenv.env['CLOVA_SPEAK_URL'] ?? "");
      url = dotenv.env['CLOVA_SPEAK_URL'] ?? "";
      clientId = dotenv.env['CLOVA_SPEAK_CLIENT_ID'] ?? "";
      clientSecret = dotenv.env['CLOVA_SPEAK_CLIENT_SECRET'] ?? "";
      requestHeaders = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-NCP-APIGW-API-KEY-ID': clientId,
        'X-NCP-APIGW-API-KEY': clientSecret,
      };
    } catch (error) {
      print("초기화 에러 : $error");
    }
  }

  static Dio dio = Dio();

  void getTTS(String text) async {
    // 요청 데이터
    final Map<String, dynamic> requestData = {
      'speaker': 'mijin', // -> 물어보고 뭐가 제일 나은지 정하기
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
      print("clova api 요청중 에러 발생 => $error");
    }
  }

  // 오디오 재생하기 -> private 으로.. 어차피 딴데서 실행안할거니까 일단 이렇게
  void _playAudio(String filePath) {
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

  void replayAudio() {
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
  // final TTSManager ttsManager = TTSManager();
  // TextEditingController 인스턴스 -> 사용자의 입력을 받음
  final TextEditingController controller =
      TextEditingController(text: 'Hello world');

  ClovaTTSManager clovaTTSManager = ClovaTTSManager();

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
                // ttsManager.speak(controller.text);
              },
              child: const Text('Speak')),
          ElevatedButton(
              onPressed: () => {clovaTTSManager.getTTS(controller.text)},
              child: const Text("tts")),
          ElevatedButton(
              onPressed: () => {
                    clovaTTSManager.replayAudio()
                    // test 용
                    // clovaTTSManager.sosCheck()
                  },
              child: const Text("tts 다시듣기"))
        ],
      ),
    );
  }
}
