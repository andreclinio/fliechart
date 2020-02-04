import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class ISliceDescriptor {
  double get value;
  Color get color;
  String get label;
  Color get labelColor;
  double get detachFactor;
  double get labelFactor;
}

class SliceDescriptor extends ISliceDescriptor {
  final double _value;
  final Color _color;
  final Color _labelColor;
  final double _detachFactor;
  final double _labelFactor;
  final String _label;

  SliceDescriptor(
      {@required double value,
      @required String label,
      @required Color color,
      Color labelColor,
      double detachFactor,
      double textFactor})
      : this._value = value,
        this._color = color,
        this._label = label,
        this._labelColor = labelColor,
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
  double get detachFactor => this._detachFactor;

  @override
  double get labelFactor => this._labelFactor;
}
