

import 'package:flutter/widgets.dart';

import 'chart-descriptor.dart';
import 'chart-painter.dart';

class PieChart extends CustomPaint {

  PieChart(IPieChartDescriptor descriptor) : 
  super(painter: PieChartPainter(descriptor), child: _buildContainer(descriptor));

  static Container _buildContainer(IPieChartDescriptor descriptor) {
    var size = descriptor.size;
    if (size == null)  size = Size(400, 400);
    return Container(width: size.width, height: size.height);
    
  }
}