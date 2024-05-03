import 'dart:async';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoiceRecognitionService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _filePath;
  final String _text = '';

  VoiceRecognitionService() {
    _init();
  }

  void _init() async {
    await _requestPermissions();
    await _recorder.openRecorder();
    await _player.openPlayer();
  }

  Future<void> _requestPermissions() async {
    var microphoneStatus = await Permission.microphone.status;
    if (!microphoneStatus.isGranted) {
      await Permission.microphone.request();
    }

    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    _filePath = '${directory.path}/temp.wav';
    try {
      await _recorder.startRecorder(toFile: _filePath);
      _isRecording = true;
    } catch (e) {
      print('Failed to start recorder: $e');
    }
  }

  Future<String> stopRecording() async {
    await _recorder.stopRecorder();
    _isRecording = false;

    return _filePath ?? '';
  }

  Future<String> convertSpeechToText(String filePath) async {
    try {
      var dio = Dio();
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      var response = await dio.post(
          'https://clovaspeech-gw.ncloud.com/recog/v1/stt?lang=Kor',
          data: File(filePath).openRead(),
          options: Options(headers: {
            'X-CLOVASPEECH-API-KEY':
                '${dotenv.env['CLOVA_SPEECH_CLIENT_SECRET']}',
            'Content-Type': 'application/octet-stream',
          }));
      print('음성 정보 요청 완료');

      if (response.statusCode == 200) {
        print('음성 정보 변환 완료');
        return response.data['text'];
      } else {
        return "Failed to convert speech to text";
      }
    } catch (e) {
      return "Error occurred: $e";
    }
  }

  Future<void> startPlaying() async {
    if (_filePath != null) {
      await _player.startPlayer(
        fromURI: _filePath,
        whenFinished: () => _isPlaying = false,
      );
      _isPlaying = true;
    }
  }

  Future<void> stopPlaying() async {
    await _player.stopPlayer();
    _isPlaying = false;
  }

  String get text => _text;
  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;

  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
  }
}
