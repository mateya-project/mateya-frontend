import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/shared/auth/auth_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AuthSessionStore persists and restores session', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final store = AuthSessionStore.instance;
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
    expect(raw, isNotNull);
    store.clear();
    await store.flush();
    SharedPreferences.setMockInitialValues(<String, Object>{
      'mateya.auth_session': raw!,
    });
    await store.initialize();

    expect(store.session?.accessToken, 'access-token');
    expect(store.session?.refreshToken, 'refresh-token');
    expect(store.session?.user.displayName, '메이트야');
  });
}
