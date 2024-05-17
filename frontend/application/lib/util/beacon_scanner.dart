import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BeaconScanner {
  late StreamSubscription<List<ScanResult>> scanResultsSubscription;
  late StreamSubscription<bool> isScanningSubscription;
  bool isScanning = false;
  Set<ScanResult> scanResults = {};
  ScanResult? highestRssiAdminBeacon;
  Timer? restartScanTimer;
  Function(String macAddress)? onScanResultChanged;

  BeaconScanner({this.onScanResultChanged});

  void onInit() {
    isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      isScanning = state;
    });
    // print('BeaconScanner init');
  }

  Future<void> startScan() async {
    // print('비콘 탐지 시작 (in BeaconScanner)!');

    if (await requestPermissions()) {
      scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
        for (var result in results) {
          if (result.device.name.startsWith('admin')) {
            scanResults.add(result);
          }
          updateHighestRssiAdminBeacon();
          // 스캔 결과가 갱신될 때마다 콜백 호출
          // String? macAddress = getHighestRssiAdminBeaconMacAddress();
          // if (macAddress != null) {
          //   onScanResultChanged
          //       ?.call(macAddress); // Only call if macAddress is not null
          // }
        }
      });
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
      isScanning = true;
      stopTimer();
    }
  }

  void stopTimer() {
    restartScanTimer?.cancel(); // Cancel existing timer
    restartScanTimer = Timer(const Duration(seconds: 5, milliseconds: 200), () {
      stopScan();
      String? macAddress = getHighestRssiAdminBeaconMacAddress();
      if (macAddress != null) {
        onScanResultChanged?.call(macAddress); // MAC 주소가 null이 아닐 때만 콜백 호출
      }
    });
  }

  void stopScan() {
    if (isScanning) {
      FlutterBluePlus.stopScan();
      scanResults = {};
      scanResultsSubscription.cancel();
      isScanning = false;
      startScan();
    }
  }

  Future<bool> requestPermissions() async {
    // 위치 권한 상태를 확인합니다.
    var locationStatus = await Permission.locationWhenInUse.status;
    if (!locationStatus.isGranted) {
      // 위치 권한을 요청합니다.
      locationStatus = await Permission.locationWhenInUse.request();
      if (!locationStatus.isGranted) {
        return false; // 위치 권한이 거부되면 false를 반환
      }
    }

    // 블루투스 권한 상태를 확인합니다.
    var bluetoothStatus = await Permission.bluetooth.status;
    if (!bluetoothStatus.isGranted) {
      // 블루투스 권한을 요청합니다.
      bluetoothStatus = await Permission.bluetooth.request();
      if (!bluetoothStatus.isGranted) {
        return false; // 블루투스 권한이 거부되면 false를 반환
      }
    }

    return true; // 모든 권한이 승인되면 true를 반환
  }

  void updateHighestRssiAdminBeacon() {
    if (scanResults.isNotEmpty) {
      highestRssiAdminBeacon =
          scanResults.reduce((a, b) => a.rssi > b.rssi ? a : b);
    }
  }

  String? getHighestRssiAdminBeaconMacAddress() {
    return highestRssiAdminBeacon?.device.id.id;
  }

  void dispose() {
    if (isScanning) {
      stopScan();
    }
  }
}
