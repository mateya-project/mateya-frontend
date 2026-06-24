import '../../../shared/logging/app_logger.dart';

class WebNeighborhoodLookupResult {
  const WebNeighborhoodLookupResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
    this.context = const <String, Object?>{},
  });

  final String displayName;
  final double latitude;
  final double longitude;
  final Map<String, Object?> context;
}

Future<WebNeighborhoodLookupResult?> reverseGeocodeNeighborhoodOnWeb({
  required double latitude,
  required double longitude,
  required AppLogger logger,
}) async {
  return null;
}

Future<WebNeighborhoodLookupResult?> geocodeNeighborhoodQueryOnWeb({
  required String query,
  required AppLogger logger,
}) async {
  return null;
}
