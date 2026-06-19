import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/mypage/domain/mypage_models.dart';
import 'package:mateya_app/features/mypage/presentation/widgets/mypage_badge_catalog.dart';

void main() {
  test('buildMyPageBadgeSlots keeps only four supported badge slots', () {
    final slots = buildMyPageBadgeSlots(const <ActivityBadge>[
      ActivityBadge(
        id: 'badge-1',
        label: 'traditional!',
        categoryLabel: '문화/전통',
        badgeCode: 'TRADITIONAL',
      ),
      ActivityBadge(
        id: 'badge-2',
        label: 'active person',
        categoryLabel: '액티비티/레포츠',
        badgeCode: 'ACTIVE_PERSON',
      ),
      ActivityBadge(
        id: 'badge-legacy',
        label: 'food lover',
        categoryLabel: '쇼핑',
        badgeCode: 'FOOD_LOVER',
      ),
    ]);

    expect(slots, hasLength(kMyPageBadgeCatalogCount));
    expect(slots.where((slot) => slot.isEarned), hasLength(2));
    expect(slots.map((slot) => slot.visual.key), <String>[
      'traditional',
      'active_person',
      'festive',
      'tourist',
    ]);
  });

  test('travel course badge resolves to tourist visual key', () {
    const badge = ActivityBadge(
      id: 'badge-tourist',
      label: 'tourist',
      categoryLabel: '여행코스',
      badgeCode: 'TRAVEL_COURSE',
    );

    expect(resolveMyPageBadgeVisualKey(badge), 'tourist');
    expect(findMyPageBadgeVisual(badge)?.label, 'tourist');
  });
}
