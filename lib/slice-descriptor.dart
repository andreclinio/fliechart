

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class ISliceDescriptor {

  double get value;
  Color get bgColor;
  String get label;
  Color get txtColor;
  double get detachRatio;

}


class SliceDescriptor extends ISliceDescriptor{
  
  final double _value;
  final Color _bgColor;
  final Color _txtColor;
  final double _detachRatio;

  final String _label;

  SliceDescriptor({@required double value, @required String label, @required Color bgColor, 
  Color txtColor, double detachRatio}) : 
  this._value = value, this._bgColor = bgColor, 
  this._label = label, this._txtColor = txtColor,
  this._detachRatio = detachRatio;

  @override
  double get value => this._value;

  @override
  Color get bgColor => this._bgColor;

  @override
  String get label => this._label;

  @override
  Color get txtColor => this._txtColor;

  @override
  double get detachRatio => this._detachRatio;
}