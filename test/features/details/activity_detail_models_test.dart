import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/details/domain/activity_detail_models.dart';

void main() {
  group('ActivityHostProfile.displayName', () {
    test('shows one name when primary and localized names are equal', () {
      const host = ActivityHostProfile(
        userId: 'host-1',
        name: '박민정',
        localizedName: '박민정',
        locationLabel: 'Language Korean · Korea',
      );

      expect(host.displayName, '박민정');
    });

    test('concatenates names when primary and localized names differ', () {
      const host = ActivityHostProfile(
        userId: 'host-2',
        name: '박민정',
        localizedName: 'Bak Minjeong',
        locationLabel: 'Language Korean · Korea',
      );

      expect(host.displayName, '박민정 · Bak Minjeong');
    });
  });
}
