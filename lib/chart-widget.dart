

import 'package:flutter/widgets.dart';

import 'chart-descriptor.dart';
import 'chart-painter.dart';

class PieChart extends CustomPaint {

  PieChart(BuildContext context, IPieChartDescriptor descriptor) : 
  super(painter: PieChartPainter(descriptor), child: _buildContainer(context, descriptor));

  static Container _buildContainer(BuildContext context, IPieChartDescriptor descriptor) {
    var sizeRatio = descriptor.sizeFactor;
    if (sizeRatio == null || sizeRatio <= 0.01)  sizeRatio = 1.0;
    sizeRatio = sizeRatio.abs();
    final screenSize = MediaQuery.of(context).size;
    final chartSize = screenSize.shortestSide * sizeRatio; 

    return Container(width: chartSize, height: chartSize);
    
  }
}