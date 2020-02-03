
import 'package:fliechart/slice-descriptor.dart';
import "package:flutter/material.dart";

abstract class IPieChartDescriptor {
  Color get backgroundColor;
  Color get foregroundColor;
  double get radiusFactor;
  Color get rayColor;
  Color get shadowColor;
  Color get frameColor => null;
  double get sizeRatio;
  Color get gridColor;
  int get numberOfRays;
  int get numberOfGrids;
  List<ISliceDescriptor> get sliceDescriptors;

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
  final int _numberOfGrids;
  final double _sizeRatio;

  PieChartDescriptor({
      @required List<ISliceDescriptor> sliceDescriptors,
      Color backgroundColor,
      Color foregroundColor,
      Color frameColor,
      Color gridColor,
      Color rayColor,
      Color shadowColor,
      int numberOfRays,
      int numberOfGrids,
      double radiusFactor,
      double sizeRatio
      })
      : 
        this._sliceDescriptors = sliceDescriptors,
      this._backgroundColor = backgroundColor,
        this._foregroundColor = foregroundColor,
        this._frameColor = frameColor,
        this._gridColor = gridColor,
        this._rayColor = rayColor,
        this._shadowColor = shadowColor,
        this._numberOfRays = numberOfRays,
        this._numberOfGrids = numberOfGrids,
        this._radiusFactor = radiusFactor,
        this._sizeRatio = sizeRatio;

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
  int get numberOfGrids => _numberOfGrids;

  @override
  List<ISliceDescriptor> get sliceDescriptors => _sliceDescriptors;

  @override
  double get sizeRatio => _sizeRatio;
}
