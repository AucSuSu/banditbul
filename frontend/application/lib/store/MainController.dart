import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:frontend/store/SessionController.dart';
import 'package:dio/dio.dart';

class MainController extends GetxController {
  // obs -> 관찰 가능한 변수로 만드는 거
  var uuId = const Uuid().obs;

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
