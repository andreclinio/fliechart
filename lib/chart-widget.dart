

import 'package:flutter/widgets.dart';

import 'chart-descriptor.dart';
import 'chart-painter.dart';

class PieChart extends CustomPaint{

  PieChart(IPieChartDescriptor descriptor) : super(painter: PieChartPainter(descriptor), child: Container(width: 200, height: 400));
}