import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class DottedBorderText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final double strokeWidth;
  final Color color;
  final EdgeInsets padding;
  final BorderRadius borderRadius; // 추가된 BorderRadius

  const DottedBorderText({
    super.key,
    required this.text,
    required this.textStyle,
    this.strokeWidth = 2.0,
    this.color = Colors.black,
    this.padding = const EdgeInsets.all(8.0),
    this.borderRadius = BorderRadius.zero, // 기본값을 BorderRadius.zero로 설정
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(
          strokeWidth: strokeWidth, color: color, borderRadius: borderRadius),
      child: Container(
        width: double.infinity,
        padding: padding,
        child: Text(text, style: textStyle, textAlign: TextAlign.center),
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final BorderRadius borderRadius; // 추가된 속성

  DottedBorderPainter({
    required this.strokeWidth,
    required this.color,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final RRect rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        borderRadius.topLeft); // RRect를 사용하여 모서리 둥근 사각형 생성
    final Path path = Path()..addRRect(rrect);
    final dashedPath =
        dashPath(path, dashArray: CircularIntervalList<double>([5.0, 5.0]));

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
