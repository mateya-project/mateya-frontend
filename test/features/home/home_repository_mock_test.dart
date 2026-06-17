import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/home/data/home_repository.dart';
import 'package:mateya_app/features/home/domain/home_models.dart';

void main() {
  group('MockHomeRepository', () {
    test('explore list excludes featured activities', () async {
      final repository = MockHomeRepository();

      final page = await repository.fetchExploreActivities(
        page: 0,
        keyword: '',
        filter: const ExploreFilter(),
      );

      expect(page.items, isNotEmpty);
      expect(page.items.any((item) => item.isFeatured), isFalse);
    });

    test(
      'keyword search keeps recommended order for matching activities',
      () async {
        final repository = MockHomeRepository();

        final page = await repository.fetchExploreActivities(
          page: 0,
          keyword: '한강',
          filter: const ExploreFilter(distance: DistanceRangeOption.within1km),
        );

        expect(page.items.map((item) => item.id), <String>[
          'river-bus',
          'night-walk',
        ]);
      },
    );
  });
}
