import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/shared/auth/auth_session.dart';
import 'package:mateya_app/shared/localization/app_language_sync_service.dart';
import 'package:mateya_app/shared/network/http_transport.dart';
import 'package:mateya_app/shared/network/mateya_api_client.dart';
import 'package:mateya_app/shared/preferences/mateya_language_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('language sync updates session and profile API together', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await MateyaLanguagePreferences.instance.setCurrentCode('en');
    final store = AuthSessionStore();
    store.clear();
    await store.flush();
    store.save(
      AuthSession(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
        tokenType: 'Bearer',
        expiresIn: 1800,
        refreshExpiresIn: 1209600,
        refreshExpiresAt: DateTime(2026, 7, 1),
        user: AuthUserProfile(
          id: 7,
          phoneNumber: '01012345678',
          displayName: '메이트야',
          englishName: 'Mateya',
          role: 'USER',
          primaryLanguage: 'ko',
          primaryCountry: 'KR',
          createdAt: DateTime(2026, 6, 14),
        ),
      ),
    );
    await store.flush();

    final transport = _ProfileSyncHttpTransport();
    final service = NetworkAppLanguageSyncService(
      sessionStore: store,
      apiClient: MateyaApiClient(
        baseUrl: 'https://api.mateya.cloud',
        sessionStore: store,
        transport: transport,
      ),
    );

    await service.syncSelectedLanguage('en');
    await store.flush();

    expect(transport.lastRequestPath, '/api/v1/users/me/profile');
    expect(transport.lastAcceptLanguage, 'en');
    expect(transport.lastBody?['primaryLanguage'], 'en');
    expect(transport.lastBody?['primaryCountry'], 'US');
    expect(store.session?.user.primaryLanguage, 'en');
    expect(store.session?.user.primaryCountry, 'US');
  });
}

class _ProfileSyncHttpTransport implements HttpTransport {
  String? lastRequestPath;
  String? lastAcceptLanguage;
  Map<String, dynamic>? lastBody;

  @override
  Future<HttpTransportResponse> send({
    required String method,
    required Uri uri,
    Map<String, String> headers = const <String, String>{},
    String? body,
    List<int>? bodyBytes,
  }) async {
    lastRequestPath = uri.path;
    lastAcceptLanguage = headers['Accept-Language'];
    lastBody = body == null ? null : jsonDecode(body) as Map<String, dynamic>;

    return HttpTransportResponse(
      statusCode: 200,
      body: jsonEncode(<String, Object?>{
        'success': true,
        'data': <String, Object?>{
          'id': 7,
          'phoneNumber': '01012345678',
          'displayName': '메이트야',
          'englishName': 'Mateya',
          'role': 'USER',
          'primaryLanguage': 'en',
          'primaryCountry': 'US',
          'createdAt': '2026-06-14T00:00:00.000Z',
        },
      }),
    );
  }
}
