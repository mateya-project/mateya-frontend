import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/details/data/activity_detail_repository.dart';
import 'package:mateya_app/features/home/domain/home_models.dart';

void main() {
  group('MockActivityDetailRepository', () {
    test('featured review seeds are deep-cloned on each fetch', () async {
      final repository = MockActivityDetailRepository();
      final activity = _activity(id: 'featured-hike');

      final first = await repository.fetchDetail(activity);
      first.reviews.first.imageUrls.add('https://example.com/mutated.webp');

      final second = await repository.fetchDetail(activity);

      expect(second.reviews, hasLength(7));
      expect(
        second.reviews.first.imageUrls,
        isNot(contains('https://example.com/mutated.webp')),
      );
    });

    test(
      'gallery falls back to a placeholder slot when no image exists',
      () async {
        final repository = MockActivityDetailRepository();

        final detail = await repository.fetchDetail(
          _activity(id: 'plain-activity', imageUrl: null),
        );

        expect(detail.imageUrls, const <String>['']);
      },
    );
  });
}

ActivityItem _activity({required String id, Object? imageUrl = _sentinel}) {
  return ActivityItem(
    id: id,
    categoryId: 'CULTURE_TRADITION',
    categoryLabel: '문화/전통',
    title: '서울 산책',
    place: '경복궁',
    startAt: DateTime(2026, 6, 21, 10),
    endAt: DateTime(2026, 6, 21, 12),
    price: 0,
    rating: 4.8,
    participantCount: 4,
    participantCapacity: 10,
    distanceKm: 2,
    audiences: const <ActivityAudienceOption>{ActivityAudienceOption.everyone},
    languages: const <String>{'ko', 'en'},
    statuses: const <ActivityStatusOption>{ActivityStatusOption.recruiting},
    imageUrl: imageUrl == _sentinel
        ? 'https://example.com/cover.jpg'
        : imageUrl as String?,
  );
}

const Object _sentinel = Object();
