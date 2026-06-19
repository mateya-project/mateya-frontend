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
  final unmatchedBadges = <ActivityBadge>[];

  for (final badge in badges) {
    final key = _resolveBadgeVisualKey(badge);
    if (key == null) {
      unmatchedBadges.add(badge);
      continue;
    }
    if (earnedBadgeByKey.containsKey(key)) {
      continue;
    }
    earnedBadgeByKey[key] = badge;
  }

  final slots = <MyPageBadgeDisplaySlot>[];
  var unmatchedIndex = 0;

  for (final visual in kMyPageBadgeCatalog) {
    final matchedBadge = earnedBadgeByKey[visual.key];
    final fallbackBadge =
        matchedBadge == null && unmatchedIndex < unmatchedBadges.length
        ? unmatchedBadges[unmatchedIndex++]
        : null;
    slots.add(
      MyPageBadgeDisplaySlot(
        visual: visual,
        badge: matchedBadge ?? fallbackBadge,
      ),
    );
  }

  return slots;
}

String? _resolveBadgeVisualKey(ActivityBadge badge) {
  final explicitCode = badge.badgeCode?.trim().toLowerCase();
  if (explicitCode != null && explicitCode.isNotEmpty) {
    switch (explicitCode) {
      case 'traditional':
      case 'culture_tradition':
        return 'traditional';
      case 'active_person':
      case 'activity':
      case 'activity_leports':
      case 'sports':
      case 'sports_mate':
        return 'active_person';
      case 'festive':
      case 'event_performance_festival':
        return 'festive';
      case 'food_lover':
      case 'shopping':
      case 'market_lover':
        return 'food_lover';
      case 'language_sharing':
      case 'public_facility':
      case 'local_connector':
        return 'language_sharing';
      case 'craftsman':
      case 'craftman':
        return 'craftsman';
      case 'tourist':
      case 'tourist_attraction':
      case 'travel_course':
      case 'route_explorer':
        return 'tourist';
    }
  }

  final label = badge.label.trim().toLowerCase();
  final categoryLabel = badge.categoryLabel.trim();

  if (label.contains('traditional') || categoryLabel.contains('전통')) {
    return 'traditional';
  }
  if (label.contains('active') ||
      label.contains('sports mate') ||
      categoryLabel.contains('스포츠')) {
    return 'active_person';
  }
  if (label.contains('festive') || categoryLabel.contains('축제')) {
    return 'festive';
  }
  if (label.contains('food') ||
      label.contains('market lover') ||
      categoryLabel.contains('음식')) {
    return 'food_lover';
  }
  if (label.contains('language') ||
      label.contains('local connector') ||
      categoryLabel.contains('언어')) {
    return 'language_sharing';
  }
  if (label.contains('craft') || categoryLabel.contains('공예')) {
    return 'craftsman';
  }
  if (label.contains('tourist') ||
      label.contains('route explorer') ||
      categoryLabel.contains('관광')) {
    return 'tourist';
  }
  return null;
}
