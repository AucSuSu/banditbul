import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationApp extends StatefulWidget {
  const LocationApp({super.key});

  @override
  _LocationAppState createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp> {
  final Location location = Location();
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // 위치 서비스 접근 권한 확인
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // 현재 위치 데이터 가져오기
    _locationData = await location.getLocation();
    setState(() {});

    // 위치 업데이트 리스닝
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _locationData = currentLocation;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('위치 안내'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(_locationData != null
            ? '위도: ${_locationData!.latitude}, 경도: ${_locationData!.longitude}, 방위: ${_locationData!.heading}'
            : '로딩중...'),
      ),
    );
  }
}
