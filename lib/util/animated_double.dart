import 'dart:ui';

import 'package:flutter/animation.dart';

class AnimatedDouble {
  static const animationDuration = 250;
  static const curve = Curves.ease;

  final int duration;
  DateTime _start = DateTime.now();

  double lastValue = 0;
  late double _value;

  AnimatedDouble(
    double value, {
    double from = 0.0,
    this.duration = animationDuration,
  }) {
    _value = from;
    setValue(value, from: from);
  }

  void setValue(double newValue, {double? from}) {
    if (_value == newValue) return;
    final now = DateTime.now();
    lastValue = from ?? value(now);
    _start = now;
    _value = newValue;
  }

  void setRealValue(double realValue) {
    setValue(realValue, from: realValue);
  }

  // Get an interpolated value
  double value(DateTime now) {
    final timeDifference =
        now.millisecondsSinceEpoch - _start.millisecondsSinceEpoch;
    return lastValue +
        (_value - lastValue) *
            curve.transform(clampDouble(timeDifference / duration, 0, 1));
  }

  get realValue => _value;
}
