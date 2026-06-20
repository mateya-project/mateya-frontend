import '../../../../shared/localization/mateya_localizations.dart';
import '../../domain/mypage_models.dart';

const int kMyPageBadgeCatalogCount = 4;

class MyPageBadgeVisual {
  const MyPageBadgeVisual({
    required this.key,
    required this.activeAssetPath,
    required this.disabledAssetPath,
  });

  final String key;
  final String activeAssetPath;
  final String disabledAssetPath;

  String assetPathFor(bool isEarned) =>
      isEarned ? activeAssetPath : disabledAssetPath;

  String get localizedLabel {
    final l10n = MateyaLocalizations.current;
    return switch (key) {
      'traditional' => l10n.mypageBadgeTraditional,
      'active_person' => l10n.mypageBadgeActivePerson,
      'festive' => l10n.mypageBadgeFestive,
      'tourist' => l10n.mypageBadgeTourist,
      _ => key,
    };
  }

  String get unlockRequirementMessage {
    final l10n = MateyaLocalizations.current;
    return switch (key) {
      'traditional' => l10n.mypageBadgeRequirementTraditional,
      'active_person' => l10n.mypageBadgeRequirementActivePerson,
      'festive' => l10n.mypageBadgeRequirementFestive,
      'tourist' => l10n.mypageBadgeRequirementTourist,
      _ => localizedLabel,
    };
  }
}

class MyPageBadgeDisplaySlot {
  const MyPageBadgeDisplaySlot({required this.visual, this.badge});

  final MyPageBadgeVisual visual;
  final ActivityBadge? badge;

  bool get isEarned => badge?.isEarned ?? false;
}

const List<MyPageBadgeVisual> kMyPageBadgeCatalog = <MyPageBadgeVisual>[
  MyPageBadgeVisual(
    key: 'traditional',
    activeAssetPath: 'assets/images/badges/badge - traditional.png',
    disabledAssetPath: 'assets/images/badges/badge - traditional  disabled.png',
  ),
  MyPageBadgeVisual(
    key: 'active_person',
    activeAssetPath: 'assets/images/badges/badge - activeperson.png',
    disabledAssetPath: 'assets/images/badges/badge - activeperson disabled.png',
  ),
  MyPageBadgeVisual(
    key: 'festive',
    activeAssetPath: 'assets/images/badges/badge - festival.png',
    disabledAssetPath: 'assets/images/badges/badge - festival disabled.png',
  ),
  MyPageBadgeVisual(
    key: 'tourist',
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
  final l10n = MateyaLocalizations.current;

  if (label.contains('traditional') ||
      categoryLabel.contains(l10n.activityCategoryCultureTradition)) {
    return 'traditional';
  }
  if (label.contains('active') ||
      categoryLabel.contains(l10n.activityCategorySports) ||
      categoryLabel.contains(l10n.activityCategoryActivityLeports)) {
    return 'active_person';
  }
  if (label.contains('festive') ||
      categoryLabel.contains(l10n.activityCategoryEventPerformanceFestival)) {
    return 'festive';
  }
  if (label.contains('tourist') ||
      categoryLabel.contains(l10n.activityCategoryTouristAttraction) ||
      categoryLabel.contains(l10n.activityCategoryTravelCourse)) {
    return 'tourist';
  }
  return null;
}
