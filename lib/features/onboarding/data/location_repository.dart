import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

import '../../../shared/localization/mateya_localizations.dart';
import '../../../shared/logging/app_logger.dart';
import '../domain/onboarding_flow.dart';
import 'location_web_geocoding.dart'
    if (dart.library.html) 'location_web_geocoding_web.dart'
    as web_geocoding;

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
    final l10n = MateyaLocalizations.current;
    _logger.info('Resolving current neighborhood from device location');
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        _logger.warning(
          'Current neighborhood lookup aborted because location service is disabled',
        );
        return LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.serviceDisabled,
            l10n.onboardingLocationErrorServiceDisabled,
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
        return LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.permissionDenied,
            l10n.onboardingLocationErrorPermissionDenied,
          ),
        );
      }

      if (permission == LocationPermission.deniedForever) {
        _logger.warning(
          'Current neighborhood lookup blocked by permanently denied permission',
        );
        return LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.permissionPermanentlyDenied,
            l10n.onboardingLocationErrorPermissionPermanentlyDenied,
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
        return LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.accuracyTooLow,
            l10n.onboardingLocationErrorAccuracyLow,
          ),
        );
      }

      if (kIsWeb) {
        final lookup = await web_geocoding.reverseGeocodeNeighborhoodOnWeb(
          latitude: position.latitude,
          longitude: position.longitude,
          logger: _logger,
        );
        if (lookup == null) {
          _logger.warning(
            'Current neighborhood lookup failed because web reverse geocoding returned no district',
            context: <String, Object?>{
              'accuracyMeters': position.accuracy.round(),
            },
          );
          return LocationLookupResult.failure(
            LocationFailure(
              LocationFailureType.geocodingFailed,
              l10n.onboardingLocationErrorAddressNotFound,
            ),
          );
        }

        _logger.info(
          'Resolved current neighborhood from device location on web',
          context: <String, Object?>{
            'district': lookup.displayName,
            'accuracyMeters': position.accuracy.round(),
            ...lookup.context,
          },
        );
        return LocationLookupResult.success(
          NeighborhoodSelection(
            displayName: lookup.displayName,
            latitude: lookup.latitude,
            longitude: lookup.longitude,
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
        return LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.geocodingFailed,
            l10n.onboardingLocationErrorAddressNotFound,
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
      return LocationLookupResult.failure(
        LocationFailure(
          LocationFailureType.unknown,
          l10n.onboardingLocationErrorUnknown,
        ),
      );
    }
  }

  @override
  Future<LocationLookupResult> resolveNeighborhoodQuery(String query) async {
    final l10n = MateyaLocalizations.current;
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _logger.warning(
        'Manual neighborhood lookup skipped because query is empty',
      );
      return LocationLookupResult.failure(
        LocationFailure(
          LocationFailureType.locationUnavailable,
          l10n.onboardingLocationQueryRequired,
        ),
      );
    }

    _logger.info(
      'Resolving neighborhood from manual query',
      context: <String, Object?>{'query': trimmed},
    );
    try {
      if (kIsWeb) {
        final lookup = await web_geocoding.geocodeNeighborhoodQueryOnWeb(
          query: trimmed,
          logger: _logger,
        );
        if (lookup == null) {
          _logger.warning(
            'Manual neighborhood lookup returned no coordinates on web',
            context: <String, Object?>{'query': trimmed},
          );
          return LocationLookupResult.failure(
            LocationFailure(
              LocationFailureType.locationUnavailable,
              l10n.onboardingLocationQueryNotFound,
            ),
          );
        }

        _logger.info(
          'Resolved neighborhood from manual query on web',
          context: <String, Object?>{
            'query': trimmed,
            'district': lookup.displayName,
            ...lookup.context,
          },
        );
        return LocationLookupResult.success(
          NeighborhoodSelection(
            displayName: lookup.displayName,
            latitude: lookup.latitude,
            longitude: lookup.longitude,
          ),
        );
      }

      final locations = await geocoding.locationFromAddress('$trimmed, 대한민국');
      if (locations.isEmpty) {
        _logger.warning(
          'Manual neighborhood lookup returned no coordinates',
          context: <String, Object?>{'query': trimmed},
        );
        return LocationLookupResult.failure(
          LocationFailure(
            LocationFailureType.locationUnavailable,
            l10n.onboardingLocationQueryNotFound,
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
      return LocationLookupResult.failure(
        LocationFailure(
          LocationFailureType.geocodingFailed,
          l10n.onboardingLocationQueryNotFound,
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

    return MateyaLocalizations.current.onboardingLocationCurrentFallback;
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
