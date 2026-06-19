import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/home/data/nearby_culture_map_repository.dart';
import 'package:mateya_app/shared/auth/auth_session.dart';
import 'package:mateya_app/shared/network/http_transport.dart';
import 'package:mateya_app/shared/network/mateya_api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('map api forwards nearby culture query parameters', () async {
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

    final transport = _FakeNearbyCultureMapHttpTransport();
    final repository = ApiNearbyCultureMapRepository(
      apiClient: MateyaApiClient(
        baseUrl: 'https://api.mateya.cloud',
        sessionStore: sessionStore,
        transport: transport,
      ),
    );

    final places = await repository.fetchPlaces(
      latitude: 37.5798,
      longitude: 126.9785,
      categoryCode: 'CULTURE_TRADITION',
      categoryDetailCode: 'HERITAGE',
      keyword: '궁',
      radiusKm: 12,
      limit: 15,
    );

    expect(transport.lastUri?.path, '/api/v1/places/map');
    expect(transport.lastUri?.queryParametersAll['category'], <String>[
      'CULTURE_TRADITION',
    ]);
    expect(
      transport.lastUri?.queryParametersAll['categoryDetailCode'],
      <String>['HERITAGE'],
    );
    expect(transport.lastUri?.queryParametersAll['keyword'], <String>['궁']);
    expect(transport.lastUri?.queryParametersAll['radiusKm'], <String>['12']);
    expect(transport.lastUri?.queryParametersAll['limit'], <String>['15']);
    expect(places.single.name, '경복궁');
    expect(places.single.distanceKm, 1.4);
  });
}

class _FakeNearbyCultureMapHttpTransport implements HttpTransport {
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
        'data': <Map<String, Object?>>[
          <String, Object?>{
            'id': 11,
            'category': 'CULTURE_TRADITION',
            'categoryDetailCode': 'HERITAGE',
            'categoryDetailName': '국가유산',
            'name': '경복궁',
            'address': '서울 종로구 사직로 161',
            'regionSido': '서울특별시',
            'regionSigungu': '종로구',
            'distanceKm': 1.4,
            'latitude': 37.579617,
            'longitude': 126.977041,
          },
        ],
      }),
    );
  }
}
