import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color background = Color(0xFFFFFFFF);
  static const Color appSurface = Color(0xFFF4F5F6);
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF868B94);
  static const Color textMuted = Color(0xFF5E5E5E);
  static const Color fieldBorder = Color(0xFF848984);
  static const Color fieldBorderLight = Color(0xFFB7B7B7);
  static const Color disabledSurface = Color(0xFFE9E9EB);
  static const Color brandGreen = Color(0xFF008731);
  static const Color brandGreenLight = Color(0xFF5AC366);
  static const Color softGreenBorder = Color(0xFFE8F7EE);
  static const Color darkButton = Color(0xFF2A3038);
  static const Color disabledButton = Color(0xFFD9DEE5);
  static const Color disabledText = Color(0xFF98A2B3);
  static const Color navInactive = Color(0xFFC9CCD4);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color error = Color(0xFFD92D20);
  static const Color overlay = Color(0x80000000);
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color subtleBackground = Color(0xFFF5F7FA);
}

abstract final class AppSpacing {
  static const double screenHorizontal = 24;
  static const double sectionGap = 32;
  static const double fieldGap = 24;
  static const double buttonHeight = 54;
  static const double inputHeight = 52;
  static const double headerHeight = 80;
  static const double fieldRadius = 12;
  static const double primaryRadius = 16;
}
