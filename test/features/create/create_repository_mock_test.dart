import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/create/data/create_repository.dart';
import 'package:mateya_app/features/create/domain/create_models.dart';

void main() {
  group('MockCreateRepository', () {
    test(
      'recommended places prefer nearest matches within selected categories',
      () async {
        final repository = MockCreateRepository();

        final results = await repository.fetchRecommendedPlaces(
          flowType: CreateFlowType.group,
          categoryIds: const <String>{'CULTURE_TRADITION'},
        );

        expect(results.map((place) => place.id), <String>[
          'gyeongbokgung',
          'bukchon',
          'icheon-ceramic',
        ]);
      },
    );

    test(
      'class flow recommendations ignore category filter but keep detail filter',
      () async {
        final repository = MockCreateRepository();

        final results = await repository.fetchRecommendedPlaces(
          flowType: CreateFlowType.classRegistration,
          categoryIds: const <String>{'SHOPPING'},
          categoryDetailCode: 'HANOK',
        );

        expect(results.map((place) => place.id), <String>['bukchon']);
      },
    );

    test(
      'search sorts prefix matches before farther substring matches',
      () async {
        final repository = MockCreateRepository();

        final results = await repository.searchPlaces(
          query: '광장',
          flowType: CreateFlowType.group,
        );

        expect(results.map((place) => place.id), <String>[
          'gwangjang',
          'gyeongbokgung',
          'suwon-festival',
        ]);
      },
    );

    test(
      'search respects category and detail filters for group flow',
      () async {
        final repository = MockCreateRepository();

        final results = await repository.searchPlaces(
          query: '공방',
          flowType: CreateFlowType.group,
          categoryIds: const <String>{'CULTURE_TRADITION'},
          categoryDetailCode: 'CRAFT_WORKSHOP',
        );

        expect(results.map((place) => place.id), <String>['icheon-ceramic']);
      },
    );

    test('search raises network failure for the sentinel query', () async {
      final repository = MockCreateRepository();

      await expectLater(
        () => repository.searchPlaces(
          query: 'network-error',
          flowType: CreateFlowType.group,
        ),
        throwsA(
          isA<CreateRepositoryException>().having(
            (error) => error.type,
            'type',
            CreateRepositoryFailureType.network,
          ),
        ),
      );
    });
  });
}
