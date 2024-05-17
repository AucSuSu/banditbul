import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/main_page/main_page.dart';
import 'package:frontend/test_navigate_page.dart';
import 'package:frontend/store/BeaconController.dart';
import 'package:frontend/store/RouteController.dart';
import 'package:frontend/store/SessionController.dart';
import 'package:frontend/store/MainController.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:android_intent_plus/android_intent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  // 전역 관리를 위한 컨트롤러
  Get.put(RouteController());
  Get.put(BeaconController());
  Get.put(SessionController());
  Get.put(MainController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isBluetoothOn = false;

  @override
  void initState() {
    super.initState();
    _listenToBluetoothState();
  }

  void _listenToBluetoothState() {
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      setState(() {
        _isBluetoothOn = (state == BluetoothAdapterState.on);
      });

      if (state == BluetoothAdapterState.on) {
        // Bluetooth is turned on, proceed to the main page
        Get.offAll(() => const TestNavigatePage());
      } else if (state == BluetoothAdapterState.off) {
        // Bluetooth is turned off, open the Bluetooth settings
        _openBluetoothSettings();
      }
    });
  }

  void _openBluetoothSettings() async {
    const intent = AndroidIntent(
      action: 'android.settings.BLUETOOTH_SETTINGS',
    );
    await intent.launch();
    // Check Bluetooth state again after returning from settings
    _checkBluetoothState();
  }

  void _checkBluetoothState() async {
    final state = await FlutterBluePlus.adapterState.first;
    if (state == BluetoothAdapterState.off) {
      // If Bluetooth is still off, show the prompt again
      Get.offAll(() => const BluetoothOffPage());
    } else {
      // If Bluetooth is on, navigate to the main page
      Get.offAll(() => const TestNavigatePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'SBaggro',
      ),
      home:
          _isBluetoothOn ? const TestNavigatePage() : const BluetoothOffPage(),
    );
  }
}

class BluetoothOffPage extends StatelessWidget {
  const BluetoothOffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Open Bluetooth settings when the user tries to pop the screen
        const intent = AndroidIntent(
          action: 'android.settings.BLUETOOTH_SETTINGS',
        );
        await intent.launch();
        return false;
      },
      child: const Scaffold(
        backgroundColor: Colors.black,
        appBar: TitleBar(),
        body: Center(
          child: Text(
            '블루투스를 켜주세요',
            style: TextStyle(
              fontSize: 45,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
