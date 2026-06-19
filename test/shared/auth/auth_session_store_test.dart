import 'dart:convert';

import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/shared/auth/auth_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AuthSessionStore persists and restores session', () async {
    final secureStorageData = <String, String>{};
    FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform(
      secureStorageData,
    );
    final store = AuthSessionStore();
    store.clear();
    await store.flush();

    final session = AuthSession(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      tokenType: 'Bearer',
      expiresIn: 1800,
      refreshExpiresIn: 1209600,
      refreshExpiresAt: DateTime(2026, 7, 1),
      user: AuthUserProfile(
        id: 1,
        phoneNumber: '01012345678',
        displayName: '메이트야',
        role: 'USER',
        primaryLanguage: 'ko',
        primaryCountry: 'KR',
        createdAt: DateTime(2026, 6, 14),
      ),
    );

    store.save(session);
    await store.flush();

    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString('mateya.auth_session');
    expect(raw, isNull);
    expect(secureStorageData['mateya.auth_session'], isNotNull);

    final restoredStore = AuthSessionStore();
    await restoredStore.initialize();

    expect(restoredStore.session?.accessToken, 'access-token');
    expect(restoredStore.session?.refreshToken, 'refresh-token');
    expect(restoredStore.session?.user.displayName, '메이트야');
  });

  test('AuthSessionStore migrates legacy shared preferences payload', () async {
    final secureStorageData = <String, String>{};
    FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform(
      secureStorageData,
    );
    final legacyPayload = AuthSession(
      accessToken: 'legacy-access',
      refreshToken: 'legacy-refresh',
      tokenType: 'Bearer',
      expiresIn: 1800,
      refreshExpiresIn: 1209600,
      refreshExpiresAt: DateTime(2026, 7, 1),
      user: AuthUserProfile(
        id: 7,
        phoneNumber: '01000000000',
        displayName: '레거시 사용자',
        role: 'USER',
        primaryLanguage: 'ko',
        primaryCountry: 'KR',
        createdAt: DateTime(2026, 6, 14),
      ),
    );

    SharedPreferences.setMockInitialValues(<String, Object>{
      'mateya.auth_session': jsonEncode(legacyPayload.toJson()),
    });

    final store = AuthSessionStore();
    await store.initialize();

    final preferences = await SharedPreferences.getInstance();
    expect(store.session?.accessToken, 'legacy-access');
    expect(secureStorageData['mateya.auth_session'], isNotNull);
    expect(preferences.getString('mateya.auth_session'), isNull);
  });
}
