import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// General interface for slice definition inside a pie chart.
abstract class ISliceDescriptor {
  
  /// Numeric value associated to slice data
  double get value;

  /// Associated slice background color
  Color get color;

  /// Textual value for slice labelling.
  String get label;

  /// Label font size
  double labelSize;

  /// Label color
  Color get labelColor;

  /// Slice detach factor relative to pie chart axis size.
  double get detachFactor;

  /// Label radius factor relative to pie chart axis size.
  double get labelFactor;
}

/// Standard concrete class for slice descriptors.
class SliceDescriptor extends ISliceDescriptor {
  
  /// Storage field for [ISliceDescriptor.value]
 double _value;

  /// Storage field for [ISliceDescriptor.color]
 Color _color;

  /// Storage field for [ISliceDescriptor.labelColor]
   Color _labelColor;

  /// Storage field for [ISliceDescriptor.labelSize]
   double _labelSize;

  /// Storage field for [ISliceDescriptor.detachFactor]
   double _detachFactor;

  /// Storage field for [ISliceDescriptor.labelFactor]
   double _labelFactor;

  /// Storage field for [ISliceDescriptor.label]
   String _label;

  /// Default constructor with standard required parameters `value`, `label` and `color`. All other parameters can be unset. This will produce a char with default configuration.
  SliceDescriptor(
      {@required double value,
      @required String label,
      @required Color color,
      Color labelColor,
      double labelSize,
      double detachFactor,
      double textFactor})
      : this._value = value,
        this._color = color,
        this._label = label,
        this._labelColor = labelColor,
        this._labelSize = labelSize,
        this._detachFactor = detachFactor,
        this._labelFactor = textFactor;

  @override
  double get value => this._value;

  @override
  Color get color => this._color;

  @override
  String get label => this._label;

  @override
  Color get labelColor => this._labelColor;

  @override
  double get labelSize => this._labelSize;

  @override
  double get detachFactor => this._detachFactor;

  @override
  double get labelFactor => this._labelFactor;

  
  set value(double value) => this._value = value;

  set color(Color color) => this._color = color;

  set label(String label) => this._label = label;

  set labelColor(Color labelColor) => this._labelColor = labelColor;

  set labelSize(double labelSize) => this._labelSize = labelSize;

  set detachFactor(double detachFactor) => this._detachFactor = detachFactor;

  set labelFactor(double labelFactor) => this._labelFactor = labelFactor;

}
