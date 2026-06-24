// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:js' as js;

import '../../../shared/logging/app_logger.dart';
import '../../../shared/maps/naver_map_web_sdk.dart';
import 'location_web_geocoding.dart';

Future<WebNeighborhoodLookupResult?> reverseGeocodeNeighborhoodOnWeb({
  required double latitude,
  required double longitude,
  required AppLogger logger,
}) async {
  await NaverMapWebSdk.load();
  logger.debug(
    'Resolving neighborhood with Naver reverse geocoding on web',
    context: <String, Object?>{'latitude': latitude, 'longitude': longitude},
  );

  final maps = _mapsNamespace();
  final latLngClass = maps['LatLng'] as Object;
  final coords = js.JsObject(latLngClass as dynamic, <Object?>[
    latitude,
    longitude,
  ]);

  final response = await _invokeServiceMethod(
    methodName: 'reverseGeocode',
    options: js.JsObject.jsify(<String, Object?>{'coords': coords}),
  );

  final result = _property(response, 'v2');
  final district = _extractDistrictFromReverseResult(result);
  if (district == null) {
    return null;
  }

  final address = _property(result, 'address');
  final context = <String, Object?>{
    'latitude': latitude,
    'longitude': longitude,
  };
  final roadAddress = _stringValue(_property(address, 'roadAddress'));
  if (roadAddress != null) {
    context['roadAddress'] = roadAddress;
  }
  final jibunAddress = _stringValue(_property(address, 'jibunAddress'));
  if (jibunAddress != null) {
    context['jibunAddress'] = jibunAddress;
  }
  return WebNeighborhoodLookupResult(
    displayName: district,
    latitude: latitude,
    longitude: longitude,
    context: context,
  );
}

Future<WebNeighborhoodLookupResult?> geocodeNeighborhoodQueryOnWeb({
  required String query,
  required AppLogger logger,
}) async {
  await NaverMapWebSdk.load();

  final normalizedQuery = query.contains('대한민국') ? query : '$query 대한민국';
  logger.debug(
    'Resolving neighborhood with Naver geocoding on web',
    context: <String, Object?>{'query': normalizedQuery},
  );

  final response = await _invokeServiceMethod(
    methodName: 'geocode',
    options: js.JsObject.jsify(<String, Object?>{'query': normalizedQuery}),
  );

  final addresses = _items(_property(_property(response, 'v2'), 'addresses'));
  if (addresses.isEmpty) {
    return null;
  }

  final first = addresses.first;
  final latitude = double.tryParse(_stringValue(_property(first, 'y')) ?? '');
  final longitude = double.tryParse(_stringValue(_property(first, 'x')) ?? '');
  if (latitude == null || longitude == null) {
    return null;
  }

  final reversed = await reverseGeocodeNeighborhoodOnWeb(
    latitude: latitude,
    longitude: longitude,
    logger: logger,
  );
  if (reversed != null) {
    return reversed;
  }

  final context = <String, Object?>{
    'query': normalizedQuery,
    'latitude': latitude,
    'longitude': longitude,
  };
  final roadAddress = _stringValue(_property(first, 'roadAddress'));
  if (roadAddress != null) {
    context['roadAddress'] = roadAddress;
  }
  final jibunAddress = _stringValue(_property(first, 'jibunAddress'));
  if (jibunAddress != null) {
    context['jibunAddress'] = jibunAddress;
  }
  return WebNeighborhoodLookupResult(
    displayName: query,
    latitude: latitude,
    longitude: longitude,
    context: context,
  );
}

Future<dynamic> _invokeServiceMethod({
  required String methodName,
  required Object options,
}) {
  final service = _serviceNamespace();
  final completer = Completer<dynamic>();

  service.callMethod(methodName, <Object?>[
    options,
    (dynamic status, dynamic response) {
      if (_isOkStatus(service, status)) {
        if (!completer.isCompleted) {
          completer.complete(response);
        }
        return;
      }
      if (!completer.isCompleted) {
        completer.completeError(
          StateError('Naver geocoding failed with status: $status'),
        );
      }
    },
  ]);

  return completer.future;
}

js.JsObject _mapsNamespace() {
  final naver = js.context['naver'] as js.JsObject;
  return naver['maps'] as js.JsObject;
}

js.JsObject _serviceNamespace() {
  return _mapsNamespace()['Service'] as js.JsObject;
}

bool _isOkStatus(js.JsObject service, dynamic status) {
  final statusNamespace = service['Status'];
  if (statusNamespace is js.JsObject && statusNamespace.hasProperty('OK')) {
    return identical(status, statusNamespace['OK']) ||
        status == statusNamespace['OK'];
  }
  return '$status'.toUpperCase() == 'OK';
}

String? _extractDistrictFromReverseResult(dynamic result) {
  final candidates = <String?>[];

  for (final item in _items(_property(result, 'results'))) {
    final region = _property(item, 'region');
    candidates.addAll(<String?>[
      _stringValue(_property(_property(region, 'area3'), 'name')),
      _stringValue(_property(_property(region, 'area4'), 'name')),
      _stringValue(_property(_property(region, 'area2'), 'name')),
      _stringValue(_property(_property(region, 'area1'), 'name')),
    ]);
  }

  for (final candidate in candidates) {
    final value = candidate?.trim();
    if (value != null && value.isNotEmpty) {
      return value;
    }
  }

  return null;
}

List<dynamic> _items(dynamic value) {
  if (value is List) {
    return List<dynamic>.from(value);
  }
  if (value is js.JsArray) {
    return List<dynamic>.generate(value.length, (index) => value[index]);
  }
  return const <dynamic>[];
}

dynamic _property(dynamic value, String key) {
  if (value is js.JsObject) {
    return value[key];
  }
  if (value is Map) {
    return value[key];
  }
  return null;
}

String? _stringValue(dynamic value) {
  if (value is String) {
    return value;
  }
  return value?.toString();
}
