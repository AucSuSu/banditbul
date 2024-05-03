import 'package:get/get.dart';

class RouteController extends GetxController {
  var route1 = [].obs;
  var route2 = [].obs;

  void setRoute1(List<dynamic> route) {
    route1.value = route;
  }

  void setRoute2(List<dynamic> route) {
    route2.value = route;
  }
}
