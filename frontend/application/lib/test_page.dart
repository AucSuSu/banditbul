import 'package:flutter/material.dart';
import 'package:frontend/util/beacon_scanner.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final BeaconScanner _beaconScanner = BeaconScanner();

  @override
  void initState() {
    super.initState();
    _beaconScanner.startScan();
  }

  @override
  void dispose() {
    _beaconScanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beacon Scanner Test Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => setState(() {}), // 스캔 결과를 갱신하기 위해 UI를 재구성
              child: const Text('Refresh Scan Results'),
            ),
            Expanded(
              child: _beaconScanner.scanResults.isNotEmpty
                  ? ListView(
                      children: _beaconScanner.scanResults.map((result) {
                        return ListTile(
                          title: Text(result.device.name),
                          subtitle: Text('RSSI: ${result.rssi}'),
                          trailing: Text(result.device.id.id),
                        );
                      }).toList(),
                    )
                  : const Center(
                      child: Text('No beacons found.',
                          style: TextStyle(fontSize: 16))),
            ),
            _beaconScanner.highestRssiAdminBeacon != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        const Text('Highest RSSI Admin Beacon',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                            'Name: ${_beaconScanner.highestRssiAdminBeacon!.device.name}'),
                        Text(
                            'MAC Address: ${_beaconScanner.highestRssiAdminBeacon!.device.id.id}'),
                      ],
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No high signal beacon detected.',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
          ],
        ),
      ),
    );
  }
}
