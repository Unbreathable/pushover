import 'dart:math';

import 'package:flutter/material.dart';

// The best logging framework
void sendLog(Object? object) {
  print(object);
}

const noTextHeight = TextHeightBehavior(
  applyHeightToFirstAscent: false,
  applyHeightToLastDescent: false,
);

Widget verticalSpacing(double height) {
  return SizedBox(height: height);
}

Widget horizontalSpacing(double width) {
  return SizedBox(width: width);
}

String getRandomString(int length) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final random = Random();
  return String.fromCharCodes(
    List.generate(
      length,
      (index) => chars.codeUnitAt(random.nextInt(chars.length)),
    ),
  );
}

const defaultSpacing = 8.0;
const elementSpacing = defaultSpacing * 0.5;
const elementSpacing2 = elementSpacing * 1.5;
const sectionSpacing = defaultSpacing * 2;
const modelBorderRadius = defaultSpacing * 1.5;
const modelPadding = defaultSpacing * 2;
const dialogBorderRadius = defaultSpacing * 1.5;
const dialogPadding = defaultSpacing * 1.5;
const scaleAnimationCurve = ElasticOutCurve(1.1);
