part of 'create_repository.dart';

const Map<String, String> _serverCategoryCodeByClientCategoryId =
    <String, String>{
      'TOURIST_ATTRACTION': 'TOURIST_ATTRACTION',
      'TRAVEL_COURSE': 'TRAVEL_COURSE',
      'CULTURE_TRADITION': 'CULTURE_TRADITION',
      'EVENT_PERFORMANCE_FESTIVAL': 'EVENT_PERFORMANCE_FESTIVAL',
      'SPORTS': 'SPORTS',
      'ACTIVITY_LEPORTS': 'ACTIVITY_LEPORTS',
      'PUBLIC_FACILITY': 'PUBLIC_FACILITY',
      'SHOPPING': 'SHOPPING',
    };

const Map<String, String> _clientCategoryIdByServerCode = <String, String>{
  'TOURIST_ATTRACTION': 'TOURIST_ATTRACTION',
  'TRAVEL_COURSE': 'TRAVEL_COURSE',
  'CULTURE_TRADITION': 'CULTURE_TRADITION',
  'EVENT_PERFORMANCE_FESTIVAL': 'EVENT_PERFORMANCE_FESTIVAL',
  'SPORTS': 'SPORTS',
  'ACTIVITY_LEPORTS': 'ACTIVITY_LEPORTS',
  'PUBLIC_FACILITY': 'PUBLIC_FACILITY',
  'SHOPPING': 'SHOPPING',
};

String _audienceToServerValue(String audienceId) => switch (audienceId) {
  'everyone' => 'ANYONE',
  'foreigner' => 'FOREIGNER_WELCOME',
  'korean' => 'KOREAN_WELCOME',
  'tourist' => 'TOURIST_RECOMMENDED',
  'beginner' => 'BEGINNER_WELCOME',
  _ => 'ANYONE',
};

CreatePlaceSuggestion _parsePlaceSuggestion(Object? value) {
  final json = _asMap(value);
  final serverCategoryCode = json['category'] as String?;
  final clientCategoryId = serverCategoryCode == null
      ? null
      : _clientCategoryIdByServerCode[serverCategoryCode];

  return CreatePlaceSuggestion(
    id: '${json['id']}',
    name: (json['name'] as String?) ?? (json['originalName'] as String?) ?? '',
    address: json['address'] as String? ?? '',
    description: _composePlaceDescription(json),
    distanceKm: ((json['distanceKm'] as num?) ?? 0).round(),
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    categoryIds: clientCategoryId == null
        ? const <String>{}
        : <String>{clientCategoryId},
    serverCategoryCode: serverCategoryCode,
    categoryDetailCode: json['categoryDetailCode'] as String?,
    categoryDetailName: json['categoryDetailName'] as String?,
  );
}

String _composePlaceDescription(Map<String, dynamic> json) {
  final parts = <String>[
    if ((json['categoryDetailName'] as String?)?.isNotEmpty ?? false)
      json['categoryDetailName'] as String,
    if ((json['regionSido'] as String?)?.isNotEmpty ?? false)
      json['regionSido'] as String,
    if ((json['regionSigungu'] as String?)?.isNotEmpty ?? false)
      json['regionSigungu'] as String,
  ];
  return parts.isEmpty ? '위치를 확인한 뒤 선택해 주세요.' : parts.join(' · ');
}

String? _resolveServerCategoryCode({
  required Set<String> explicitCategoryIds,
  String? fallbackPlaceCategoryCode,
}) {
  if (fallbackPlaceCategoryCode != null &&
      fallbackPlaceCategoryCode.isNotEmpty) {
    return fallbackPlaceCategoryCode;
  }
  final selectedId = explicitCategoryIds.firstOrNull;
  if (selectedId == null) {
    return null;
  }
  return _serverCategoryCodeByClientCategoryId[selectedId];
}

Map<String, String> _flattenHeaders(
  Map<String, dynamic> rawHeaders, {
  required String fallbackContentType,
}) {
  final headers = <String, String>{};
  rawHeaders.forEach((key, value) {
    if (value is List<Object?>) {
      final joined = value.whereType<String>().join(', ');
      if (joined.isNotEmpty) {
        headers[key] = joined;
      }
      return;
    }
    if (value is String && value.isNotEmpty) {
      headers[key] = value;
    }
  });
  headers.putIfAbsent('Content-Type', () => fallbackContentType);
  return headers;
}

String? _contentTypeFor(String fileName) {
  final normalized = fileName.toLowerCase();
  if (normalized.endsWith('.jpg') || normalized.endsWith('.jpeg')) {
    return 'image/jpeg';
  }
  if (normalized.endsWith('.png')) {
    return 'image/png';
  }
  if (normalized.endsWith('.webp')) {
    return 'image/webp';
  }
  if (normalized.endsWith('.gif')) {
    return 'image/gif';
  }
  return null;
}

CreateRepositoryException _mapApiException(MateyaApiException error) {
  if (error.type == ApiFailureType.network) {
    return CreateRepositoryException(
      CreateRepositoryFailureType.network,
      message: error.message,
    );
  }
  return CreateRepositoryException(
    CreateRepositoryFailureType.server,
    message: error.message,
  );
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  throw const CreateRepositoryException(CreateRepositoryFailureType.server);
}
