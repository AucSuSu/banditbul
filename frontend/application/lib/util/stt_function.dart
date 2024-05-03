import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceToTextPage extends StatefulWidget {
  const VoiceToTextPage({super.key});

  @override
  _VoiceToTextPageState createState() => _VoiceToTextPageState();
}

class _VoiceToTextPageState extends State<VoiceToTextPage> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String _text = '';
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initRecorder();
    _initPlayer();
  }

  Future<void> _requestPermissions() async {
    // 마이크로폰 권한 상태 확인
    var microphoneStatus = await Permission.microphone.status;
    if (!microphoneStatus.isGranted) {
      // 마이크로폰 권한 요청
      await Permission.microphone.request();
    }

    // 파일 쓰기 권한 상태 확인
    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      // 파일 쓰기 권한 요청
      await Permission.storage.request();
    }
  }

  Future<void> _initRecorder() async {
    try {
      await _recorder.openRecorder();
    } catch (e) {
      print('Failed to initialize recorder: $e');
      // 오류 처리 로직 추가
    }
  }

  Future<void> _initPlayer() async {
    await _player.openPlayer();
  }

  Future<void> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    _filePath = '${directory.path}/temp.wav';
    try {
      await _recorder.startRecorder(toFile: _filePath);
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print('Failed to start recorder: $e');
      // 오류 처리 로직 추가
    }
  }

  // Future<void> _startRecording() async {
  //   final directory = await getExternalStorageDirectory(); // 외부 저장소 경로 가져오기
  //   _filePath = '${directory!.path}/temp.wav'; // 외부 저장소의 경로에 파일 저장

  //   try {
  //     await _recorder.startRecorder(toFile: _filePath);
  //     setState(() {
  //       _isRecording = true;
  //     });
  //   } catch (e) {
  //     print('Failed to start recorder: $e');
  //   }
  // }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    if (_filePath != null && File(_filePath!).existsSync()) {
      _convertSpeechToText(_filePath!);
    } else {
      setState(() {
        _text = '녹음 파일을 찾을 수 없습니다.';
      });
    }
  }

  Future<void> _convertSpeechToText(String filePath) async {
    Dio dio = Dio();

    try {
      Response response = await dio.post(
          'https://clovaspeech-gw.ncloud.com/recog/v1/stt?lang=Kor',
          data: File(filePath).openRead(),
          options: Options(headers: {
            'X-CLOVASPEECH-API-KEY':
                '${dotenv.env['CLOVA_SPEECH_CLIENT_SECRET']}',
            'Content-Type': 'application/octet-stream',
          }));

      print(filePath);
      print(response);
      print('clova response 요청');
      if (response.statusCode == 200) {
        print('요청 성공');
        setState(() {
          _text = response.data['text'];
        });
      } else {
        setState(() {
          _text = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _text = 'Error: $e';
      });
    }
  }

  Future<void> _startPlaying() async {
    if (_filePath != null) {
      await _player.startPlayer(
          fromURI: _filePath,
          whenFinished: () {
            setState(() {
              _isPlaying = false;
            });
          });
      setState(() {
        _isPlaying = true;
      });
    }
  }

  Future<void> _stopPlaying() async {
    await _player.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('음성을 텍스트로 변환'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _text == '' ? const CircularProgressIndicator() : Text(_text),
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
            const SizedBox(height: 20),
            if (_filePath != null)
              ElevatedButton(
                onPressed: _isPlaying ? _stopPlaying : _startPlaying,
                child: Text(_isPlaying ? 'Stop Playing' : 'Play Recording'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }
}
