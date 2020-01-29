import "package:flutter/material.dart";

import 'dart:math';

class PieChartPainter extends CustomPainter {
  PieChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset(0,0));
    var paint = Paint();
    paint.color = Colors.grey[900];
    paint.style = PaintingStyle.stroke;
    paint.isAntiAlias = true;
    _drawPie(canvas, paint, center, 10, 0.0, pi);
    canvas.save();
    canvas.restore();
  }

  void _drawPie(
    Canvas canvas,
    Paint paint,
    Offset center,
    double radius,
    startRadian,
    sweepRadian,
  ) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startRadian,
      sweepRadian,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
