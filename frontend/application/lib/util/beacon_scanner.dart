import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BeaconScanner {
  late StreamSubscription<List<ScanResult>> scanResultsSubscription;
  bool isScanning = false;
  Set<ScanResult> scanResults = {};
  ScanResult? highestRssiAdminBeacon;
  Timer? restartScanTimer;

  BeaconScanner();

  Future<void> startScan() async {
    print('비콘 탐지 시작 (in BeaconScanner)!');

    if (await requestPermissions()) {
      scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
        for (var result in results) {
          scanResults.add(result);
          updateHighestRssiAdminBeacon();
        }
      });
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
      isScanning = true;
      stopTimer();
    }
  }

  void stopTimer() {
    restartScanTimer?.cancel(); // Cancel existing timer
    restartScanTimer = Timer(const Duration(seconds: 11), stopScan);
  }

  void stopScan() {
    if (isScanning) {
      FlutterBluePlus.stopScan();
      scanResults = {};
      scanResultsSubscription.cancel();
      isScanning = false;
      restartScanTimer?.cancel();
      restartScanTimer = Timer(const Duration(seconds: 5), startScan);
    }
  }

  Future<bool> requestPermissions() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isGranted) {
      return true;
    }
    var newStatus = await Permission.locationWhenInUse.request();
    return newStatus.isGranted;
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
