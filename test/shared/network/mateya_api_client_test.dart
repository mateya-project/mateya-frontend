import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/shared/auth/auth_session.dart';
import 'package:mateya_app/shared/network/http_transport.dart';
import 'package:mateya_app/shared/network/mateya_api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('MateyaApiClient refreshes token after 401 and retries once', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final store = AuthSessionStore.instance;
    store.clear();
    await store.flush();
    store.save(
      AuthSession(
        accessToken: 'expired-access',
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
    await store.flush();

    final transport = _FakeHttpTransport();
    final client = MateyaApiClient(
      baseUrl: 'https://api.mateya.cloud',
      sessionStore: store,
      transport: transport,
    );

    final data = await client.getJson('/api/v1/users/me', requiresAuth: true);

    expect((data as Map<String, dynamic>)['id'], 1);
    expect(store.session?.accessToken, 'renewed-access');
    expect(transport.meRequestCount, 2);
    expect(transport.refreshRequestCount, 1);
  });
}

class _FakeHttpTransport implements HttpTransport {
  int meRequestCount = 0;
  int refreshRequestCount = 0;

  @override
  Future<HttpTransportResponse> send({
    required String method,
    required Uri uri,
    Map<String, String> headers = const <String, String>{},
    String? body,
    List<int>? bodyBytes,
  }) async {
    if (uri.path == '/api/v1/auth/refresh') {
      refreshRequestCount += 1;
      return HttpTransportResponse(
        statusCode: 200,
        body: jsonEncode(<String, Object?>{
          'success': true,
          'data': <String, Object?>{
            'accessToken': 'renewed-access',
            'refreshToken': 'renewed-refresh',
            'tokenType': 'Bearer',
            'expiresIn': 1800,
            'refreshExpiresIn': 1209600,
            'refreshExpiresAt': '2026-07-01T00:00:00.000Z',
            'user': <String, Object?>{
              'id': 1,
              'phoneNumber': '01012345678',
              'displayName': '사용자',
              'role': 'USER',
              'primaryLanguage': 'ko',
              'primaryCountry': 'KR',
              'createdAt': '2026-06-14T00:00:00.000Z',
            },
          },
        }),
      );
    }

    if (uri.path == '/api/v1/users/me') {
      meRequestCount += 1;
      final authorization = headers['Authorization'];
      if (authorization == 'Bearer renewed-access') {
        return HttpTransportResponse(
          statusCode: 200,
          body: jsonEncode(<String, Object?>{
            'success': true,
            'data': <String, Object?>{'id': 1},
          }),
        );
      }
      return HttpTransportResponse(
        statusCode: 401,
        body: jsonEncode(<String, Object?>{
          'success': false,
          'error': <String, Object?>{
            'code': 'authentication-required',
            'message': '만료된 토큰입니다.',
          },
        }),
      );
    }

    throw UnsupportedError('Unexpected request: ${uri.path}');
  }
}
