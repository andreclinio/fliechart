import 'dart:ui';
import 'dart:math';
import "package:flutter/material.dart";

import 'package:fliechart/chart-descriptor.dart';
import 'package:fliechart/slice-descriptor.dart';

/// Generic painter tha the customized widget.
class PieChartPainter extends CustomPainter {
  /// Piechar descriptor.
  final IPieChartDescriptor _descriptor;

  final Map<ISliceDescriptor, Path> _pathMap = Map<ISliceDescriptor, Path>();

  /// Default contructor with a `descriptor` parameter.
  PieChartPainter(IPieChartDescriptor descriptor) : this._descriptor = descriptor;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    var radiusFactor = this._descriptor.radiusFactor;
    if (radiusFactor < 0.1) radiusFactor = 0.1;
    if (radiusFactor > 1.0) radiusFactor = 1.0;
    final squareSize = size.shortestSide * radiusFactor;
    final center = size.center(Offset.zero);
    final fullRect = Rect.fromCenter(center: center, width: size.width, height: size.height);
    canvas.clipRect(fullRect, clipOp: ClipOp.intersect);

    // Pay attention to clear the path map!
    _pathMap.clear();

    final pieSquare = Rect.fromCenter(center: center, width: squareSize, height: squareSize);
    var paint = Paint();
    paint.isAntiAlias = true;

    // Paint background color, rays and grid before painting al slices.
    _drawBackground(canvas, paint, fullRect);
    _drawBackgroundRays(canvas, paint, fullRect);
    _drawBackgroundGrid(canvas, paint, fullRect);

    // Paint slices (with shadow if needed)
    final sum = _calculateSum();
    final bool hasShadow = this._descriptor.shadowColor != null;
    if (hasShadow) _drawSlices(canvas, paint, pieSquare, sum, true);
    _drawSlices(canvas, paint, pieSquare, sum, false);

    // Paint frame rectangler
    _drawForeground(canvas, paint, fullRect);

    canvas.save();
    canvas.restore();
  }

  /// Draws the background for the chart using the descriptor properties:
  /// [IPieChartDescriptor.backgroundColor] and [IPieChartDescriptor.frameColor].
  void _drawBackground(Canvas canvas, Paint paint, Rect fullRect) {
    var bgColor = this._descriptor.backgroundColor;
    _drawRectangle(canvas, paint, fullRect, bgColor, null);
  }

  /// Draws the background for the chart using the descriptor properties:
  /// [IPieChartDescriptor.backgroundColor] and [IPieChartDescriptor.frameColor].
  void _drawForeground(Canvas canvas, Paint paint, Rect fullRect) {
    var fgColor = this._descriptor.frameColor;
    paint.strokeWidth = 4.0;
    _drawRectangle(canvas, paint, fullRect, null, fgColor);
  }

  /// Draws a simple rectangle `rect` using `bgColor` and `fgColor` for the paint and stroke colors
  /// respectifully.
  void _drawRectangle(Canvas canvas, Paint paint, Rect rect, Color bgColor, Color fgColor) {
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

  /// Draws the arc based on current `paint` attributes for stroke and paint color.
  Path _drawArc(Canvas canvas, Paint paint, Offset center, double startRadius, double endRadius, double startRadian,
      double sweepRadian) {
    final path = _getArcPath(center, startRadius, endRadius, startRadian, sweepRadian);
    canvas.drawPath(path, paint);
    return path;
  }

  /// Get arc
  Path _getArcPath(Offset center, double startRadius, double endRadius, double startRadian, double sweepRadian) {
    final r1 = min(endRadius, startRadius);
    final r2 = max(endRadius, startRadius);
    final Path path = Path();
    final p1 = _calculateDirectedOffset(center, startRadian, r1);
    path.moveTo(p1.dx, p1.dy);
    path.arcTo(Rect.fromCircle(center: center, radius: r1), startRadian, sweepRadian, false);
    final p2 = _calculateDirectedOffset(center, startRadian + sweepRadian, r2);
    path.lineTo(p2.dx, p2.dy);
    path.arcTo(Rect.fromCircle(center: center, radius: r2), startRadian + sweepRadian, -sweepRadian, false);
    path.lineTo(p1.dx, p1.dy);
    return path;
  }

  /// Draws a circle based on current paint configuration.
  void _drawCircle(Canvas canvas, Paint paint, Offset center, double radius) {
    canvas.drawCircle(center, radius, paint);
  }

  /// Draws the circular grid (a set of circles) where the number of elements is defined by
  /// the [IPieChartDescriptor.gridFactor] configuration.
  void _drawBackgroundGrid(Canvas canvas, Paint paint, Rect fullRect) {
    final gridColor = _descriptor.gridColor;
    if (gridColor == null) return;
    final size = fullRect.longestSide;
    final gridFactor = _descriptor.gridFactor == null ? 0.25 : _descriptor.gridFactor.abs();
    final gridSize = size * gridFactor / 2.0;
    paint.strokeWidth = 1.0;
    paint.color = gridColor;
    for (double r = 0; r < size; r += gridSize) {
      _drawCircle(canvas, paint, fullRect.center, r);
    }
  }

  /// Draws the linear rays for the grid system.
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

  /// Draw a single ray for the grid system
  void _drawBackgroundRay(Canvas canvas, Paint paint, Rect fullRect, double a, Color rayColor) {
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

  /// Draw all the slices configured for the pie chart ([IPieChartDescriptor.slices]). The `asShadow`
  /// argument is defined for reuse while drawing shadows.
  void _drawSlices(Canvas canvas, Paint paint, Rect square, double sum, bool asShadow) {
    final slices = _descriptor.sliceDescriptors;
    if (slices == null) return;
    final startAngle = _descriptor.startAngle == null ? 0.0 : _descriptor.startAngle;
    final clockwise = _descriptor.clockwise != null ? _descriptor.clockwise : false;
    final direction = clockwise ? 1.0 : -1.0;
    final numSlices = slices.length;
    var angle = startAngle;
    for (int s = 0; s < numSlices; s++) {
      final slice = _descriptor.sliceDescriptors[s];
      if (slice == null) continue;
      final bgColor = asShadow ? _descriptor.shadowColor : slice.color;
      final fgColor = asShadow ? null : _descriptor.foregroundColor;
      final offset = asShadow ? Offset(5, 5) : null;
      final text = asShadow ? null : slice.label;
      final sliceAngle =
          _drawSlice(canvas, paint, square, slice, angle, sum, bgColor, fgColor, text, offset, direction);
      angle += sliceAngle;
    }
  }

  /// Draws a single slice
  double _drawSlice(Canvas canvas, Paint paint, Rect square, ISliceDescriptor slice, double initAngle, double sum,
      Color bgColor, Color fgColor, String text, Offset offset, double direction) {
    var ringFactor = _descriptor.ringFactor;
    if (ringFactor == null) ringFactor = 0.0;
    if (ringFactor < 0.0) ringFactor = 0.0;
    if (ringFactor > 0.99) ringFactor = 0.99;
    final angle = direction * slice.value / sum * pi * 2;
    final endRadius = square.shortestSide / 2.0;
    final startRadius = endRadius * ringFactor;
    final centerAngle = initAngle + angle / 2.0;

    final center = offset != null ? square.center.translate(offset.dx, offset.dy) : square.center;
    var sliceCenter = center;

    var detachRatio = slice.detachFactor;
    if (detachRatio != null) {
      if (detachRatio < 0.0) detachRatio = 0.0;
      if (detachRatio > 1.0) detachRatio = 1.0;
      sliceCenter = _calculateDirectedOffset(center, centerAngle, endRadius * detachRatio);
    }

    if (bgColor != null) {
      paint.style = PaintingStyle.fill;
      paint.color = bgColor;
      final path = _drawArc(canvas, paint, sliceCenter, startRadius, endRadius, initAngle, angle);
      _pathMap.putIfAbsent(slice, () => path);
    }
    if (fgColor != null) {
      paint.style = PaintingStyle.stroke;
      paint.color = fgColor;
      paint.strokeWidth = 1.0;
      _drawArc(canvas, paint, sliceCenter, startRadius, endRadius, initAngle, angle);
    }

    if (text != null) {
      final txtColor = slice.labelColor == null ? Colors.black : slice.labelColor;
      final txtFactor = slice.labelFactor == null ? 0.5 : slice.labelFactor;
      final txtSize = slice.labelSize == null ? 14.0 : slice.labelSize;
      final deltaRadius = endRadius - startRadius;
      final pt = _calculateDirectedOffset(sliceCenter, centerAngle, startRadius + (deltaRadius * txtFactor));
      final txtStyle = TextStyle(color: txtColor, fontSize: txtSize);
      final span = TextSpan(text: slice.label, style: txtStyle);
      final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, pt);
    }

    return angle;
  }

  /// Calculate a new target offset based on a `src`.
  Offset _calculateDirectedOffset(Offset src, double angle, double distance) {
    final x = src.dx + cos(angle) * distance;
    final y = src.dy + sin(angle) * distance;
    final tgt = Offset(x, y);
    return tgt;
  }

  /// Calculates the sum of all slice values.
  double _calculateSum() {
    final slices = _descriptor.sliceDescriptors;
    if (slices == null) return 0;
    final numSlices = slices.length;
    var sum = 0.0;
    for (int s = 0; s < numSlices; s++) {
      final slice = _descriptor.sliceDescriptors[s];
      if (slice == null) continue;
      sum += slice.value;
    }
    return sum;
  }

  /// Searches for a slice (path previosly stored) based on a coordinate ([offset]).
  /// Returns the slice descriptor.
  ISliceDescriptor findSlice(Offset offset) {
    ISliceDescriptor foundSlice;
    _pathMap.forEach((sld, pth) {
      // print("?? " + sld.label + " --- " +pth.getBounds().toString());
      if (pth.contains(offset)) {
        foundSlice = sld;
        // print("!!" + sld.label);
      }
    });
    return foundSlice;
  }
}
