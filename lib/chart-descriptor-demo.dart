import 'dart:ui';

import 'package:fliechart/chart-descriptor.dart';
import 'package:fliechart/slice-descriptor.dart';
import 'package:flutter/material.dart';

class PieChartDemoDescriptor implements IPieChartDescriptor {
  @override
  Color get backgroundColor => null; // Colors.cyan.shade200;

  @override
  Color get foregroundColor => Colors.black;

  @override
  double get radiusFactor => 0.8;

  @override
  Color get rayColor => null; //Colors.blueAccent.shade400;

  @override
  int get numberOfRays => 10;

  @override
  List<ISliceDescriptor> get sliceDescriptors {
    List<ISliceDescriptor> slices = [];
    final slice1 = SliceDescriptor(value: 60, label: "A", color: Colors.yellow.withOpacity(0.5));
    final slice2 = SliceDescriptor(value: 30, label: "B", color: Colors.deepOrange);
    final slice3 = SliceDescriptor(value: 10, label: "C", color: Colors.blueGrey, detachFactor: 0.0);
    slices.add(slice1);
    slices.add(slice2);
    slices.add(slice3);
    return slices;
  }

  @override
  Color get shadowColor => Colors.grey.withOpacity(0.5);

  @override
  double get sizeFactor => 1.0;

  @override
  Color get gridColor => null; // Colors.blueAccent.shade400;

  @override
  int get numberOfGrids => 10;

  @override
  Color get frameColor => null; // Colors.black;

  @override
  double get ringFactor => null; // 0.3;
}
