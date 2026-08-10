import 'dart:convert';

import 'package:image_picker/image_picker.dart';

import '../../../app/app_config.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/network/http_transport.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../../../shared/preferences/mateya_language_preferences.dart';
import '../domain/ai_models.dart';
import 'ai_sse_transport.dart';

abstract interface class AiRepository {
  Future<List<AiConversationSummary>> fetchConversations();

  Future<AiConversation> createConversation(AiConversationSeed seed);

  Future<AiConversation> fetchConversation(String id);

  Future<AiConversation> sendMessage({
    required String conversationId,
    required String clientMessageId,
    required String message,
    List<AiMessageAttachment> attachments = const <AiMessageAttachment>[],
    void Function(String)? onProgress,
  });

  Future<String> uploadAiImage(XFile image);

  Future<void> archiveConversation(String id);

  Future<List<AiHomeHighlight>> fetchHomeHighlights();

  Future<AiPlaceDetail> fetchPlace(String id);

  Future<List<AiPlaceActivity>> fetchPlaceActivities(String placeId);

  Future<bool> togglePlaceFavorite(String placeId);

  Future<void> recordEvent({
    required String eventType,
    String? conversationId,
    String? runId,
    String? anchorPlaceId,
    String? recommendedPlaceId,
    String? activityId,
  });
}

class ApiAiRepository implements AiRepository {
  ApiAiRepository({
    MateyaApiClient? apiClient,
    AuthSessionStore? sessionStore,
    HttpTransport? uploadTransport,
    AiSseTransport? sseTransport,
  }) : _sessionStore = sessionStore ?? AuthSessionStore.instance,
       _uploadTransport = uploadTransport ?? createHttpTransport(),
       _sseTransport = sseTransport ?? createAiSseTransport(),
       _apiClient =
           apiClient ??
           MateyaApiClient(
             baseUrl: AppConfig.apiBaseUrl,
             sessionStore: sessionStore ?? AuthSessionStore.instance,
           );

  final MateyaApiClient _apiClient;
  final AuthSessionStore _sessionStore;
  final HttpTransport _uploadTransport;
  final AiSseTransport _sseTransport;

  @override
  Future<List<AiConversationSummary>> fetchConversations() async {
    final data = await _apiClient.getJson(
      '/api/v1/ai/conversations',
      requiresAuth: true,
    );
    return _asList(data).map(_parseSummary).toList(growable: false);
  }

  @override
  Future<AiConversation> createConversation(AiConversationSeed seed) async {
    final data = await _apiClient.postJson(
      '/api/v1/ai/conversations',
      requiresAuth: true,
      body: <String, Object?>{
        'entryPoint': seed.entryPoint,
        if (seed.anchorPlaceId != null)
          'anchorPlaceId': int.parse(seed.anchorPlaceId!),
        if (seed.visitDate != null) 'visitDate': _formatDate(seed.visitDate!),
        'radiusKm': seed.radiusKm,
        'interests': seed.interests,
        'dispersalPreference': 'BALANCED',
        'language': MateyaLanguagePreferences.instance.primaryLanguageCode,
      },
    );
    return _parseConversation(_asMap(data));
  }

  @override
  Future<AiConversation> fetchConversation(String id) async {
    final data = await _apiClient.getJson(
      '/api/v1/ai/conversations/$id',
      requiresAuth: true,
    );
    return _parseConversation(_asMap(data));
  }

  @override
  Future<AiConversation> sendMessage({
    required String conversationId,
    required String clientMessageId,
    required String message,
    List<AiMessageAttachment> attachments = const <AiMessageAttachment>[],
    void Function(String)? onProgress,
  }) async {
    final body = <String, Object?>{
      'clientMessageId': clientMessageId,
      'message': message,
      'attachments': attachments.map(_attachmentJson).toList(growable: false),
    };
    final accessToken = _sessionStore.session?.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      throw const MateyaApiException(
        type: ApiFailureType.unauthorized,
        message: '로그인이 필요합니다.',
      );
    }
    var accepted = false;
    try {
      await for (final event in _sseTransport.post(
        uri: _apiUri(
          '/api/v1/ai/conversations/$conversationId/messages/stream',
        ),
        headers: <String, String>{
          'Accept': 'text/event-stream',
          'Accept-Language':
              MateyaLanguagePreferences.instance.primaryLanguageCode,
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      )) {
        onProgress?.call(event.event);
        if (event.event == 'accepted') {
          accepted = true;
        } else if (event.event == 'completed') {
          final decoded = jsonDecode(event.data);
          return _parseConversation(_asMap(_asMap(decoded)['conversation']));
        } else if (event.event == 'error') {
          final decoded = _asMap(jsonDecode(event.data));
          throw StateError(
            decoded['message'] as String? ?? 'AI 추천을 불러오지 못했습니다.',
          );
        }
      }
      throw StateError('AI 스트림이 결과 없이 종료되었습니다.');
    } catch (_) {
      if (accepted) {
        rethrow;
      }
      final data = await _apiClient.postJson(
        '/api/v1/ai/conversations/$conversationId/messages',
        requiresAuth: true,
        body: body,
      );
      onProgress?.call('completed');
      return _parseConversation(_asMap(_asMap(data)['conversation']));
    }
  }

  @override
  Future<String> uploadAiImage(XFile image) async {
    final fileName = image.name.isEmpty
        ? image.path.split('/').last
        : image.name;
    final contentType = _contentTypeFor(fileName);
    if (contentType == null) {
      throw StateError('JPG, PNG, WEBP, GIF 이미지만 첨부할 수 있습니다.');
    }
    final bytes = await image.readAsBytes();
    final presigned = _asMap(
      await _apiClient.postJson(
        '/api/v1/uploads/images/presigned-url',
        requiresAuth: true,
        body: <String, Object?>{
          'purpose': 'AI',
          'originalFilename': fileName,
          'contentType': contentType,
          'sizeBytes': bytes.length,
          'requestedFileCount': 1,
        },
      ),
    );
    final uploadUrl = presigned['uploadUrl'] as String?;
    final objectKey = presigned['objectKey'] as String?;
    if (uploadUrl == null || objectKey == null) {
      throw StateError('AI 사진 업로드 정보를 받지 못했습니다.');
    }
    final uploadResponse = await _uploadTransport.send(
      method: 'PUT',
      uri: Uri.parse(uploadUrl),
      headers: _flattenHeaders(
        _asMap(presigned['headers']),
        fallbackContentType: contentType,
      ),
      bodyBytes: bytes,
    );
    if (uploadResponse.statusCode < 200 || uploadResponse.statusCode >= 300) {
      throw StateError('AI 사진을 업로드하지 못했습니다.');
    }
    final confirmed = _asMap(
      await _apiClient.postJson(
        '/api/v1/uploads/images/confirm',
        requiresAuth: true,
        body: <String, Object?>{'objectKey': objectKey},
      ),
    );
    final publicUrl = confirmed['publicUrl'] as String?;
    if (publicUrl == null || publicUrl.isEmpty) {
      throw StateError('AI 사진 업로드를 확정하지 못했습니다.');
    }
    return publicUrl;
  }

  @override
  Future<void> archiveConversation(String id) async {
    await _apiClient.deleteJson(
      '/api/v1/ai/conversations/$id',
      requiresAuth: true,
    );
  }

  @override
  Future<List<AiHomeHighlight>> fetchHomeHighlights() async {
    final data = await _apiClient.getJson(
      '/api/v1/ai/home/highlights',
      requiresAuth: true,
    );
    return _asList(data).map(_parseHomeHighlight).toList(growable: false);
  }

  @override
  Future<AiPlaceDetail> fetchPlace(String id) async {
    final data = await _apiClient.getJson(
      '/api/v1/places/$id',
      requiresAuth: true,
    );
    return _parsePlace(_asMap(data));
  }

  @override
  Future<List<AiPlaceActivity>> fetchPlaceActivities(String placeId) async {
    final data = await _apiClient.getJson(
      '/api/v1/activities',
      queryParameters: <String, String>{'placeId': placeId},
      requiresAuth: true,
    );
    final map = _asMap(data);
    return _asList(map['items']).map(_parseActivity).toList(growable: false);
  }

  @override
  Future<bool> togglePlaceFavorite(String placeId) async {
    final data = _asMap(
      await _apiClient.postJson(
        '/api/v1/places/$placeId/favorite',
        requiresAuth: true,
      ),
    );
    return data['favorite'] as bool? ?? false;
  }

  @override
  Future<void> recordEvent({
    required String eventType,
    String? conversationId,
    String? runId,
    String? anchorPlaceId,
    String? recommendedPlaceId,
    String? activityId,
  }) async {
    await _apiClient.postJson(
      '/api/v1/ai/recommendation-events',
      requiresAuth: true,
      body: <String, Object?>{
        'eventType': eventType,
        'conversationId': ?conversationId,
        'runId': ?runId,
        if (anchorPlaceId != null) 'anchorPlaceId': int.parse(anchorPlaceId),
        if (recommendedPlaceId != null)
          'recommendedPlaceId': int.parse(recommendedPlaceId),
        if (activityId != null) 'activityId': int.parse(activityId),
      },
    );
  }
}

class MockAiRepository implements AiRepository {
  AiConversation? _conversation;

  @override
  Future<List<AiConversationSummary>> fetchConversations() async =>
      _conversation == null
      ? const <AiConversationSummary>[]
      : <AiConversationSummary>[
          AiConversationSummary(
            id: _conversation!.id,
            title: _conversation!.title,
            anchorPlaceId: _conversation!.anchorPlaceId,
            anchorPlaceName: _conversation!.anchorPlaceName,
            visitDate: _conversation!.visitDate,
            radiusKm: _conversation!.radiusKm,
            interests: _conversation!.interests,
            lastMessagePreview: _conversation!.messages.lastOrNull?.text,
            updatedAt: _conversation!.updatedAt,
          ),
        ];

  @override
  Future<AiConversation> createConversation(AiConversationSeed seed) async {
    _conversation = AiConversation(
      id: 'mock-ai-conversation',
      title: '새 여행 계획',
      anchorPlaceId: seed.anchorPlaceId,
      anchorPlaceName: seed.anchorPlaceName,
      visitDate: seed.visitDate,
      radiusKm: seed.radiusKm,
      updatedAt: DateTime.now(),
      messages: const <AiMessage>[],
    );
    return _conversation!;
  }

  @override
  Future<AiConversation> fetchConversation(String id) async =>
      _conversation ?? (await createConversation(const AiConversationSeed()));

  @override
  Future<AiConversation> sendMessage({
    required String conversationId,
    required String clientMessageId,
    required String message,
    List<AiMessageAttachment> attachments = const <AiMessageAttachment>[],
    void Function(String)? onProgress,
  }) async {
    onProgress?.call('accepted');
    final current = await fetchConversation(conversationId);
    final now = DateTime.now();
    _conversation = AiConversation(
      id: current.id,
      title: message,
      anchorPlaceId: current.anchorPlaceId,
      anchorPlaceName: current.anchorPlaceName,
      visitDate: current.visitDate,
      radiusKm: current.radiusKm,
      updatedAt: now,
      messages: <AiMessage>[
        ...current.messages,
        AiMessage(
          id: clientMessageId,
          role: 'USER',
          status: 'COMPLETED',
          text: message,
          createdAt: now,
          attachments: attachments,
        ),
        AiMessage(
          id: 'assistant-${now.microsecondsSinceEpoch}',
          role: 'ASSISTANT',
          status: 'COMPLETED',
          text: current.anchorPlaceId == null
              ? '먼저 기준이 될 관광지를 골라 주세요.'
              : '비슷한 매력을 가진 로컬 장소를 찾았어요.',
          createdAt: now,
          parts: const <AiMessagePart>[
            AiQuickActionsPart(<AiQuickAction>[
              AiQuickAction(
                id: 'THIS_WEEKEND',
                label: '이번 주말',
                message: '이번 주말에 갈게',
              ),
            ]),
          ],
        ),
      ],
    );
    onProgress?.call('completed');
    return _conversation!;
  }

  @override
  Future<String> uploadAiImage(XFile image) async =>
      'https://mock.mateya/ai/${image.name}';

  @override
  Future<void> archiveConversation(String id) async {
    _conversation = null;
  }

  @override
  Future<List<AiHomeHighlight>> fetchHomeHighlights() async =>
      const <AiHomeHighlight>[
        AiHomeHighlight(
          anchorPlaceId: '1',
          anchorPlaceName: '경복궁',
          placeId: '2',
          name: '서촌 골목',
          reason: '궁궐 산책의 분위기를 이어가며 지역 방문을 분산해요.',
          regionSido: '서울특별시',
          regionSigungu: '종로구',
          distanceKm: 1.4,
        ),
      ];

  @override
  Future<AiPlaceDetail> fetchPlace(String id) async => const AiPlaceDetail(
    id: '2',
    name: '서촌 골목',
    address: '서울 종로구 자하문로',
    description: '시장과 작은 상점, 전시 공간을 함께 둘러보는 골목입니다.',
    category: 'CULTURE_TRADITION',
    categoryDetailName: '골목 여행',
    regionSido: '서울특별시',
    regionSigungu: '종로구',
    latitude: 37.58,
    longitude: 126.97,
  );

  @override
  Future<List<AiPlaceActivity>> fetchPlaceActivities(String placeId) async =>
      const <AiPlaceActivity>[];

  @override
  Future<bool> togglePlaceFavorite(String placeId) async => true;

  @override
  Future<void> recordEvent({
    required String eventType,
    String? conversationId,
    String? runId,
    String? anchorPlaceId,
    String? recommendedPlaceId,
    String? activityId,
  }) async {}
}

AiConversationSummary _parseSummary(Object? value) {
  final json = _asMap(value);
  return AiConversationSummary(
    id: '${json['id']}',
    title: json['title'] as String? ?? '새 여행 계획',
    anchorPlaceId: _stringOrNull(json['anchorPlaceId']),
    anchorPlaceName: json['anchorPlaceName'] as String?,
    visitDate: _dateOrNull(json['visitDate']),
    radiusKm: (json['radiusKm'] as num?)?.toDouble() ?? 10,
    interests: _asList(json['interests']).whereType<String>().toList(),
    dispersalPreference: json['dispersalPreference'] as String? ?? 'BALANCED',
    lastMessagePreview: json['lastMessagePreview'] as String?,
    updatedAt: _dateOrNull(json['updatedAt']) ?? DateTime.now(),
  );
}

AiConversation _parseConversation(Map<String, dynamic> json) {
  return AiConversation(
    id: '${json['id']}',
    title: json['title'] as String? ?? '새 여행 계획',
    anchorPlaceId: _stringOrNull(json['anchorPlaceId']),
    anchorPlaceName: json['anchorPlaceName'] as String?,
    visitDate: _dateOrNull(json['visitDate']),
    radiusKm: (json['radiusKm'] as num?)?.toDouble() ?? 10,
    interests: _asList(json['interests']).whereType<String>().toList(),
    dispersalPreference: json['dispersalPreference'] as String? ?? 'BALANCED',
    lastRunId: json['lastRunId'] as String?,
    updatedAt: _dateOrNull(json['updatedAt']) ?? DateTime.now(),
    messages: _asList(json['messages']).map(_parseMessage).toList(),
  );
}

AiMessage _parseMessage(Object? value) {
  final json = _asMap(value);
  return AiMessage(
    id: '${json['id']}',
    role: json['role'] as String? ?? 'ASSISTANT',
    status: json['status'] as String? ?? 'COMPLETED',
    text: json['text'] as String? ?? '',
    runId: json['runId'] as String?,
    createdAt: _dateOrNull(json['createdAt']) ?? DateTime.now(),
    parts: _asList(json['parts']).map(_parsePart).toList(),
    attachments: _asList(
      json['attachments'],
    ).map(_asMap).map(_parseAttachment).toList(),
  );
}

AiMessagePart _parsePart(Object? value) {
  final json = _asMap(value);
  return switch (json['type']) {
    'DATE_ALTERNATIVES' => AiDateAlternativesPart(
      _asList(json['items'])
          .map(_asMap)
          .map(
            (item) => AiDateAlternative(
              visitDate: _dateOrNull(item['visitDate']) ?? DateTime.now(),
              relativeConcentration:
                  (item['relativeConcentration'] as num?)?.toDouble() ?? 0,
            ),
          )
          .toList(),
    ),
    'PLACE_RECOMMENDATIONS' => AiPlaceRecommendationsPart(
      _asList(json['items']).map(_parsePlaceRecommendation).toList(),
    ),
    'ANCHOR_PLACE_CHOICES' => AiAnchorPlaceChoicesPart(
      query: json['query'] as String? ?? '',
      items: _asList(json['items'])
          .map(_asMap)
          .map(
            (item) => AiAnchorPlaceChoice(
              placeId: '${item['placeId']}',
              name: item['name'] as String? ?? '',
              address: item['address'] as String?,
              regionSido: item['regionSido'] as String?,
              regionSigungu: item['regionSigungu'] as String?,
            ),
          )
          .toList(),
    ),
    'QUICK_ACTIONS' => AiQuickActionsPart(
      _asList(json['items'])
          .map(_asMap)
          .map(
            (item) => AiQuickAction(
              id: item['id'] as String? ?? '',
              label: item['label'] as String? ?? '',
              message: item['message'] as String? ?? '',
            ),
          )
          .toList(),
    ),
    'NOTICE' => AiNoticePart(json['text'] as String? ?? ''),
    _ => AiTextPart(json['text'] as String? ?? ''),
  };
}

AiPlaceRecommendation _parsePlaceRecommendation(Object? value) {
  final json = _asMap(value);
  return AiPlaceRecommendation(
    placeId: '${json['placeId']}',
    name: json['name'] as String? ?? '',
    regionSido: json['regionSido'] as String?,
    regionSigungu: json['regionSigungu'] as String?,
    distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    score: (json['score'] as num?)?.toDouble() ?? 0,
    reason: json['reason'] as String? ?? '',
    cta: json['cta'] as String? ?? 'VIEW_PLACE',
    activityId: _stringOrNull(json['activityId']),
  );
}

AiHomeHighlight _parseHomeHighlight(Object? value) {
  final json = _asMap(value);
  return AiHomeHighlight(
    anchorPlaceId: '${json['anchorPlaceId']}',
    anchorPlaceName: json['anchorPlaceName'] as String? ?? '',
    placeId: '${json['placeId']}',
    name: json['name'] as String? ?? '',
    category: json['category'] as String?,
    regionSido: json['regionSido'] as String?,
    regionSigungu: json['regionSigungu'] as String?,
    distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    imageUrl: json['imageUrl'] as String?,
    reason: json['reason'] as String? ?? '',
  );
}

AiPlaceDetail _parsePlace(Map<String, dynamic> json) {
  return AiPlaceDetail(
    id: '${json['id']}',
    name: json['name'] as String? ?? json['originalName'] as String? ?? '',
    address: json['address'] as String? ?? '',
    description: json['description'] as String? ?? '',
    category: json['category'] as String? ?? '',
    categoryDetailName: json['categoryDetailName'] as String?,
    regionSido: json['regionSido'] as String?,
    regionSigungu: json['regionSigungu'] as String?,
    imageUrl: json['imageUrl'] as String?,
    thumbnailUrl: json['thumbnailUrl'] as String?,
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    favorited: json['favorited'] as bool? ?? false,
  );
}

AiMessageAttachment _parseAttachment(Map<String, dynamic> json) {
  return AiMessageAttachment(
    imageUrl: json['imageUrl'] as String? ?? '',
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    accuracyMeters: (json['accuracyMeters'] as num?)?.toDouble(),
    capturedAt: _dateOrNull(json['capturedAt']),
    locationShared: json['locationShared'] as bool? ?? false,
  );
}

AiPlaceActivity _parseActivity(Object? value) {
  final json = _asMap(value);
  return AiPlaceActivity(
    id: '${json['id']}',
    title: json['title'] as String? ?? '',
    placeName: json['placeName'] as String? ?? '',
    imageUrl: json['representativeImageUrl'] as String?,
    startAt: _dateOrNull(json['startAt']),
  );
}

Map<String, dynamic> _asMap(Object? value) =>
    value is Map<String, dynamic> ? value : const <String, dynamic>{};

List<Object?> _asList(Object? value) =>
    value is List<Object?> ? value : const <Object?>[];

DateTime? _dateOrNull(Object? value) =>
    value is String ? DateTime.tryParse(value)?.toLocal() : null;

String? _stringOrNull(Object? value) => value == null ? null : '$value';

String _formatDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

Map<String, Object?> _attachmentJson(AiMessageAttachment attachment) =>
    <String, Object?>{
      'type': 'IMAGE',
      'imageUrl': attachment.imageUrl,
      'latitude': attachment.latitude,
      'longitude': attachment.longitude,
      'accuracyMeters': attachment.accuracyMeters,
      'capturedAt': attachment.capturedAt?.toUtc().toIso8601String(),
      'locationShared': attachment.locationShared,
    };

Uri _apiUri(String path) => Uri.parse(
  '${AppConfig.apiBaseUrl.replaceAll(RegExp(r'/+$'), '')}${path.startsWith('/') ? path : '/$path'}',
);

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
    } else if (value is String && value.isNotEmpty) {
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
