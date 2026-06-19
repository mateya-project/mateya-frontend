import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

import '../../../shared/logging/app_logger.dart';
import '../domain/onboarding_flow.dart';

abstract interface class NeighborhoodLocationRepository {
  Future<LocationLookupResult> resolveCurrentNeighborhood();
  Future<LocationLookupResult> resolveNeighborhoodQuery(String query);
}

class DeviceNeighborhoodLocationRepository
    implements NeighborhoodLocationRepository {
  DeviceNeighborhoodLocationRepository({AppLogger? logger})
    : _loggerOverride = logger;

  final AppLogger? _loggerOverride;
  AppLogger get _logger => _loggerOverride ?? AppLogger.instance;

  @override
  Future<LocationLookupResult> resolveCurrentNeighborhood() async {
    _logger.info('Resolving current neighborhood from device location');
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        _logger.warning(
          'Current neighborhood lookup aborted because location service is disabled',
        );
        return const LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.serviceDisabled,
            '위치 서비스가 꺼져 있어요. 직접 입력으로 진행해 주세요.',
          ),
        );
      }

      var permission = await Geolocator.checkPermission();
      _logger.debug(
        'Checked location permission for neighborhood lookup',
        context: <String, Object?>{'permission': _permissionLabel(permission)},
      );
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        _logger.info(
          'Requested location permission for neighborhood lookup',
          context: <String, Object?>{
            'permission': _permissionLabel(permission),
          },
        );
      }

      if (permission == LocationPermission.denied) {
        _logger.warning(
          'Current neighborhood lookup denied by user permission',
        );
        return const LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.permissionDenied,
            '위치 권한이 없으면 현재 위치 자동 인증을 사용할 수 없어요. 직접 입력은 계속 진행할 수 있고, 권한을 허용하면 다시 시도할 수 있어요.',
          ),
        );
      }

      if (permission == LocationPermission.deniedForever) {
        _logger.warning(
          'Current neighborhood lookup blocked by permanently denied permission',
        );
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
        _logger.warning(
          'Current neighborhood lookup failed because accuracy is too low',
          context: <String, Object?>{
            'accuracyMeters': position.accuracy.round(),
          },
        );
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
        _logger.warning(
          'Current neighborhood lookup failed because reverse geocoding returned no placemarks',
          context: <String, Object?>{
            'accuracyMeters': position.accuracy.round(),
          },
        );
        return const LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.geocodingFailed,
            '주소를 찾지 못했어요. 직접 입력으로 진행해 주세요.',
          ),
        );
      }

      final district = _extractDistrictName(placemarks.first);
      _logger.info(
        'Resolved current neighborhood from device location',
        context: <String, Object?>{
          'district': district,
          'accuracyMeters': position.accuracy.round(),
          ..._placemarkContext(placemarks.first),
        },
      );
      return LocationLookupResult.success(
        NeighborhoodSelection(
          displayName: district,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } catch (error, stackTrace) {
      _logger.error(
        'Current neighborhood lookup failed unexpectedly',
        error: error,
        stackTrace: stackTrace,
      );
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
      _logger.warning(
        'Manual neighborhood lookup skipped because query is empty',
      );
      return const LocationLookupResult.failure(
        LocationFailure(
          LocationFailureType.locationUnavailable,
          '동네명을 입력해 주세요.',
        ),
      );
    }

    _logger.info(
      'Resolving neighborhood from manual query',
      context: <String, Object?>{'query': trimmed},
    );
    try {
      final locations = await geocoding.locationFromAddress('$trimmed, 대한민국');
      if (locations.isEmpty) {
        _logger.warning(
          'Manual neighborhood lookup returned no coordinates',
          context: <String, Object?>{'query': trimmed},
        );
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
      _logger.info(
        'Resolved neighborhood from manual query',
        context: <String, Object?>{
          'query': trimmed,
          'district': district,
          if (placemarks.isNotEmpty) ..._placemarkContext(placemarks.first),
        },
      );

      return LocationLookupResult.success(
        NeighborhoodSelection(
          displayName: district,
          latitude: first.latitude,
          longitude: first.longitude,
        ),
      );
    } catch (error, stackTrace) {
      _logger.error(
        'Manual neighborhood lookup failed unexpectedly',
        error: error,
        stackTrace: stackTrace,
        context: <String, Object?>{'query': trimmed},
      );
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

  String _permissionLabel(LocationPermission permission) {
    return switch (permission) {
      LocationPermission.always => 'always',
      LocationPermission.whileInUse => 'whileInUse',
      LocationPermission.denied => 'denied',
      LocationPermission.deniedForever => 'deniedForever',
      LocationPermission.unableToDetermine => 'unableToDetermine',
    };
  }

  Map<String, Object?> _placemarkContext(geocoding.Placemark placemark) {
    return <String, Object?>{
      if (placemark.subLocality?.trim().isNotEmpty ?? false)
        'subLocality': placemark.subLocality!.trim(),
      if (placemark.locality?.trim().isNotEmpty ?? false)
        'locality': placemark.locality!.trim(),
      if (placemark.subAdministrativeArea?.trim().isNotEmpty ?? false)
        'subAdministrativeArea': placemark.subAdministrativeArea!.trim(),
      if (placemark.administrativeArea?.trim().isNotEmpty ?? false)
        'administrativeArea': placemark.administrativeArea!.trim(),
    };
  }
}
