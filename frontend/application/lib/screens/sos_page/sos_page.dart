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
    var tmpText = Get.find<BeaconController>().beaconId.value;
    return Scaffold(
      appBar: TitleBar(),
      body: Center(
        child: Text(
          tmpText,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
