import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/create/data/create_repository.dart';
import 'package:mateya_app/features/create/domain/create_models.dart';
import 'package:mateya_app/features/onboarding/data/location_repository.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';
import 'package:mateya_app/shared/auth/auth_session.dart';
import 'package:mateya_app/shared/network/http_transport.dart';
import 'package:mateya_app/shared/network/mateya_api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('submit sends activity instants as UTC ISO-8601 strings', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final sessionStore = AuthSessionStore.instance;
    sessionStore.clear();
    await sessionStore.flush();
    sessionStore.save(
      AuthSession(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
        tokenType: 'Bearer',
        expiresIn: 1800,
        refreshExpiresIn: 1209600,
        refreshExpiresAt: DateTime(2026, 7, 1),
        user: AuthUserProfile(
          id: 1,
          phoneNumber: '01012345678',
          displayName: '사용자',
          role: 'USER',
          primaryLanguage: 'ko',
          primaryCountry: 'KR',
          createdAt: DateTime(2026, 6, 14),
        ),
      ),
    );

    final transport = _FakeCreateHttpTransport();
    final repository = ApiCreateRepository(
      apiClient: MateyaApiClient(
        baseUrl: 'https://api.mateya.cloud',
        sessionStore: sessionStore,
        transport: transport,
      ),
      sessionStore: sessionStore,
      transport: transport,
    );

    await repository.submit(
      CreateSubmissionDraft(
        flowType: CreateFlowType.group,
        categoryIds: const <String>{'CULTURE_TRADITION'},
        place: const CreatePlaceSuggestion(
          id: '2001',
          name: '북촌문화센터',
          address: '서울 종로구 계동길 37',
          description: '한옥 체험',
          distanceKm: 2,
          latitude: 37.582604,
          longitude: 126.983998,
          categoryIds: <String>{'CULTURE_TRADITION'},
          serverCategoryCode: 'CULTURE_TRADITION',
        ),
        title: '전통 다도 체험',
        description: '차를 함께 배워요.',
        eventDate: DateTime(2026, 6, 20),
        startTime: const TimeOfDay(hour: 14, minute: 30),
        endTime: const TimeOfDay(hour: 16, minute: 0),
        registrationDeadlineDate: DateTime(2026, 6, 19),
        registrationDeadlineTime: const TimeOfDay(hour: 18, minute: 15),
        participantCapacity: 8,
        languageCodes: const <String>{'ko', 'en'},
        audienceIds: const <String>{'everyone', 'foreigner'},
        images: const <CreateImageAsset>[
          CreateImageAsset(
            id: 'remote-1',
            path: 'https://cdn.mateya.cloud/uploads/activity/example.webp',
            name: 'example.webp',
            sizeBytes: 0,
            isPrimary: true,
          ),
        ],
        priceType: CreatePriceType.free,
        price: 0,
      ),
    );

    expect(transport.lastMethod, 'POST');
    expect(transport.lastUri?.path, '/api/v1/activities');
    expect(transport.lastRequestBody?['startAt'], '2026-06-20T05:30:00.000Z');
    expect(transport.lastRequestBody?['endAt'], '2026-06-20T07:00:00.000Z');
    expect(
      transport.lastRequestBody?['recruitmentDeadlineAt'],
      '2026-06-19T09:15:00.000Z',
    );
  });

  test(
    'recommended places fall back to device location when session coordinates are missing',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final sessionStore = AuthSessionStore.instance;
      sessionStore.clear();
      await sessionStore.flush();
      sessionStore.save(
        AuthSession(
          accessToken: 'access-token',
          refreshToken: 'refresh-token',
          tokenType: 'Bearer',
          expiresIn: 1800,
          refreshExpiresIn: 1209600,
          refreshExpiresAt: DateTime(2026, 7, 1),
          user: AuthUserProfile(
            id: 1,
            phoneNumber: '01012345678',
            displayName: '사용자',
            role: 'USER',
            primaryLanguage: 'ko',
            primaryCountry: 'KR',
            createdAt: DateTime(2026, 6, 14),
          ),
        ),
      );

      final transport = _FakeCreateHttpTransport();
      final repository = ApiCreateRepository(
        apiClient: MateyaApiClient(
          baseUrl: 'https://api.mateya.cloud',
          sessionStore: sessionStore,
          transport: transport,
        ),
        sessionStore: sessionStore,
        transport: transport,
        locationRepository: _FakeCreateLocationRepository.success(),
      );

      final places = await repository.fetchRecommendedPlaces(
        flowType: CreateFlowType.group,
        categoryIds: const <String>{'CULTURE_TRADITION'},
      );

      expect(transport.lastMethod, 'GET');
      expect(transport.lastUri?.path, '/api/v1/places/recommendations');
      expect(transport.lastUri?.queryParameters['latitude'], '37.5826');
      expect(transport.lastUri?.queryParameters['longitude'], '126.9839');
      expect(places.single.name, '북촌문화센터');
    },
  );
}

class _FakeCreateHttpTransport implements HttpTransport {
  String? lastMethod;
  Uri? lastUri;
  Map<String, dynamic>? lastRequestBody;

  @override
  Future<HttpTransportResponse> send({
    required String method,
    required Uri uri,
    Map<String, String> headers = const <String, String>{},
    String? body,
    List<int>? bodyBytes,
  }) async {
    lastMethod = method;
    lastUri = uri;
    lastRequestBody = body == null
        ? null
        : jsonDecode(body) as Map<String, dynamic>;

    if (uri.path == '/api/v1/places/recommendations') {
      return HttpTransportResponse(
        statusCode: 200,
        body: jsonEncode(<String, Object?>{
          'success': true,
          'data': <Map<String, Object?>>[
            <String, Object?>{
              'id': 401,
              'name': '북촌문화센터',
              'address': '서울 종로구 계동길 37',
              'description': '추천 장소',
              'distanceKm': 1.1,
              'latitude': 37.582604,
              'longitude': 126.983998,
              'category': 'CULTURE_TRADITION',
            },
          ],
        }),
      );
    }

    return HttpTransportResponse(
      statusCode: 201,
      body: jsonEncode(<String, Object?>{
        'success': true,
        'data': <String, Object?>{
          'id': 101,
          'title': '전통 다도 체험',
          'placeName': '북촌문화센터',
          'startAt': '2026-06-20T05:30:00.000Z',
        },
      }),
    );
  }
}

class _FakeCreateLocationRepository implements NeighborhoodLocationRepository {
  _FakeCreateLocationRepository.success()
    : _result = const LocationLookupResult.success(
        NeighborhoodSelection(
          displayName: '종로구',
          latitude: 37.5826,
          longitude: 126.9839,
        ),
      );

  final LocationLookupResult _result;

  @override
  Future<LocationLookupResult> resolveCurrentNeighborhood() async => _result;

  @override
  Future<LocationLookupResult> resolveNeighborhoodQuery(String query) async {
    return _result;
  }
}
