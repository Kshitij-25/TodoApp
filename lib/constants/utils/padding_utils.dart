import 'package:flutter/material.dart';

@immutable
class PaddingUtils {
  // Common padding values
  static const EdgeInsets smallPadding = EdgeInsets.all(8);
  static const EdgeInsets mediumPadding = EdgeInsets.all(16);
  static const EdgeInsets largePadding = EdgeInsets.all(24);

  // Symmetric paddings
  static const EdgeInsets horizontalSmall = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets horizontalMedium = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets horizontalLarge = EdgeInsets.symmetric(horizontal: 24);

  static const EdgeInsets verticalSmall = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets verticalLarge = EdgeInsets.symmetric(vertical: 24);

  // Specific paddings
  static const EdgeInsets topSmall = EdgeInsets.only(top: 8);
  static const EdgeInsets topMedium = EdgeInsets.only(top: 16);
  static const EdgeInsets topLarge = EdgeInsets.only(top: 24);

  static const EdgeInsets bottomSmall = EdgeInsets.only(bottom: 8);
  static const EdgeInsets bottomMedium = EdgeInsets.only(bottom: 16);
  static const EdgeInsets bottomLarge = EdgeInsets.only(bottom: 24);

  static const EdgeInsets leftSmall = EdgeInsets.only(left: 8);
  static const EdgeInsets leftMedium = EdgeInsets.only(left: 16);
  static const EdgeInsets leftLarge = EdgeInsets.only(left: 24);

  static const EdgeInsets rightSmall = EdgeInsets.only(right: 8);
  static const EdgeInsets rightMedium = EdgeInsets.only(right: 16);
  static const EdgeInsets rightLarge = EdgeInsets.only(right: 24);

  // Custom paddings
  static EdgeInsets custom({
    double? top,
    double? bottom,
    double? left,
    double? right,
    double? horizontal,
    double? vertical,
  }) {
    return EdgeInsets.only(
      top: top ?? 0,
      bottom: bottom ?? 0,
      left: left ?? 0,
      right: right ?? 0,
    );
  }

  static EdgeInsets symmetric({
    double? vertical,
    double? horizontal,
  }) {
    return EdgeInsets.symmetric(
      vertical: vertical ?? 0,
      horizontal: horizontal ?? 0,
    );
  }
}
