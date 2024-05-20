import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      centerTitle: true, // 제목이 가운데 오도록 함
      iconTheme: const IconThemeData(color: Colors.white), // 뒤로가기 버튼 하얀색
      title: Image.asset(
        'assets/images/bandi_bug.png',
        height: 40,
      ),
      automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // AppBar의 표준 높이 제공
}
