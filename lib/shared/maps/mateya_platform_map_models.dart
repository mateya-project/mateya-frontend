import 'package:flutter/widgets.dart';

@immutable
class MateyaPlatformMapMarker {
  const MateyaPlatformMapMarker({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.label,
    this.isSelected = false,
    this.onTap,
  });

  final String id;
  final double latitude;
  final double longitude;
  final String? label;
  final bool isSelected;
  final VoidCallback? onTap;
}
