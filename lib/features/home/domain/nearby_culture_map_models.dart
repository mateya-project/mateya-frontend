import '../../../shared/activity_categories/activity_category_repository.dart';
import '../../../shared/localization/mateya_localizations.dart';

enum NearbyCultureMapLoadFailureType { network, server }

class NearbyCultureMapPlace {
  const NearbyCultureMapPlace({
    required this.id,
    required this.name,
    required this.address,
    required this.distanceKm,
    this.imageUrl,
    this.thumbnailUrl,
    this.latitude,
    this.longitude,
    this.categoryCode,
    this.categoryDetailCode,
    this.categoryDetailName,
    this.regionSido,
    this.regionSigungu,
  });

  final String id;
  final String name;
  final String address;
  final double distanceKm;
  final String? imageUrl;
  final String? thumbnailUrl;
  final double? latitude;
  final double? longitude;
  final String? categoryCode;
  final String? categoryDetailCode;
  final String? categoryDetailName;
  final String? regionSido;
  final String? regionSigungu;

  bool get hasCoordinates => latitude != null && longitude != null;
  String? get previewImageUrl => thumbnailUrl ?? imageUrl;

  String get badgeLabel {
    if (categoryDetailName != null && categoryDetailName!.trim().isNotEmpty) {
      return categoryDetailName!.trim();
    }
    final parts = <String>[
      if (regionSido != null && regionSido!.trim().isNotEmpty)
        regionSido!.trim(),
      if (regionSigungu != null && regionSigungu!.trim().isNotEmpty)
        regionSigungu!.trim(),
    ];
    return parts.isEmpty
        ? MateyaLocalizations.current.homeNearbyMapBadgeFallback
        : parts.join(' · ');
  }
}

class NearbyCultureMapRepositoryException implements Exception {
  const NearbyCultureMapRepositoryException(this.type, this.message);

  final NearbyCultureMapLoadFailureType type;
  final String message;
}

extension ActivityCategoryMetadataNearbyX on ActivityCategoryMetadata {
  List<ActivityCategoryDetailMetadata> get activeChildren =>
      children.where((detail) => detail.active).toList(growable: false);
}
