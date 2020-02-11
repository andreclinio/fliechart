import 'package:fliechart/chart-callbacks.dart';
import 'package:flutter/widgets.dart';

import 'chart-descriptor.dart';
import 'chart-painter.dart';

class PieChart extends StatelessWidget {
  
  /// Descriptor (see [IPieChartDescriptor])
  final IPieChartDescriptor _descriptor;

  final IPieChartCallbacks _callbacks;

  /// Default constructor
  PieChart({@required IPieChartDescriptor descriptor, IPieChartCallbacks callbacks}) : 
  this._descriptor = descriptor,
  this._callbacks = callbacks;


  @override
  Widget build(BuildContext context) {
    var size = _descriptor.size;
    if (size == null) size = Size(100, 100);
    return _buildGesture(context, size);
  }

  Widget _buildGesture(BuildContext context, Size size) {
    final chartPainter = _buildChartPainter(context);
    return GestureDetector(
      onTapDown: (details) {
        if (_callbacks == null) return;
        if (_callbacks.tappedSlice == null) return;
        final tappedCallback = _callbacks.tappedSlice;
        RenderBox box = context.findRenderObject();
        final global = details.globalPosition;
        final local = box.globalToLocal(global);
        final foundSlice = chartPainter.findSlice(local);
        if (foundSlice != null && tappedCallback != null) {
          tappedCallback(_descriptor, foundSlice);
        }
      },
      child: _buildCustomPaint(chartPainter, size),
    );
  }

  PieChartPainter _buildChartPainter(BuildContext context) {
    return PieChartPainter(_descriptor);
  }

  Widget _buildCustomPaint(PieChartPainter chartPainter, Size size) {
    return CustomPaint(
      size: size,
      painter: chartPainter,
    );
  }
}
