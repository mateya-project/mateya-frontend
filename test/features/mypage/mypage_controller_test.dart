import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/mypage/application/mypage_badge_celebration_store.dart';
import 'package:mateya_app/features/mypage/application/mypage_controller.dart';
import 'package:mateya_app/features/mypage/data/mypage_repository.dart';
import 'package:mateya_app/features/mypage/domain/mypage_models.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';

void main() {
  test('controller shows queued badge celebrations in order', () async {
    final controller = MyPageController(
      repository: MockMyPageRepository(),
      flowKind: FlowKind.guest,
      badgeCelebrationStore: _FakeBadgeCelebrationStore(
        newBadges: const <ActivityBadge>[
          ActivityBadge(
            id: 'traditional',
            label: 'traditional!',
            categoryLabel: '문화/전통',
            badgeCode: 'TRADITIONAL',
          ),
          ActivityBadge(
            id: 'walk',
            label: 'tourist',
            categoryLabel: '관광지',
            badgeCode: 'TOURIST',
          ),
        ],
      ),
    );

    await controller.initialize();

    expect(controller.activeBadgeCelebration?.id, 'traditional');
    expect(controller.badgeCelebrationVersion, 1);

    controller.dismissBadgeCelebration();

    expect(controller.activeBadgeCelebration?.id, 'walk');
    expect(controller.badgeCelebrationVersion, 2);

    controller.dismissBadgeCelebration();

    expect(controller.activeBadgeCelebration, isNull);
  });
}

class _FakeBadgeCelebrationStore implements MyPageBadgeCelebrationStore {
  const _FakeBadgeCelebrationStore({required this.newBadges});

  final List<ActivityBadge> newBadges;

  @override
  Future<List<ActivityBadge>> collectNewBadges({
    required String userId,
    required List<ActivityBadge> badges,
  }) async {
    return newBadges;
  }
}
