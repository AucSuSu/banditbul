import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/arrive_page/arrive_page.dart';
import 'package:frontend/store/RouteController.dart';
import 'package:frontend/store/MainController.dart';
import 'package:frontend/util/beacon_scanner.dart';
import 'package:frontend/util/tts_function.dart';
import 'package:frontend/util/websocket.dart';
import 'package:get/get.dart';
import 'package:frontend/store/SessionController.dart';

class BeaconController extends GetxController {
  // 가장 가까운 비콘 아이디 -> 계속 업데이트됨
  var beaconId = ''.obs;
  // 비콘 아이디를 통해 저장될 역 명
  var stationName = ''.obs;

  final RouteController routeController = Get.find<RouteController>();
  ClovaTTSManager clovaTTSManager = ClovaTTSManager();

  Timer? periodicScanner;

  // 전체 페이지에서 백그라운드로 동작하게 코드 설정
  @override
  void onInit() {
    super.onInit();
    print('BeaconController init');

    startBeaconScanning();
  }

  void setBeaconId(String id) async {
    beaconId.value = id;
    Get.find<MainController>().getSessionId(id);
    WebsocketManager().connect();
    WebsocketManager().sendMessage(MessageDto(
        type: "BEACON",
        beaconId: id,
        sessionId: Get.find<SessionController>().sessionId.value,
        uuId: Get.find<MainController>().uuId.value.toString()));

    if (routeController.checkBeacon(beaconId.value)) {
      routeController.nextBeacon(); // 일치할 경우 다음 비콘으로 이동
    }
    // freeMode 필터
    if (routeController.freeMode.value == true) {
      // 지하철 내린후 개찰구는 말하지 않는 조건
      if (routeController.route2.isNotEmpty &&
          beaconId.value == routeController.route2.first['beaconId']) {
        // route2 시작 비콘일 경우 스킵
      } else {
        // 비콘 시설물 응답 정보 api

        Dio dio = Dio();
        try {
          var response = await dio
              .get('${dotenv.env['BASE_URL']}/beacon/info/${beaconId.value}');

          var text = response.data['object'];
          print(text);
          // 마지막 비콘일 경우 도착 페이지로 이동 하는 로직
          if ((routeController.route1.isNotEmpty &&
                  routeController.route2.isEmpty &&
                  beaconId.value == routeController.route1.last['beaconId']) ||
              (routeController.route2.isNotEmpty &&
                  beaconId.value == routeController.route2.last['beaconId'])) {
            clovaTTSManager.getTTS(text);
            Future.delayed(const Duration(seconds: 10), () {
              Get.to(() => const ArrivePage()); // TTS 재생 후 10초 기다린 다음 페이지 이동
            });
          } else {
            // print(text);
            clovaTTSManager.getTTS(text);
          }
        } catch (e) {
          print('비콘 시설물 응답 정보 api 에러 : $e');
        }
      }
    }
  }

  void setStationName(String name) {
    stationName.value = name;
  }

  void startBeaconScanning() {
    final BeaconScanner beaconScanner = BeaconScanner(
      onScanResultChanged: (macAddress) {
        if (beaconId.value != macAddress) {
          setBeaconId(macAddress);
        }
      },
    );

    beaconScanner.startScan();
  }

  @override
  void onClose() {
    super.onClose();
    clovaTTSManager.dispose(); // 여기서 dispose 호출
  }
}
