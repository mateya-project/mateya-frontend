import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/home/application/nearby_culture_map_controller.dart';
import 'package:mateya_app/features/home/data/nearby_culture_map_repository.dart';
import 'package:mateya_app/features/home/domain/nearby_culture_map_models.dart';
import 'package:mateya_app/features/onboarding/data/location_repository.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';
import 'package:mateya_app/shared/activity_categories/activity_category_repository.dart';

void main() {
  group('NearbyCultureMapController', () {
    test('initializes with saved location and loads culture places', () async {
      final repository = _FakeNearbyCultureMapRepository();
      final controller = NearbyCultureMapController(
        repository: repository,
        categoryRepository: _FakeCategoryRepository(),
        locationRepository: _FakeLocationRepository.success(),
        initialLocation: const NeighborhoodSelection(
          displayName: '종로구',
          latitude: 37.5798,
          longitude: 126.9785,
        ),
      );

      await controller.initialize();

      expect(controller.phase, AsyncPhase.success);
      expect(controller.selectedCategoryCode, 'CULTURE_TRADITION');
      expect(controller.selectedPlace?.id, 'place-1');
      expect(repository.lastCategoryCode, 'CULTURE_TRADITION');
      expect(repository.lastLatitude, 37.5798);
      expect(repository.lastLongitude, 126.9785);
    });

    test('changing category detail reloads places with detail code', () async {
      final repository = _FakeNearbyCultureMapRepository();
      final controller = NearbyCultureMapController(
        repository: repository,
        categoryRepository: _FakeCategoryRepository(),
        locationRepository: _FakeLocationRepository.success(),
      );

      await controller.initialize();
      await controller.selectCategoryDetail('HERITAGE');

      expect(controller.selectedCategoryDetailCode, 'HERITAGE');
      expect(repository.lastCategoryDetailCode, 'HERITAGE');
    });

    test('location failure becomes validation error', () async {
      final controller = NearbyCultureMapController(
        repository: _FakeNearbyCultureMapRepository(),
        categoryRepository: _FakeCategoryRepository(),
        locationRepository: _FakeLocationRepository.failure(
          '현재 위치를 불러오지 못했어요.',
        ),
      );

      await controller.initialize();

      expect(controller.phase, AsyncPhase.validationError);
      expect(controller.errorMessage, contains('현재 위치'));
    });
  });
}

class _FakeNearbyCultureMapRepository implements NearbyCultureMapRepository {
  double? lastLatitude;
  double? lastLongitude;
  String? lastCategoryCode;
  String? lastCategoryDetailCode;

  @override
  Future<List<NearbyCultureMapPlace>> fetchPlaces({
    required double latitude,
    required double longitude,
    required String categoryCode,
    required String keyword,
    String? categoryDetailCode,
    int radiusKm = 10,
    int limit = 20,
  }) async {
    lastLatitude = latitude;
    lastLongitude = longitude;
    lastCategoryCode = categoryCode;
    lastCategoryDetailCode = categoryDetailCode;
    return <NearbyCultureMapPlace>[
      NearbyCultureMapPlace(
        id: 'place-1',
        name: '경복궁',
        address: '서울 종로구 사직로 161',
        distanceKm: 1.2,
        latitude: 37.579617,
        longitude: 126.977041,
        categoryCode: categoryCode,
        categoryDetailCode: categoryDetailCode,
        categoryDetailName: categoryDetailCode == null ? '국가유산' : '세부유형',
      ),
    ];
  }
}

class _FakeCategoryRepository implements ActivityCategoryRepository {
  @override
  Future<List<ActivityCategoryMetadata>> fetchActivityCategories() async {
    return const <ActivityCategoryMetadata>[
      ActivityCategoryMetadata(
        code: 'CULTURE_TRADITION',
        label: '문화/전통',
        displayOrder: 1,
        active: true,
        children: <ActivityCategoryDetailMetadata>[
          ActivityCategoryDetailMetadata(
            code: 'HERITAGE',
            label: '국가유산',
            displayOrder: 1,
            active: true,
          ),
        ],
      ),
    ];
  }
}

class _FakeLocationRepository implements NeighborhoodLocationRepository {
  _FakeLocationRepository.success()
    : _result = const LocationLookupResult.success(
        NeighborhoodSelection(
          displayName: '종로구',
          latitude: 37.5798,
          longitude: 126.9785,
        ),
      );

  _FakeLocationRepository.failure(String message)
    : _result = LocationLookupResult.failure(
        LocationFailure(LocationFailureType.unknown, message),
      );

  final LocationLookupResult _result;

  @override
  Future<LocationLookupResult> resolveCurrentNeighborhood() async => _result;

  @override
  Future<LocationLookupResult> resolveNeighborhoodQuery(String query) async {
    return _result;
  }
}
