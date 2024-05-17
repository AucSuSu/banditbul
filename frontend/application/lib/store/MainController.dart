import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:frontend/store/SessionController.dart';
import 'package:dio/dio.dart';

class MainController extends GetxController {
  // 관찰 가능하게 obs
  var uuId = ''.obs;

  // 초기화 메소드에서 uuId 값을 설정해주기 -> 자동 실행됨요
  @override
  void onInit() {
    super.onInit();
    uuId.value = Uuid().v4();
    print('Generated UUID: ${uuId.value}');
  }

  void getSessionId(String beaconId) async {
    SessionController sessionController = Get.find<SessionController>();

    try {
      Dio dio = Dio();
      final response = await dio.get(
        "https://banditbul.co.kr/api/sos/$beaconId",
      );

      print(response);
      var sessionId = response.data['object']['sessionId'];
      sessionController.setSessionId(sessionId);
    } catch (error) {
      print(error);
    }
  }
}
