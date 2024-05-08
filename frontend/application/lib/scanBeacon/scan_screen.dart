import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Set<ScanResult> _scanResults = {}; // 중복된 결과를 피하기 위해 Set을 사용.
  List<ScanResult> _filteredResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;
  TextEditingController _filterController = TextEditingController();
  Timer? _restartScanTimer;
  Timer? _debounceTimer; // TextField의 입력 처리를 위한 debounce timer

  List<String> adminNames = ['admin7', 'admin6', 'admin4', 'admin1'];
  int nextAdminIndex = 0;
  List<String> findNames = [];
  ScanResult? _highestRssiResult; // 가장 높은 RSSI 값을 갖는 결과를 저장

  @override
  void initState() {
    super.initState();
    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      setState(() {
        _isScanning = state;
      });
    });

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        for (var result in results) {
          if (result.device.name == adminNames[nextAdminIndex]) {
            nextAdminIndex++;
            findNames.add(result.device.name);
          }
          _scanResults.add(result); // Set에 결과 추가 (자동 중복 제거)
        }
        _filterResults();
        _updateHighestRssiResult(); // 가장 높은 RSSI 값을 갖는 디바이스 업데이트
      });
    });

    _startScan();
  }

  void _startScan() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
    _isScanning = true;
    _stopTimer();
  }

  void _stopTimer() {
    _restartScanTimer?.cancel(); // 기존에 존재하는 Timer를 취소
    _restartScanTimer = Timer(Duration(seconds: 11), _stopScan);
  }

  void _stopScan() {
    FlutterBluePlus.stopScan();
    _resetScan();
  }

  void _resetScan() {
    _filteredResults = [];
    _scanResults = {};
    _isScanning = false;
    _restartScanTimer?.cancel();
    _restartScanTimer = Timer(Duration(seconds: 5), _startScan);
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    _filterController.dispose();
    _restartScanTimer?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _filterResults() {
    _filteredResults = _scanResults.where((result) {
      return result.device.name
          .toLowerCase()
          .contains(_filterController.text.toLowerCase());
    }).toList();
  }

  void _updateHighestRssiResult() {
    _highestRssiResult = _filteredResults.isNotEmpty
        ? _filteredResults.reduce((a, b) => a.rssi > b.rssi ? a : b)
        : null;
  }

  void _onFilterChanged(String value) {
    _debounceTimer?.cancel(); // 기존의 debounce timer가 있을 경우 취소
    _debounceTimer = Timer(Duration(milliseconds: 300), () {
      _filterResults(); // 사용자 입력 완료 후 300ms 뒤에 필터링 실행
      _updateHighestRssiResult(); // 필터링 후 가장 높은 RSSI 결과 업데이트
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비콘 스캐너'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _startScan(),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (nextAdminIndex < adminNames.length)
                    Text('다음 찾아야 할 이름: ${adminNames[nextAdminIndex]}'),
                  SizedBox(height: 16),
                  Text('찾은 이름: ${findNames.join(", ")}'),
                  SizedBox(height: 16),
                  Text(
                      '현재 가장 높은 rssi: ${_highestRssiResult?.device.name ?? "N/A"}, ${_highestRssiResult?.device.id.id ?? "N/A"}, ${_highestRssiResult?.rssi ?? "N/A"}'),
                  SizedBox(height: 16),
                  TextField(
                    controller: _filterController,
                    decoration: InputDecoration(
                      labelText: '이름으로 장치 필터링',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _filterController.clear();
                          _filterResults();
                          setState(() {});
                        },
                      ),
                    ),
                    onChanged: _onFilterChanged, // Debounce를 위한 onChanged 처리
                  ),
                ],
              ),
            ),
            ..._filteredResults
                .map((result) => ListTile(
                      title: Text(result.device.name ?? 'Unknown Device'),
                      subtitle: Text(
                          'MAC: ${result.device.id.id} - RSSI: ${result.rssi}'),
                    ))
                .toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isScanning ? _stopScan : _startScan,
        tooltip: 'Scan',
        child: Icon(_isScanning ? Icons.stop : Icons.search),
      ),
    );
  }
}
