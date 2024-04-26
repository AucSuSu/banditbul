import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class ClovaStt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice to Text',
      home: VoiceToTextPage(),
    );
  }
}

class VoiceToTextPage extends StatefulWidget {
  @override
  _VoiceToTextPageState createState() => _VoiceToTextPageState();
}

class _VoiceToTextPageState extends State<VoiceToTextPage> {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String _text = '';
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    _filePath = '${directory.path}/temp.wav';
    await _recorder.startRecorder(toFile: _filePath);
    setState(() {
      _isRecording = true;
    });
  }

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
    dio.options.headers = {
      'X-CLOVASPEECH-API-KEY': 'SecretKey', // 실제 api_secret_key 입력
      'Content-Type': 'application/octet-stream',
    };

    var fileContent = File(filePath).readAsBytesSync();
    try {
      Response response = await dio.post(
          'https://clovaspeech-gw.ncloud.com/recog/v1/stt?lang=Kor',
          data: Stream.fromIterable(fileContent.map((e) => [e])));

      if (response.statusCode == 200) {
        setState(() {
          _text = response.data['text'];
          print(response);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('음성을 텍스트로 변환'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_text),
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Text(_isRecording ? '대화 중지' : '대화 시작'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}
