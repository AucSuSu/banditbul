import 'dart:async';

import 'package:dio/dio.dart';
import 'package:frontend/store/RouteController.dart';
import 'package:frontend/util/beacon_scanner.dart';
import 'package:frontend/util/tts_function.dart';
import 'package:get/get.dart';

class BeaconController extends GetxController {
  // 가장 가까운 비콘 아이디 -> 계속 업데이트됨
  var beaconId = '싸피역1'.obs;

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
    if (routeController.freeMode.isTrue) {
      // 비콘 시설물 응답 정보 api 추가
      Dio dio = Dio();
      // 비콘 정보 말하는 api 임시 주석
      // try {
      //   var response =
      //       await dio.get('${dotenv.env['BASE_URL']}/beacon/info/싸피역3');

      //   var text = response.data['object'];
      //   clovaTTSManager.getTTS(text);
      // } catch (e) {
      //   print('비콘 시설물 응답 정보 api 에러 : $e');
      // }
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
