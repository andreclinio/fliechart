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
    _drawBackgroundGrid(canvas, paint, fullRect);
    final sum = _calculateSum();

    final bool hasShadow = this._descriptor.shadowColor != null;
    if (hasShadow) _drawSlices(canvas, paint, pieSquare, sum, true);
    _drawSlices(canvas, paint, pieSquare, sum, false);
    canvas.save();
    canvas.restore();
  }

  void _drawBackground(Canvas canvas, Paint paint, Rect fullRect) {
    var bgColor = this._descriptor.backgroundColor;
    var fgColor = this._descriptor.frameColor;
    paint.strokeWidth = 4.0;
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
    double radiusMin,
    double radiusMax,
    double startRadian,
    double sweepRadian,
  ) {
    paint.strokeWidth = 1.0;
    final r1 = min(radiusMax, radiusMin);
    final r2 = max(radiusMax, radiusMin);
    final Path path = Path();
    final p1 = _moveTo(center, startRadian, r1);
    path.moveTo(p1.dx, p1.dy);
    path.arcTo(Rect.fromCircle(center: center, radius: r1), startRadian,
        sweepRadian, false);
    final p2 = _moveTo(center, startRadian + sweepRadian, r2);
    path.lineTo(p2.dx, p2.dy);
    path.arcTo(Rect.fromCircle(center: center, radius: r2),
        startRadian + sweepRadian, -sweepRadian, false);
    path.lineTo(p1.dx, p1.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void _drawBackgroundGrid(Canvas canvas, Paint paint, Rect fullRect) {
    final gridColor = this._descriptor.gridColor;
    if (gridColor == null) return;
    var numGrids = this._descriptor.numberOfGrids;
    if (numGrids == null) return;
    numGrids = numGrids.abs();
    final size = fullRect.shortestSide;
    for (double r = 0; r < size; r += size * (1.0 / numGrids)) {
      _drawArc(canvas, paint, fullRect.center, 0.0, r, 0, pi * 2);
    }
  }

  void _drawBackgroundRays(Canvas canvas, Paint paint, Rect fullRect) {
    final rayColor = this._descriptor.rayColor;
    if (rayColor == null) return;
    var rayNum = this._descriptor.numberOfRays;
    if (rayNum == null) return;
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
    final slices = this._descriptor.sliceDescriptors;
    if (slices == null) return 0;
    final numSlices = slices.length;
    var sum = 0.0;
    for (int s = 0; s < numSlices; s++) {
      final slice = this._descriptor.sliceDescriptors[s];
      if (slice == null) continue;
      sum += slice.value;
    }
    return sum;
  }

  void _drawSlices(
      Canvas canvas, Paint paint, Rect square, double sum, bool asShadow) {
    final slices = _descriptor.sliceDescriptors;
    if (slices == null) return;
    final numSlices = slices.length;
    var angle = 0.0;
    for (int s = 0; s < numSlices; s++) {
      final slice = _descriptor.sliceDescriptors[s];
      if (slice == null) continue;
      final bgColor = asShadow ? _descriptor.shadowColor : slice.color;
      final fgColor = asShadow ? null : _descriptor.foregroundColor;
      final offset = asShadow ? Offset(5, 5) : null;
      final text = asShadow ? null : slice.label;
      angle = _drawSlice(canvas, paint, square, slice, angle, sum, bgColor,
          fgColor, text, offset);
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
      Color fgColor,
      String text,
      Offset offset) {
    var ringFactor = _descriptor.ringFactor;
    if (ringFactor == null) ringFactor = 0.0;
    if (ringFactor < 0.0) ringFactor = 0.0;
    if (ringFactor > 0.99) ringFactor = 0.99;
    final angle = slice.value / sum * pi * 2;
    final endRadius = square.shortestSide / 2.0;
    final startRadius = endRadius * ringFactor;
    final centerAngle = initAngle + angle / 2.0;

    final center = offset != null
        ? square.center.translate(offset.dx, offset.dy)
        : square.center;
    var sliceCenter = center;

    var detachRatio = slice.detachFactor;
    if (detachRatio != null) {
      if (detachRatio < 0.0) detachRatio = 0.0;
      if (detachRatio > 1.0) detachRatio = 1.0;
      sliceCenter = _moveTo(center, centerAngle, endRadius * detachRatio);
    }

    if (bgColor != null) {
      paint.style = PaintingStyle.fill;
      paint.color = bgColor;
      _drawArc(
          canvas, paint, sliceCenter, startRadius, endRadius, initAngle, angle);
    }
    if (fgColor != null) {
      paint.style = PaintingStyle.stroke;
      paint.color = fgColor;
      _drawArc(
          canvas, paint, sliceCenter, startRadius, endRadius, initAngle, angle);
    }

    if (text != null) {
      final txtColor = slice.labelColor == null ? Colors.black : slice.labelColor;
      final txtFactor = slice.labelFactor == null ? 0.5 : slice.labelFactor;
      final deltaRadius = endRadius - startRadius;
      final pt = _moveTo(sliceCenter, centerAngle, startRadius + (deltaRadius * txtFactor));
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
