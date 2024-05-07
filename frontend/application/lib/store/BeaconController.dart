import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/store/RouteController.dart';
import 'package:frontend/util/tts_function.dart';
import 'package:get/get.dart';

class BeaconController extends GetxController {
  // 가장 가까운 비콘 아이디 -> 계속 업데이트됨
  var beaconId = '싸피역1'.obs;

  final RouteController routeController = Get.find<RouteController>();
  ClovaTTSManager clovaTTSManager = ClovaTTSManager();

  // 전체 페이지에서 백그라운드로 동작하게 코드 설정
  @override
  void onInit() {
    super.onInit();
    startBeaconScanning();
  }

  void setBeaconId(String id) async {
    beaconId.value = id;
    if (routeController.checkBeacon(beaconId.value)) {
      routeController.nextBeacon(); // 일치할 경우 다음 비콘으로 이동
    }
    if (routeController.freeMode.isTrue) {
      // 비콘 시설물 응답 정보 api 추가
      Dio dio = Dio();
      try {
        var response =
            await dio.get('${dotenv.env['BASE_URL']}/beacon/info/싸피역3');

        var text = response.data['object'];
        clovaTTSManager.getTTS(text);
      } catch (e) {
        print('비콘 시설물 응답 정보 api 에러 : $e');
      }
    }
  }

  void startBeaconScanning() {
    // 여기에 비콘 스캐닝 로직 구현
    // 예시를 위한 가짜 타이머 로직
    // Timer.periodic(Duration(seconds: 5), (timer) {
    //   // 각 5초마다 비콘 ID를 업데이트
    //   var newBeaconId = 'beacon${Random().nextInt(100)}'; // 랜덤 비콘 ID
    //   setBeaconId(newBeaconId);
    // });
  }
}
