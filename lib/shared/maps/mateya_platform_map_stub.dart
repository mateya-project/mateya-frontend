import 'package:flutter/widgets.dart';

import 'mateya_platform_map_models.dart';

class MateyaPlatformMap extends StatelessWidget {
  const MateyaPlatformMap({
    super.key,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.zoom,
    required this.markers,
    this.showScaleControl = true,
    this.bottomPadding = 0,
    this.onMapReady,
    this.onMapLoaded,
  });

  final double centerLatitude;
  final double centerLongitude;
  final double zoom;
  final List<MateyaPlatformMapMarker> markers;
  final bool showScaleControl;
  final double bottomPadding;
  final VoidCallback? onMapReady;
  final VoidCallback? onMapLoaded;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand();
  }
}
