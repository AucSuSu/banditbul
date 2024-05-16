import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.focusNode,
  });

  final String text;
  final bool isUser;
  final FocusNode? focusNode; // FocusNode 추가

  @override
  Widget build(BuildContext context) {
    return Semantics(
      focused: focusNode != null && focusNode!.hasFocus,
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            color: isUser ? const Color(0xffFCF207) : const Color(0xffF1FFCA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            softWrap: true,
            maxLines: null,
          ),
        ),
      ),
    );
  }
}
