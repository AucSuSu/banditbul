import 'package:flutter/material.dart';

class WriteChatBubble extends StatefulWidget {
  const WriteChatBubble({
    super.key,
    required this.controller,
    required this.isUser,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final bool isUser;
  final void Function(String)? onSubmitted; // 입력 완료 시 실행할 함수

  @override
  _WriteChatBubbleState createState() => _WriteChatBubbleState();
}

class _WriteChatBubbleState extends State<WriteChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color:
              widget.isUser ? const Color(0xffFCF207) : const Color(0xffF1FFCA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: widget.controller,
          decoration: const InputDecoration(
            border: InputBorder.none, // 테두리 없음
            hintText: '대화 입력', // 입력 필드 안내 텍스트
          ),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          onSubmitted: widget.onSubmitted, // 입력 완료 시 처리
        ),
      ),
    );
  }
}
