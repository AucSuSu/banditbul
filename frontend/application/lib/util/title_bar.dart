import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '반딧불',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // AppBar의 표준 높이 제공
}
