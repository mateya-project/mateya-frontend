import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/shared/activity_categories/activity_category_repository.dart';
import 'package:mateya_app/shared/auth/auth_session.dart';
import 'package:mateya_app/shared/network/mateya_api_client.dart';
import 'package:mateya_app/shared/preferences/mateya_language_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(ApiActivityCategoryRepository.debugResetCache);

  group('ApiActivityCategoryRepository', () {
    test('reuses cached categories while ttl is valid', () async {
      var now = DateTime(2026, 6, 20, 9);
      final client = _FakeMateyaApiClient(<Object? Function()>[
        () => <String, Object?>{
          'items': <Object?>[
            <String, Object?>{
              'code': 'SPORTS',
              'label': '스포츠',
              'displayOrder': 1,
              'active': true,
              'children': const <Object?>[],
            },
          ],
        },
      ]);
      final repository = ApiActivityCategoryRepository(
        apiClient: client,
        now: () => now,
      );

      final first = await repository.fetchActivityCategories();
      now = now.add(const Duration(hours: 1));
      final second = await repository.fetchActivityCategories();

      expect(first.single.code, 'SPORTS');
      expect(second.single.code, 'SPORTS');
      expect(client.callCount, 1);
    });

    test('returns stale cache when ttl expired and refresh fails', () async {
      var now = DateTime(2026, 6, 20, 9);
      final client = _FakeMateyaApiClient(<Object? Function()>[
        () => <String, Object?>{
          'items': <Object?>[
            <String, Object?>{
              'code': 'CULTURE_TRADITION',
              'label': '문화/전통',
              'displayOrder': 1,
              'active': true,
              'children': const <Object?>[],
            },
          ],
        },
        () => throw MateyaApiException(
          type: ApiFailureType.network,
          message: 'offline',
        ),
      ]);
      final repository = ApiActivityCategoryRepository(
        apiClient: client,
        now: () => now,
      );

      final first = await repository.fetchActivityCategories();
      now = now.add(const Duration(hours: 13));
      final second = await repository.fetchActivityCategories();

      expect(first.single.code, 'CULTURE_TRADITION');
      expect(second.single.code, 'CULTURE_TRADITION');
      expect(client.callCount, 2);
    });

    test('separates category cache by selected language', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final preferences = MateyaLanguagePreferences.instance;
      final client = _FakeMateyaApiClient(<Object? Function()>[
        () => <String, Object?>{
          'items': <Object?>[
            <String, Object?>{
              'code': 'TOURIST_ATTRACTION',
              'label': '旅游景点',
              'displayOrder': 1,
              'active': true,
              'children': const <Object?>[],
            },
          ],
        },
        () => <String, Object?>{
          'items': <Object?>[
            <String, Object?>{
              'code': 'TOURIST_ATTRACTION',
              'label': '관광지',
              'displayOrder': 1,
              'active': true,
              'children': const <Object?>[],
            },
          ],
        },
      ]);
      final repository = ApiActivityCategoryRepository(apiClient: client);

      await preferences.setCurrentCode('zh-Hans');
      final chinese = await repository.fetchActivityCategories();

      await preferences.setCurrentCode('ko');
      final korean = await repository.fetchActivityCategories();

      await preferences.setCurrentCode('zh-Hans');
      final chineseAgain = await repository.fetchActivityCategories();

      expect(chinese.single.label, '旅游景点');
      expect(korean.single.label, '관광지');
      expect(chineseAgain.single.label, '旅游景点');
      expect(client.callCount, 2);
    });
  });
}

class _FakeMateyaApiClient extends MateyaApiClient {
  _FakeMateyaApiClient(this._responses)
    : super(baseUrl: 'https://example.com', sessionStore: AuthSessionStore());

  final List<Object? Function()> _responses;
  int callCount = 0;

  @override
  Future<Object?> getJson(
    String path, {
    Map<String, String> queryParameters = const <String, String>{},
    Map<String, List<String>> queryParametersAll =
        const <String, List<String>>{},
    bool requiresAuth = false,
    bool logFailure = true,
  }) async {
    final index = callCount < _responses.length
        ? callCount
        : _responses.length - 1;
    callCount += 1;
    return _responses[index]();
  }
}
