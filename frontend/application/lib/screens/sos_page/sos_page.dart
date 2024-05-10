import 'package:flutter/material.dart';
import 'package:frontend/store/BeaconController.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:get/get.dart';

class SosPage extends StatefulWidget {
  const SosPage({super.key});

  @override
  _SosPageState createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  @override
  Widget build(BuildContext context) {
    BeaconController beaconController = Get.find<BeaconController>();

    // Obx 위젯을 사용하여 beaconId가 변경될 때마다 자동으로 업데이트
    return Scaffold(
      appBar: const TitleBar(),
      body: Center(
        child: Obx(() => Text(
              beaconController.beaconId.value,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
            )),
      ),
    );
  }
}
