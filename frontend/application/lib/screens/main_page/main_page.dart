import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메인 페이지'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('메인 페이지'),
      ),
    );
  }
}
