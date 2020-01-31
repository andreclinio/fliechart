import 'dart:ui';
import 'dart:math';
import "package:flutter/material.dart";

import 'package:fliechart/chart-descriptor.dart';
import 'package:fliechart/slice-descriptor.dart';

class PieChartPainter extends CustomPainter {
  final IPieChartDescriptor _descriptor;

  PieChartPainter(IPieChartDescriptor descriptor)
      : this._descriptor = descriptor;

  @override
  void paint(Canvas canvas, Size size) {
    var radiusFactor = this._descriptor.radiusFactor;
    if (radiusFactor < 0.1) radiusFactor = 0.1;
    if (radiusFactor > 1.0) radiusFactor = 1.0;
    final squareSize = size.shortestSide * radiusFactor;
    final center = size.center(Offset.zero);
    final fullRect =
        Rect.fromCenter(center: center, width: size.width, height: size.height);
    canvas.clipRect(fullRect, clipOp: ClipOp.intersect);

    final pieSquare =
        Rect.fromCenter(center: center, width: squareSize, height: squareSize);
    var paint = Paint();
    paint.isAntiAlias = true;

    _drawBackground(canvas, paint, fullRect);
    _drawBackgroundRays(canvas, paint, fullRect);
    final sum = _calculateSum();

    final bool hasShadow = this._descriptor.shadowColor != null;
    if (hasShadow) _drawSlices(canvas, paint, pieSquare, sum, true);
    _drawSlices(canvas, paint, pieSquare, sum, false);
    canvas.save();
    canvas.restore();
  }

  void _drawBackground(Canvas canvas, Paint paint, Rect fullRect) {
    var bgColor = this._descriptor.bgColor;
    var fgColor = this._descriptor.fgColor;
    paint.strokeWidth = 2.0;
    _drawRect(canvas, paint, fullRect, bgColor, fgColor);
  }

  void _drawRect(
      Canvas canvas, Paint paint, Rect rect, Color bgColor, Color fgColor) {
    if (bgColor != null) {
      paint.color = bgColor;
      paint.style = PaintingStyle.fill;
      canvas.drawRect(rect, paint);
    }
    if (fgColor != null) {
      paint.color = fgColor;
      paint.style = PaintingStyle.stroke;
      canvas.drawRect(rect, paint);
    }
  }

  void _drawArc(
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

  void _drawBackgroundRays(Canvas canvas, Paint paint, Rect fullRect) {
    final rayColor = this._descriptor.rayColor;
    if (rayColor == null) return;
    var rayNum = this._descriptor.numRays;
    if (rayNum == null) rayNum = 6;
    rayNum = rayNum.abs();

    final pi2 = pi * 2;
    final deltaAngle = pi2 / rayNum;
    for (double a = 0; a < pi2; a += deltaAngle) {
      _drawBackgroundRay(canvas, paint, fullRect, a, rayColor);
    }
  }

  void _drawBackgroundRay(
      Canvas canvas, Paint paint, Rect fullRect, double a, Color rayColor) {
    paint.style = PaintingStyle.stroke;
    paint.color = rayColor;
    paint.strokeWidth = 1.0;
    final center = fullRect.center;
    final radius = fullRect.width + fullRect.height;
    final x = center.dx + cos(a) * radius;
    final y = center.dy + sin(a) * radius;
    final pt = Offset(x, y);
    canvas.drawLine(center, pt, paint);
  }

  double _calculateSum() {
    final slices = this._descriptor.slices;
    if (slices == null) return 0;
    final numSlices = slices.length;
    var sum = 0.0;
    for (int s = 0; s < numSlices; s++) {
      final slice = this._descriptor.slices[s];
      if (slice == null) continue;
      sum += slice.value;
    }
    return sum;
  }

  void _drawSlices(
      Canvas canvas, Paint paint, Rect square, double sum, bool asShadow) {
    final slices = this._descriptor.slices;
    if (slices == null) return;
    final numSlices = slices.length;
    var angle = 0.0;
    for (int s = 0; s < numSlices; s++) {
      final slice = this._descriptor.slices[s];
      if (slice == null) continue;
      final bgColor = asShadow ? Colors.grey : slice.bgColor;
      final fgColor = asShadow ? null : this._descriptor.fgColor;
      final offset = asShadow ? Offset(5, 5) : null;
      final text = asShadow ? null: slice.label;
      angle = _drawSlice(
          canvas, paint, square, slice, angle, sum, bgColor, fgColor, text, offset);
    }
  }

  double _drawSlice(
      Canvas canvas,
      Paint paint,
      Rect square,
      ISliceDescriptor slice,
      double initAngle,
      double sum,
      Color bgColor,
      Color fgColor, String text,
      Offset offset) {
    final angle = slice.value / sum * pi * 2;
    final radius = square.shortestSide / 2.0;
    final centerAngle = initAngle + angle / 2.0;

    final center = offset != null
        ? square.center.translate(offset.dx, offset.dy)
        : square.center;
    var sliceCenter = center;

    var detachRatio = slice.detachRatio;
    if (detachRatio != null) {
      if (detachRatio < 0.0) detachRatio = 0.0;
      if (detachRatio > 1.0) detachRatio = 1.0;
      sliceCenter = _moveTo(center, centerAngle, radius * detachRatio);
    }

    if (bgColor != null) {
      paint.style = PaintingStyle.fill;
      paint.color = bgColor;
      _drawArc(canvas, paint, sliceCenter, radius, initAngle, angle);
    }
    if (fgColor != null) {
      paint.style = PaintingStyle.stroke;
      paint.color = fgColor;
      _drawArc(canvas, paint, sliceCenter, radius, initAngle, angle);
    }

    if (text != null) {
      final txtColor = slice.txtColor == null ? Colors.black : slice.txtColor;
      final pt = _moveTo(sliceCenter, centerAngle, radius * 0.5);
      final span =
          TextSpan(text: slice.label, style: TextStyle(color: txtColor));
      final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, pt);
    }

    return initAngle + angle;
  }

  Offset _moveTo(Offset src, double angle, double distance) {
    final x = src.dx + cos(angle) * distance;
    final y = src.dy + sin(angle) * distance;
    final tgt = Offset(x, y);
    return tgt;
  }
}
