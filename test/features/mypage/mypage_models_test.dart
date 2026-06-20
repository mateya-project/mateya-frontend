import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/mypage/domain/mypage_models.dart';

void main() {
  group('ProfileSummary', () {
    const profile = ProfileSummary(
      id: 'user-1',
      name: '박민정',
      englishName: 'Bak Minjeong',
      residence: '우만동',
      primaryLanguageCode: 'ko',
      primaryLanguageLabel: '한국어',
      primaryCountryCode: 'kr',
      primaryCountryLabel: '대한민국',
      activityCountryCode: 'kr',
      activityCountryLabel: 'Korea',
    );

    test('displayName appends english name when present', () {
      expect(profile.displayName, '박민정 · Bak Minjeong');
    });

    test('residenceDisplay combines country and neighborhood', () {
      expect(profile.residenceDisplay, 'Korea 우만동');
    });
  });
}
