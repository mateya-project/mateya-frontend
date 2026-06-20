import 'dart:math' as math;

import 'package:flutter/material.dart';

abstract final class AppResponsive {
  static const double compactWidthBreakpoint = 375;
  static const double expandedWidthBreakpoint = 430;
  static const double tabletBreakpoint = 600;
  static const double compactHeightBreakpoint = 760;

  static Size screenSize(BuildContext context) => MediaQuery.sizeOf(context);

  static bool isCompactWidth(BuildContext context) =>
      screenSize(context).width < compactWidthBreakpoint;

  static bool isExpandedPhoneWidth(BuildContext context) =>
      screenSize(context).width >= expandedWidthBreakpoint;

  static bool isTablet(BuildContext context) =>
      screenSize(context).shortestSide >= tabletBreakpoint;

  static bool isCompactHeight(BuildContext context) =>
      screenSize(context).height < compactHeightBreakpoint;

  static double horizontalPadding(
    BuildContext context, {
    double compact = 16,
    double regular = 20,
    double expanded = 24,
    double tablet = 28,
  }) {
    if (isTablet(context)) {
      return tablet;
    }
    if (isExpandedPhoneWidth(context)) {
      return expanded;
    }
    if (isCompactWidth(context)) {
      return compact;
    }
    return regular;
  }

  static double contentMaxWidth(
    BuildContext context, {
    double phone = 560,
    double tablet = 760,
  }) {
    return isTablet(context) ? tablet : phone;
  }

  static double clampedHeight(
    BuildContext context, {
    required double ideal,
    required double min,
    required double max,
    double compactHeightScale = 0.82,
    double regularScale = 0.92,
  }) {
    final scale = isCompactHeight(context)
        ? compactHeightScale
        : isTablet(context)
        ? 1
        : regularScale;
    return (ideal * scale).clamp(min, max).toDouble();
  }

  static double keyboardAwareBottomPadding(
    BuildContext context, {
    double minimum = 20,
  }) {
    return math.max(minimum, MediaQuery.viewInsetsOf(context).bottom + 12);
  }

  static BoxConstraints dialogConstraints(
    BuildContext context, {
    double maxWidth = 420,
    double maxHeightFactor = 0.9,
  }) {
    final size = screenSize(context);
    final availableWidth = size.width == 0
        ? maxWidth
        : math.max(0.0, size.width - 24);
    final availableHeight = size.height == 0
        ? double.infinity
        : size.height * maxHeightFactor;
    return BoxConstraints(
      maxWidth: math.min(maxWidth, availableWidth),
      maxHeight: availableHeight,
    );
  }
}
