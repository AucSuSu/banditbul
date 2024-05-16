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
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      beaconController.setBeaconId('');
                    },
                    child: const Text(
                      '비콘 아이디 리셋',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    )),
                TextButton(
                    onPressed: () {
                      beaconController.setBeaconId('D0:41:AE:8E:5C:0A');
                    },
                    child: const Text(
                      '비콘 아이디 변경',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    )),
                Text(
                  beaconController.beaconId.value,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  '폰트 테스트',
                  style: TextStyle(
                    fontFamily: 'NotoSansKR',
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
