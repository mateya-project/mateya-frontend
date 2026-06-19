import '../../domain/mypage_models.dart';

const int kMyPageBadgeCatalogCount = 7;

class MyPageBadgeVisual {
  const MyPageBadgeVisual({
    required this.key,
    required this.label,
    required this.assetPath,
  });

  final String key;
  final String label;
  final String assetPath;
}

class MyPageBadgeDisplaySlot {
  const MyPageBadgeDisplaySlot({required this.visual, this.badge});

  final MyPageBadgeVisual visual;
  final ActivityBadge? badge;

  bool get isEarned => badge != null;
}

const List<MyPageBadgeVisual> kMyPageBadgeCatalog = <MyPageBadgeVisual>[
  MyPageBadgeVisual(
    key: 'traditional',
    label: 'traditional!',
    assetPath: 'assets/images/badges/traditional.png',
  ),
  MyPageBadgeVisual(
    key: 'active_person',
    label: 'active person',
    assetPath: 'assets/images/badges/active_person.png',
  ),
  MyPageBadgeVisual(
    key: 'festive',
    label: 'festive!',
    assetPath: 'assets/images/badges/festive.png',
  ),
  MyPageBadgeVisual(
    key: 'food_lover',
    label: 'food lover',
    assetPath: 'assets/images/badges/food_lover.png',
  ),
  MyPageBadgeVisual(
    key: 'language_sharing',
    label: 'language sharing',
    assetPath: 'assets/images/badges/language_sharing.png',
  ),
  MyPageBadgeVisual(
    key: 'craftsman',
    label: 'craftsman',
    assetPath: 'assets/images/badges/craftsman.png',
  ),
  MyPageBadgeVisual(
    key: 'tourist',
    label: 'tourist',
    assetPath: 'assets/images/badges/tourist.png',
  ),
];

List<MyPageBadgeDisplaySlot> buildMyPageBadgeSlots(List<ActivityBadge> badges) {
  final earnedBadgeByKey = <String, ActivityBadge>{};

  for (final badge in badges) {
    final key = _resolveBadgeVisualKey(badge);
    if (key == null || earnedBadgeByKey.containsKey(key)) {
      continue;
    }
    earnedBadgeByKey[key] = badge;
  }

  return kMyPageBadgeCatalog
      .map(
        (visual) => MyPageBadgeDisplaySlot(
          visual: visual,
          badge: earnedBadgeByKey[visual.key],
        ),
      )
      .toList(growable: false);
}

String? _resolveBadgeVisualKey(ActivityBadge badge) {
  final label = badge.label.trim().toLowerCase();
  final categoryLabel = badge.categoryLabel.trim();

  if (label.contains('traditional') || categoryLabel.contains('전통')) {
    return 'traditional';
  }
  if (label.contains('active') || categoryLabel.contains('스포츠')) {
    return 'active_person';
  }
  if (label.contains('festive') || categoryLabel.contains('축제')) {
    return 'festive';
  }
  if (label.contains('food') || categoryLabel.contains('음식')) {
    return 'food_lover';
  }
  if (label.contains('language') || categoryLabel.contains('언어')) {
    return 'language_sharing';
  }
  if (label.contains('craft') || categoryLabel.contains('공예')) {
    return 'craftsman';
  }
  if (label.contains('tourist') || categoryLabel.contains('관광')) {
    return 'tourist';
  }
  return null;
}
