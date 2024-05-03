import 'package:get/get.dart';

class SessionController extends GetxController {
  // obs -> 관찰 가능한 변수로 만드는 거
  var sessionId = 'initSessionId'.obs;

  void setSessionId(String id) {
    sessionId.value = id;
  }
}
