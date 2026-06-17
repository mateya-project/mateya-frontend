import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/mypage/data/mypage_repository.dart';

void main() {
  group('MockMyPageRepository', () {
    test(
      'fetchBundle exposes configured pages and selection options',
      () async {
        final repository = MockMyPageRepository();

        final bundle = await repository.fetchBundle(isBusinessMode: false);

        expect(bundle.personalPage.profile.name, '유나');
        expect(bundle.otherProfile.profile.name, '지수');
        expect(bundle.recentActivity.activities, hasLength(5));
        expect(bundle.businessPage.profile.name, '성수 티 스튜디오');
        expect(bundle.languageOptions.map((item) => item.code), <String>[
          'ko',
          'en',
          'ja',
          'zh',
        ]);
        expect(bundle.countryOptions.map((item) => item.code), contains('us'));
      },
    );

    test(
      'updatePrimaryPreferences resolves labels from known options',
      () async {
        final repository = MockMyPageRepository();

        final result = await repository.updatePrimaryPreferences(
          displayName: '유나',
          languageCode: 'ja',
          countryCode: 'jp',
        );

        expect(result.profile.primaryLanguageCode, 'ja');
        expect(result.profile.primaryLanguageLabel, '일본어');
        expect(result.profile.primaryCountryCode, 'jp');
        expect(result.profile.primaryCountryLabel, '일본');
      },
    );

    test('updateBusinessIntroduction preserves place when null', () async {
      final repository = MockMyPageRepository();

      final result = await repository.updateBusinessIntroduction(
        introduction: '새 소개 문구',
      );

      expect(result.profile.oneLineIntroduction, '새 소개 문구');
      expect(result.profile.placeLabel, '성수 티하우스');
    });

    test('updateFriendship toggles based on current state', () async {
      final repository = MockMyPageRepository();

      final becameFriend = await repository.updateFriendship(
        targetUserId: 'other-jisoo',
        isFriend: false,
      );
      final removedFriend = await repository.updateFriendship(
        targetUserId: 'other-jisoo',
        isFriend: true,
      );

      expect(becameFriend.isFriend, isTrue);
      expect(removedFriend.isFriend, isFalse);
    });
  });
}
