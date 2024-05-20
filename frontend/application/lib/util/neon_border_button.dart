import 'package:flutter/material.dart';

class NeonBorderButton extends StatefulWidget {
  const NeonBorderButton(
      {super.key,
      required this.buttonText,
      required this.buttonColor,
      required this.borderColor,
      required this.textColor,
      this.onPressed});

  final String buttonText; // 버튼텍스트 내용과 색상을 prop으로 받음
  final Color buttonColor;
  final Color borderColor;
  final Color textColor;
  final VoidCallback? onPressed; // VoidCallback?으로 명시

  @override
  _NeonBorderButtonState createState() => _NeonBorderButtonState();
}

class _NeonBorderButtonState extends State<NeonBorderButton> {
  @override
  Widget build(BuildContext context) {
    Color buttonColor = widget.buttonColor; // prop 받은 색상을 buttonColor 설정
    Color borderColor = widget.borderColor; // prop 받은 색상을 borderColor로 설정
    Color textColor = widget.textColor; // prop 받은 색상을 textColor로 설정

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
        onPressed: widget.onPressed, // onPressed prop으로 받은 함수 실행
        child: Text(
          // 텍스트 설정
          widget.buttonText,
          style: TextStyle(
              fontSize: 24, color: textColor, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
