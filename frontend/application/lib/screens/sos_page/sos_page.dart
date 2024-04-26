import 'package:flutter/material.dart';
import 'package:frontend/util/title_bar.dart';

class SosPage extends StatefulWidget {
  const SosPage({super.key});

  @override
  _SosPageState createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar(),
      body: Center(
        child: Text('ㅇㅇㅇ'),
      ),
    );
  }
}
