import 'dart:math';
import 'dart:ui';

import 'package:fliechart/chart-descriptor.dart';
import 'package:fliechart/slice-descriptor.dart';
import 'package:flutter/material.dart';

/// Demonstration pie chart descritor
class PieChartDemoDescriptor implements IPieChartDescriptor {

static List<ISliceDescriptor> _slices = [
    SliceDescriptor(value: 10, label: "A", color: Colors.yellow.withOpacity(0.5), detachFactor: 0.1),
    SliceDescriptor(value: 20, label: "B", color: Colors.deepOrange, detachFactor: 0.2),
    SliceDescriptor(value: 50, label: "C", color: Colors.blueGrey)
];
    
  @override
  Color get backgroundColor => Colors.cyan[50];

  @override
  Color get foregroundColor => Colors.black;

  @override
  double get radiusFactor => 0.8;

  @override
  Color get rayColor => Colors.grey;

  @override
  int get numberOfRays => 10;

  @override
  List<ISliceDescriptor> get sliceDescriptors {
    return _slices;
  }

  @override
  Color get shadowColor => Colors.grey.withOpacity(0.5);

  @override
  Size get size => Size(200, 200);

  @override
  Color get gridColor => Colors.grey;

  @override
  double get gridFactor => 0.20;

  @override
  Color get frameColor => Colors.black;

  @override
  double get ringFactor => 0.3;

  @override
  double get startAngle => pi / 2.0;

  @override
  bool get clockwise => true;
}
