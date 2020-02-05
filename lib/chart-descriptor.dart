import 'package:fliechart/slice-descriptor.dart';
import "package:flutter/material.dart";

/// General interface for pie chart descriptor where applications can extend this class
/// to override chart defintions based on its own data.
abstract class IPieChartDescriptor {
  /// Background color for the chart (can be null where no backgound is defined).
  Color get backgroundColor;

  // Foreground color for stroke lines for slices (can be null where no lines are defined).
  Color get foregroundColor;

  /// Pie chart radius size (based on widget size). Tipically this factor is set wight values
  /// between the interval (0, 1.0].
  double get radiusFactor;

  /// Color for rays at the grid system. A null value indicates no rays.
  Color get rayColor;

  /// Color for the grid system. A null value indicates no grid.
  Color get gridColor;

  /// Color for the slice shadows. A null value indicates no shadows.
  Color get shadowColor;

  /// Chart external rectangle frame color. A null value indicates no frame.
  Color get frameColor;

  /// Chart relative size, when compared to full screen size.
  double get sizeFactor;

  /// Number of linear rays for the chart grid system.
  int get numberOfRays;

  /// Size of interior grid spacing for pie chart. This value is relative to chart radius size.
  double get gridFactor;

  /// List of slice descriptors.
  List<ISliceDescriptor> get sliceDescriptors;

  /// Size of interior hole radius for pie chart, which adjust a ring drawing style.
  /// This value is relative to chart radius size.
  double get ringFactor;

  /// Start slice drawing angle.
  double get startAngle;

  /// Flag for indicating clockwise slice drawing direction.
  bool get clockwise;
}

class PieChartDescriptor extends IPieChartDescriptor {
  final List<ISliceDescriptor> _sliceDescriptors;
  final Color _backgroundColor;
  final Color _foregroundColor;
  final Color _frameColor;
  final Color _gridColor;
  final Color _rayColor;
  final Color _shadowColor;
  final double _radiusFactor;
  final int _numberOfRays;
  final double _gridFactor;
  final double _sizeFactor;
  final double _ringFactor;
  final double _startAngle;
  final bool _clockwise;

  PieChartDescriptor(
      {@required List<ISliceDescriptor> sliceDescriptors,
      Color backgroundColor,
      Color foregroundColor,
      Color frameColor,
      Color gridColor,
      Color rayColor,
      Color shadowColor,
      int numberOfRays,
      double gridFactor,
      double radiusFactor,
      double sizeFactor,
      double ringFactor,
      double startAngle,
      bool clockwise})
      : this._sliceDescriptors = sliceDescriptors,
        this._backgroundColor = backgroundColor,
        this._foregroundColor = foregroundColor,
        this._frameColor = frameColor,
        this._gridColor = gridColor,
        this._rayColor = rayColor,
        this._shadowColor = shadowColor,
        this._numberOfRays = numberOfRays,
        this._gridFactor = gridFactor,
        this._radiusFactor = radiusFactor,
        this._sizeFactor = sizeFactor,
        this._ringFactor = ringFactor,
        this._startAngle = startAngle,
        this._clockwise = clockwise;

  @override
  Color get backgroundColor => _backgroundColor;

  @override
  Color get foregroundColor => _foregroundColor;

  @override
  Color get frameColor => _frameColor;

  @override
  Color get gridColor => _gridColor;

  @override
  Color get rayColor => _rayColor;

  @override
  Color get shadowColor => _shadowColor;

  @override
  double get radiusFactor => _radiusFactor;

  @override
  int get numberOfRays => _numberOfRays;

  @override
  double get gridFactor => _gridFactor;

  @override
  List<ISliceDescriptor> get sliceDescriptors => _sliceDescriptors;

  @override
  double get sizeFactor => _sizeFactor;

  @override
  double get ringFactor => _ringFactor;

  @override
  double get startAngle => _startAngle;

  @override
  bool get clockwise => _clockwise;
}
