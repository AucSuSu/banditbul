import 'package:get/get.dart';

class BeaconController extends GetxController {
  // 가장 가까운 비콘 아이디 -> 계속 업데이트됨
  var beaconId = 'initBeaconId'.obs;

  void setBeaconId(String id) {
    beaconId.value = id;
  }
}
