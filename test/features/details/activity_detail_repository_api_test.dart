import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/details/data/activity_detail_repository.dart';
import 'package:mateya_app/features/home/domain/home_models.dart';
import 'package:mateya_app/shared/auth/auth_session.dart';
import 'package:mateya_app/shared/network/mateya_api_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fetchDetail requests review stats with auth', () async {
    final client = _FakeMateyaApiClient(<String, Object?>{
      '/api/v1/activities/2': <String, Object?>{
        'title': 'Han River Picnic',
        'placeName': 'Han River Park',
        'placeAddress': 'Seoul',
        'startAt': '2026-06-20T10:00:00Z',
        'endAt': '2026-06-20T12:00:00Z',
        'priceAmount': 15000,
        'participantCount': 3,
        'capacity': 8,
        'representativeImageUrl': 'https://example.com/activity.jpg',
        'hostedByMe': false,
        'participationStatus': 'NONE',
        'favorited': false,
        'description': 'Bring snacks.',
        'participantPreviews': const <Object?>[],
        'hostProfile': <String, Object?>{
          'userId': 9,
          'displayName': 'Host',
          'englishName': 'Host',
          'primaryCountry': 'KR',
          'primaryLanguage': 'ko',
          'profileImageUrl': 'https://example.com/host.jpg',
        },
      },
      '/api/v1/activities/2/reviews': <String, Object?>{
        'items': <Object?>[
          <String, Object?>{
            'id': 10,
            'userId': 11,
            'authorDisplayName': 'Reviewer',
            'authorProfileImageUrl': 'https://example.com/reviewer.jpg',
            'createdAt': '2026-06-21T09:00:00Z',
            'rating': 5,
            'body': 'Great activity',
            'originalBody': 'Great activity',
            'helpfulCount': 0,
            'helpfulByMe': false,
            'imageUrls': const <Object?>[],
          },
        ],
      },
      '/api/v1/activities/2/reviews/stats': <String, Object?>{
        'averageRating': 5.0,
        'totalCount': 1,
        'ratingDistribution': <String, Object?>{
          '1': 0,
          '2': 0,
          '3': 0,
          '4': 0,
          '5': 1,
        },
      },
    });
    final repository = ApiActivityDetailRepository(apiClient: client);

    await repository.fetchDetail(_activity);

    expect(
      client.requiresAuthByPath['/api/v1/activities/2/reviews/stats'],
      isTrue,
    );
  });
}

final ActivityItem _activity = ActivityItem(
  id: '2',
  categoryId: 'culture',
  categoryLabel: 'Culture',
  title: 'Picnic',
  place: 'Seoul',
  startAt: DateTime.utc(2026, 6, 20, 10),
  endAt: DateTime.utc(2026, 6, 20, 12),
  price: 15000,
  rating: 4.5,
  participantCount: 3,
  participantCapacity: 8,
  distanceKm: 1,
  audiences: <ActivityAudienceOption>{ActivityAudienceOption.everyone},
  languages: <String>{'ko'},
  statuses: <ActivityStatusOption>{ActivityStatusOption.recruiting},
  imageUrl: 'https://example.com/activity.jpg',
);

class _FakeMateyaApiClient extends MateyaApiClient {
  _FakeMateyaApiClient(this._responses)
    : super(baseUrl: 'https://example.com', sessionStore: AuthSessionStore());

  final Map<String, Object?> _responses;
  final Map<String, bool> requiresAuthByPath = <String, bool>{};

  @override
  Future<Object?> getJson(
    String path, {
    Map<String, String> queryParameters = const <String, String>{},
    Map<String, List<String>> queryParametersAll =
        const <String, List<String>>{},
    bool requiresAuth = false,
    bool logFailure = true,
  }) async {
    requiresAuthByPath[path] = requiresAuth;
    final response = _responses[path];
    if (response == null) {
      throw StateError('Missing fake response for $path');
    }
    return response;
  }
}
