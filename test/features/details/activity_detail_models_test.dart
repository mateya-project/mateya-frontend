import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/details/domain/activity_detail_models.dart';

void main() {
  group('ActivityHostProfile.displayName', () {
    test('shows one name when primary and localized names are equal', () {
      const host = ActivityHostProfile(
        userId: 'host-1',
        name: '박민정',
        localizedName: '박민정',
        locationLabel: 'Language Korean · Korea',
      );

      expect(host.displayName, '박민정');
    });

    test('concatenates names when primary and localized names differ', () {
      const host = ActivityHostProfile(
        userId: 'host-2',
        name: '박민정',
        localizedName: 'Bak Minjeong',
        locationLabel: 'Language Korean · Korea',
      );

      expect(host.displayName, '박민정 · Bak Minjeong');
    });
  });

  group('ActivityReview.visibleBody', () {
    test(
      'falls back to original text when translation is marked visible but missing',
      () {
        final review = ActivityReview(
          id: 'review-1',
          authorName: '작성자',
          submittedAt: DateTime(2026, 6, 20),
          rating: 5,
          originalText: '원문 후기',
          canToggleTranslation: true,
          isTranslationVisible: true,
        );

        expect(review.visibleBody, '원문 후기');
      },
    );
  });
}
