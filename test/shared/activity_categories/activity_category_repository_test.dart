import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/shared/activity_categories/activity_category_repository.dart';
import 'package:mateya_app/shared/auth/auth_session.dart';
import 'package:mateya_app/shared/network/mateya_api_client.dart';

void main() {
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
