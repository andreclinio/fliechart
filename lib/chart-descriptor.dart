import 'package:fliechart/slice-descriptor.dart';
import "package:flutter/material.dart";

abstract class IPieChartDescriptor {
  Color get bgColor;
  Color get fgColor;
  double get radiusFactor;
  Color get rayColor;
  double get numRays;
  List<ISliceDescriptor> get slices;
  Color get shadowColor;
}

class PieChartDescriptor extends IPieChartDescriptor {
  
  final Color _bgColor;

  PieChartDescriptor({Color bgColor}) : this._bgColor = bgColor;

  @override
  Color get bgColor => _bgColor;

  @override
  Color get fgColor => null;

  @override
  double get radiusFactor => null;

  @override
  Color get rayColor => null;

  @override
  double get numRays => null;

  @override
  Color get shadowColor => null;

  @override
  List<ISliceDescriptor> get slices => null;
}
