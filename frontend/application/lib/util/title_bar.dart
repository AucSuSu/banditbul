import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      centerTitle: true, // 제목이 가운데 오도록 함
      iconTheme: IconThemeData(color: Colors.white), // 뒤로가기 버튼 하얀색
      title: Text(
        // 제목
        '반딧불',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
      automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // AppBar의 표준 높이 제공
}
