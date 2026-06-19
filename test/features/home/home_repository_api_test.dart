import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/home/data/home_repository.dart';
import 'package:mateya_app/features/home/domain/home_models.dart';
import 'package:mateya_app/shared/auth/auth_session.dart';
import 'package:mateya_app/shared/network/http_transport.dart';
import 'package:mateya_app/shared/network/mateya_api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('explore api forwards radius filter with session coordinates', () async {
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
          activityRegionName: '우만동',
          activityLatitude: 37.2907,
          activityLongitude: 127.0416,
          createdAt: DateTime(2026, 6, 14),
        ),
      ),
    );

    final transport = _FakeExploreHttpTransport();
    final repository = ApiHomeRepository(
      apiClient: MateyaApiClient(
        baseUrl: 'https://api.mateya.cloud',
        sessionStore: sessionStore,
        transport: transport,
      ),
      sessionStore: sessionStore,
    );

    final page = await repository.fetchExploreActivities(
      page: 0,
      keyword: '산책',
      filter: const ExploreFilter(distance: DistanceRangeOption.within5km),
    );

    expect(transport.lastUri?.path, '/api/v1/activities');
    expect(transport.lastUri?.queryParametersAll['keyword'], <String>['산책']);
    expect(transport.lastUri?.queryParametersAll['radiusKm'], <String>['5']);
    expect(transport.lastUri?.queryParametersAll['latitude'], <String>[
      '37.2907',
    ]);
    expect(transport.lastUri?.queryParametersAll['longitude'], <String>[
      '127.0416',
    ]);
    expect(page.items.single.distanceKm, 5);
  });
}

class _FakeExploreHttpTransport implements HttpTransport {
  Uri? lastUri;

  @override
  Future<HttpTransportResponse> send({
    required String method,
    required Uri uri,
    Map<String, String> headers = const <String, String>{},
    String? body,
    List<int>? bodyBytes,
  }) async {
    lastUri = uri;
    return HttpTransportResponse(
      statusCode: 200,
      body: jsonEncode(<String, Object?>{
        'success': true,
        'data': <String, Object?>{
          'items': <Map<String, Object?>>[
            <String, Object?>{
              'id': 11,
              'category': 'TOURIST_ATTRACTION',
              'title': '우만동 산책',
              'placeName': '광교호수공원',
              'startAt': '2026-06-19T10:00:00.000Z',
              'endAt': '2026-06-19T12:00:00.000Z',
              'participantCount': 5,
              'capacity': 10,
              'reviewRating': 4.7,
              'language': 'ko',
              'priceType': 'FREE',
              'priceAmount': 0,
              'distanceKm': 4.6,
            },
          ],
          'page': 0,
          'size': 20,
          'hasNext': false,
          'nextPage': null,
        },
      }),
    );
  }
}
