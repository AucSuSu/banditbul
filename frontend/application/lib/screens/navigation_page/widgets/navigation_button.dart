import 'package:flutter/material.dart';

class NavigationButton extends StatefulWidget {
  const NavigationButton(
      {super.key,
      required this.buttonText,
      required this.buttonColor,
      required this.borderColor});

  final String buttonText; // 버튼텍스트 내용과 색상을 prop으로 받음
  final Color buttonColor;
  final Color borderColor;

  @override
  _NavigationButtonState createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  @override
  Widget build(BuildContext context) {
    Color buttonColor = widget.buttonColor; // prop 받은 색상을 buttonColor 설정
    Color borderColor = widget.borderColor; // prop 받은 색상을 borderColor로 설정

    return Container(
      // 텍스트 버튼을 감싸는 container
      width: double.infinity, // 가로 길이를 무한대로 설정
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // 그림자 효과로 네온효과를 나타냄
          for (double i = 1; i < 5; i++)
            BoxShadow(
              spreadRadius: -1,
              color: i <= 3 ? Colors.white : borderColor,
              blurRadius: 4 * i,
            ),
        ],
      ),
      child: TextButton(
        // 텍스트 버튼 설정
        style: TextButton.styleFrom(
          side: BorderSide(color: buttonColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: buttonColor,
        ),
        onPressed: () {
          // 차후에 버튼을 눌렀을때 해야 할 일 함수를 prop 받아서 실행하면 됨
        },
        child: Text(
          // 텍스트 설정
          widget.buttonText,
          style: TextStyle(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
