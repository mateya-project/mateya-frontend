import '../../domain/mypage_models.dart';

const int kMyPageBadgeCatalogCount = 4;

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

  bool get isEarned => badge?.isEarned ?? false;
  String? get remoteImageUrl => badge?.imageUrl;
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
    key: 'tourist',
    label: 'tourist',
    activeAssetPath: 'assets/images/badges/badge - tourist.png',
    disabledAssetPath: 'assets/images/badges/badge - tourist disabled.png',
  ),
];

List<MyPageBadgeDisplaySlot> buildMyPageBadgeSlots(List<ActivityBadge> badges) {
  final earnedBadgeByKey = <String, ActivityBadge>{};

  for (final badge in badges) {
    final key = resolveMyPageBadgeVisualKey(badge);
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

MyPageBadgeVisual? findMyPageBadgeVisual(ActivityBadge badge) {
  final key = resolveMyPageBadgeVisualKey(badge);
  if (key == null) {
    return null;
  }
  for (final visual in kMyPageBadgeCatalog) {
    if (visual.key == key) {
      return visual;
    }
  }
  return null;
}

String? resolveMyPageBadgeVisualKey(ActivityBadge badge) {
  final explicitCode = badge.badgeCode?.trim().toLowerCase();
  if (explicitCode != null && explicitCode.isNotEmpty) {
    switch (explicitCode) {
      case 'traditional':
      case 'culture_tradition':
        return 'traditional';
      case 'active_person':
      case 'sports':
      case 'activity_leports':
        return 'active_person';
      case 'festive':
      case 'event_performance_festival':
        return 'festive';
      case 'tourist':
      case 'tourist_attraction':
      case 'travel_course':
        return 'tourist';
      case 'food_lover':
      case 'language_sharing':
      case 'craftsman':
      case 'public_facility':
      case 'shopping':
        return null;
    }
  }

  final label = badge.label.trim().toLowerCase();
  final categoryLabel = badge.categoryLabel.trim();

  if (label.contains('traditional') || categoryLabel.contains('전통')) {
    return 'traditional';
  }
  if (label.contains('active') ||
      categoryLabel.contains('스포츠') ||
      categoryLabel.contains('액티비티') ||
      categoryLabel.contains('레포츠')) {
    return 'active_person';
  }
  if (label.contains('festive') ||
      categoryLabel.contains('행사') ||
      categoryLabel.contains('공연') ||
      categoryLabel.contains('축제')) {
    return 'festive';
  }
  if (label.contains('tourist') ||
      categoryLabel.contains('관광') ||
      categoryLabel.contains('여행코스')) {
    return 'tourist';
  }
  return null;
}
