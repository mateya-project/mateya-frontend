import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

import '../domain/onboarding_flow.dart';

abstract interface class NeighborhoodLocationRepository {
  Future<LocationLookupResult> resolveCurrentNeighborhood();
  Future<LocationLookupResult> resolveNeighborhoodQuery(String query);
}

class DeviceNeighborhoodLocationRepository
    implements NeighborhoodLocationRepository {
  @override
  Future<LocationLookupResult> resolveCurrentNeighborhood() async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        return const LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.serviceDisabled,
            '위치 서비스가 꺼져 있어요. 직접 입력으로 진행해 주세요.',
          ),
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        return const LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.permissionDenied,
            '위치 권한이 없으면 현재 위치 자동 인증을 사용할 수 없어요. 직접 입력은 계속 진행할 수 있고, 권한을 허용하면 다시 시도할 수 있어요.',
          ),
        );
      }

      if (permission == LocationPermission.deniedForever) {
        return const LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.permissionPermanentlyDenied,
            '위치 권한이 꺼져 있어 현재 위치 자동 인증을 사용할 수 없어요. 앱 설정에서 권한을 허용하거나 직접 입력으로 계속 진행해 주세요.',
          ),
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (position.accuracy > 500) {
        return const LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.accuracyTooLow,
            '위치 정확도가 낮아 자동 인증이 어려워요.',
          ),
        );
      }

      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        return const LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.geocodingFailed,
            '주소를 찾지 못했어요. 직접 입력으로 진행해 주세요.',
          ),
        );
      }

      final district = _extractDistrictName(placemarks.first);
      return LocationLookupResult.success(
        NeighborhoodSelection(
          displayName: district,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } catch (_) {
      return const LocationLookupResult.failure(
        LocationFailure(
          LocationFailureType.unknown,
          '위치를 불러오지 못했어요. 직접 입력으로 진행해 주세요.',
        ),
      );
    }
  }

  @override
  Future<LocationLookupResult> resolveNeighborhoodQuery(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return const LocationLookupResult.failure(
        LocationFailure(
          LocationFailureType.locationUnavailable,
          '동네명을 입력해 주세요.',
        ),
      );
    }

    try {
      final locations = await geocoding.locationFromAddress('$trimmed, 대한민국');
      if (locations.isEmpty) {
        return const LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.locationUnavailable,
            '입력한 동네를 찾지 못했어요.',
          ),
        );
      }

      final first = locations.first;
      final placemarks = await geocoding.placemarkFromCoordinates(
        first.latitude,
        first.longitude,
      );

      final district = placemarks.isNotEmpty
          ? _extractDistrictName(placemarks.first)
          : trimmed;

      return LocationLookupResult.success(
        NeighborhoodSelection(
          displayName: district,
          latitude: first.latitude,
          longitude: first.longitude,
        ),
      );
    } catch (_) {
      return const LocationLookupResult.failure(
        LocationFailure(
          LocationFailureType.geocodingFailed,
          '입력한 동네를 찾지 못했어요.',
        ),
      );
    }
  }

  String _extractDistrictName(geocoding.Placemark placemark) {
    final candidates = <String?>[
      placemark.subLocality,
      placemark.locality,
      placemark.subAdministrativeArea,
      placemark.administrativeArea,
      placemark.street,
    ];

    for (final candidate in candidates) {
      final value = candidate?.trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }

    return '현재 위치';
  }
}
