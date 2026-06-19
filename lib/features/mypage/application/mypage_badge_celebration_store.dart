import 'package:shared_preferences/shared_preferences.dart';

import '../domain/mypage_models.dart';

abstract interface class MyPageBadgeCelebrationStore {
  Future<List<ActivityBadge>> collectNewBadges({
    required String userId,
    required List<ActivityBadge> badges,
  });
}

class SharedPreferencesMyPageBadgeCelebrationStore
    implements MyPageBadgeCelebrationStore {
  static const String _initializedKeyPrefix =
      'mateya.mypage.badges.initialized.';
  static const String _seenKeyPrefix = 'mateya.mypage.badges.seen.';

  @override
  Future<List<ActivityBadge>> collectNewBadges({
    required String userId,
    required List<ActivityBadge> badges,
  }) async {
    if (userId.trim().isEmpty) {
      return const <ActivityBadge>[];
    }

    final preferences = await SharedPreferences.getInstance();
    final initializedKey = '$_initializedKeyPrefix$userId';
    final seenKey = '$_seenKeyPrefix$userId';
    final validBadges = badges
        .where((badge) => badge.id.trim().isNotEmpty && badge.isEarned)
        .toList(growable: false);
    final badgeIds = validBadges
        .map((badge) => badge.id)
        .toList(growable: false);

    if (!(preferences.getBool(initializedKey) ?? false)) {
      await preferences.setBool(initializedKey, true);
      await preferences.setStringList(seenKey, badgeIds);
      return const <ActivityBadge>[];
    }

    final seenBadgeIds =
        preferences.getStringList(seenKey)?.toSet() ?? <String>{};
    final newBadges = validBadges
        .where((badge) => !seenBadgeIds.contains(badge.id))
        .toList(growable: false);
    if (newBadges.isEmpty) {
      return const <ActivityBadge>[];
    }

    await preferences.setStringList(
      seenKey,
      <String>{
        ...seenBadgeIds,
        ...newBadges.map((badge) => badge.id),
      }.toList(growable: false),
    );
    return newBadges;
  }
}
