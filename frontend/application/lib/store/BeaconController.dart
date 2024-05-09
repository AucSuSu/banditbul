import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/arrive_page/arrive_page.dart';
import 'package:frontend/store/RouteController.dart';
import 'package:frontend/util/beacon_scanner.dart';
import 'package:frontend/util/tts_function.dart';
import 'package:get/get.dart';

class BeaconController extends GetxController {
  // 가장 가까운 비콘 아이디 -> 계속 업데이트됨
  var beaconId = ''.obs;

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
    if (routeController.checkBeacon(beaconId.value)) {
      routeController.nextBeacon(); // 일치할 경우 다음 비콘으로 이동
    }
    // freeMode 필터
    if (routeController.freeMode.isTrue) {
      // 지하철 내린후 개찰구는 말하지 않는 조건
      if (!(beaconId.value == routeController.route2.first['beaconId'])) {
        // 비콘 시설물 응답 정보 api 추가
        Dio dio = Dio();
        try {
          var response = await dio
              .get('${dotenv.env['BASE_URL']}/beacon/info/${beaconId.value}');

          var text = response.data['object'];
          clovaTTSManager.getTTS(text);
          // 마지막 비콘일 경우 도착 페이지로 이동 하는 로직
          if ((routeController.route2.isEmpty &&
                  beaconId.value == routeController.route1.last['beaconId']) ||
              (routeController.route2.isNotEmpty &&
                  beaconId.value == routeController.route2.last['beaconId'])) {
            clovaTTSManager.getTTS(text);
            Future.delayed(Duration(seconds: 5), () {
              Get.to(() => ArrivePage()); // TTS 재생 후 5초 기다린 다음 페이지 이동
            });
          }
        } catch (e) {
          print('비콘 시설물 응답 정보 api 에러 : $e');
        }
      }
    }
  }

  void startBeaconScanning() {
    final BeaconScanner beaconScanner = BeaconScanner(
      onScanResultChanged: (macAddress) {
        setBeaconId(macAddress);
      },
    );

    beaconScanner.startScan();
    // periodicScanner = Timer.periodic(const Duration(seconds: 5), (timer) {
    //   print('RSSI 가장 큰 값 5초마다 실행중');
    //   String? highestRssiBeaconMac =
    //       beaconScanner.getHighestRssiAdminBeaconMacAddress();
    //   if (highestRssiBeaconMac != null) {
    //     print('highestRssiBeaconMac: $highestRssiBeaconMac');
    //     print('비콘 아이디: ${beaconId.value}');
    //     setBeaconId(highestRssiBeaconMac);
    //   } else {
    //     print('highestRssiBeaconMac is null');
    //     setBeaconId('null');
    //     print('비콘 아이디: ${beaconId.value}');
    //   }
    // });
  }

  // @override
  // void onClose() {
  //   beaconScanner.stopScan();
  //   periodicScanner?.cancel();
  //   super.onClose();
  // }
}
