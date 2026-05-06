import 'package:flutter/material.dart';

class AppMotion {
  // Durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  // Curves
  static const Curve easeSpring = Cubic(0.34, 1.56, 0.64, 1);
  static const Curve easeSmooth = Curves.easeInOutCubic;

  // Animation values
  static const double entrySlideOffset = 20;
}
