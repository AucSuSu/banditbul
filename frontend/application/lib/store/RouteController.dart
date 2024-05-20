import 'package:get/get.dart';

class RouteController extends GetxController {
  var route1 = [].obs;
  var route2 = [].obs;
  var currentRouteIndex = 0.obs;
  var nextRouteIndex = 1.obs;
  var currentRoute = RxList<dynamic>.empty(); // 현재 활성화된 루트
  var freeMode = true.obs; // freeMode 상태

  void setRoute1(List<dynamic> route) {
    route1.value = route;
    currentRoute.value = route1;
    currentRouteIndex.value = 0;
    nextRouteIndex.value = 1;
    freeMode.value = false;
  }

  void setRoute2(List<dynamic> route) {
    route2.value = route;
  }

  // 다음 비콘으로 이동하는 함수
  void nextBeacon() {
    if (nextRouteIndex <= currentRoute.length - 2) {
      nextRouteIndex++;
      currentRouteIndex++;
    } else {
      if (currentRoute == route1) {
        freeMode.value = true; // route1이 끝나면 freeMode 활성화
        if (route2.isNotEmpty) {
          // 화장실이 아닌 역안내 일경우 route2로 안내하는 로직
          setRoute1([]); // route1 초기화
          currentRoute.value = route2; // route2로 변경
          currentRouteIndex.value = 0; // 인덱스 초기화
          nextRouteIndex.value = 1;
        }
      } else {
        setRoute2([]); // route2 초기화
        freeMode.value = true;
      }
    }
  }

  // 비콘 ID 체크와 route2 시작 검증
  bool checkBeacon(String beaconId) {
    if (currentRoute.isNotEmpty) {
      if (freeMode.isTrue && beaconId == route2.first['beaconId']) {
        freeMode.value = false; // 첫 번째 route2 비콘을 만나면 freeMode 비활성화
      }
      return currentRoute[nextRouteIndex.value]['beaconId'] == beaconId;
    } else {
      return false;
    }
  }
}
