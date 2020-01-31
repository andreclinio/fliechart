import 'dart:ui';

import 'package:fliechart/chart-descriptor.dart';
import 'package:fliechart/slice-descriptor.dart';
import 'package:flutter/material.dart';

class PieChartDemoDescriptor implements IPieChartDescriptor {
  @override
  Color get bgColor => Colors.cyan.shade200;

  @override
  Color get fgColor => Colors.black;

  @override
  double get radiusFactor => 0.8;

  @override
  Color get rayColor => Colors.blueAccent.shade400;

  @override
  double get numRays => 10;

  @override
  List<ISliceDescriptor> get slices {
    List<ISliceDescriptor> slices = [];
    final slice1 = SliceDescriptor(value: 60, label: "A", bgColor: Colors.red.withOpacity(0.8));
    final slice2 = SliceDescriptor(value: 30, label: "B", bgColor: Colors.green);
    final slice3 = SliceDescriptor(value: 10, label: "C", bgColor: Colors.yellow, detachRatio: 0.3);
    slices.add(slice1);
    slices.add(slice2);
    slices.add(slice3);
    return slices;
  }

  @override
  Color get shadowColor => Colors.grey.withOpacity(0.5);
}
