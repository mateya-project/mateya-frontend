import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/mypage/application/mypage_badge_celebration_store.dart';
import 'package:mateya_app/features/mypage/domain/mypage_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'store baselines current badges first and returns only later additions',
    () async {
      SharedPreferences.setMockInitialValues(const <String, Object>{});
      final store = SharedPreferencesMyPageBadgeCelebrationStore();

      final initial = await store.collectNewBadges(
        userId: 'guest-me',
        badges: const <ActivityBadge>[
          ActivityBadge(
            id: 'traditional',
            label: 'traditional!',
            categoryLabel: '문화/전통',
            badgeCode: 'TRADITIONAL',
          ),
        ],
      );
      final added = await store.collectNewBadges(
        userId: 'guest-me',
        badges: const <ActivityBadge>[
          ActivityBadge(
            id: 'traditional',
            label: 'traditional!',
            categoryLabel: '문화/전통',
            badgeCode: 'TRADITIONAL',
          ),
          ActivityBadge(
            id: 'tourist',
            label: 'tourist',
            categoryLabel: '관광지',
            badgeCode: 'TOURIST',
          ),
        ],
      );

      expect(initial, isEmpty);
      expect(added.map((badge) => badge.id), <String>['tourist']);
    },
  );
}
