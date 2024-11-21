import 'dart:math';
import 'package:flutter/material.dart';

class LoadingDotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF009FE3)
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    for (int i = 0; i < 8; i++) {
      final double angle = (i * pi / 4);
      final double x = centerX + radius * cos(angle);
      final double y = centerY + radius * sin(angle);

      final double dotRadius = 3 - (i * 0.2);

      canvas.drawCircle(
        Offset(x, y),
        dotRadius.clamp(1.0, 3.0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
