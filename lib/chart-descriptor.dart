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

  Size get size;
}

class PieChartDescriptor extends IPieChartDescriptor {
  final Color _bgColor;

  PieChartDescriptor({Color bgColor}) : this._bgColor = bgColor;

  @override
  Color get bgColor => _bgColor;

  @override
  Color get fgColor => null;

  @override
  // TODO: implement
  double get radiusFactor => null;

  @override
  // TODO: implement
  Color get rayColor => null;

  @override
  // TODO: implement
  double get numRays => null;

  @override
  // TODO: implement
  Color get shadowColor => null;

  @override
  // TODO: implement
  List<ISliceDescriptor> get slices => null;

  @override
  // TODO: implement
  Size get size => null;
}
