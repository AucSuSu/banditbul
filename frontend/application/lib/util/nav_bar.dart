import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('NavBar'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('NavBar'),
      ),
    );
  }
}
