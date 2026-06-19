import '../../domain/mypage_models.dart';

const int kMyPageBadgeCatalogCount = 7;

class MyPageBadgeVisual {
  const MyPageBadgeVisual({
    required this.key,
    required this.label,
    required this.activeAssetPath,
    required this.disabledAssetPath,
  });

  final String key;
  final String label;
  final String activeAssetPath;
  final String disabledAssetPath;

  String assetPathFor(bool isEarned) =>
      isEarned ? activeAssetPath : disabledAssetPath;
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
    activeAssetPath: 'assets/images/badges/badge - traditional.png',
    disabledAssetPath: 'assets/images/badges/badge - traditional  disabled.png',
  ),
  MyPageBadgeVisual(
    key: 'active_person',
    label: 'active person',
    activeAssetPath: 'assets/images/badges/badge - activity.png',
    disabledAssetPath: 'assets/images/badges/badge - activity disabled.png',
  ),
  MyPageBadgeVisual(
    key: 'festive',
    label: 'festive!',
    activeAssetPath: 'assets/images/badges/badge - festival.png',
    disabledAssetPath: 'assets/images/badges/badge - festival disabled.png',
  ),
  MyPageBadgeVisual(
    key: 'food_lover',
    label: 'food lover',
    activeAssetPath: 'assets/images/badges/badge - foodlover.png',
    disabledAssetPath: 'assets/images/badges/badge - foodlover disabled.png',
  ),
  MyPageBadgeVisual(
    key: 'language_sharing',
    label: 'language sharing',
    activeAssetPath: 'assets/images/badges/badge - language sharing.png',
    disabledAssetPath:
        'assets/images/badges/badge - language sharing disabled.png',
  ),
  MyPageBadgeVisual(
    key: 'craftsman',
    label: 'craftsman',
    activeAssetPath: 'assets/images/badges/badge - craftman.png',
    disabledAssetPath: 'assets/images/badges/badge - craftman disabled.png',
  ),
  MyPageBadgeVisual(
    key: 'tourist',
    label: 'tourist',
    activeAssetPath: 'assets/images/badges/badge - tourist.png',
    disabledAssetPath: 'assets/images/badges/badge - tourist disabled.png',
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
