import '../domain/create_models.dart';

abstract interface class CreateRepository {
  Future<List<CreatePlaceSuggestion>> fetchRecommendedPlaces({
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
  });

  Future<List<CreatePlaceSuggestion>> searchPlaces({
    required String query,
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
  });

  Future<CreateSubmitResult> submit(CreateSubmissionDraft draft);

  Future<void> delete({required String id, required CreateFlowType flowType});
}

enum CreateRepositoryFailureType { network, server }

class CreateRepositoryException implements Exception {
  const CreateRepositoryException(this.type);

  final CreateRepositoryFailureType type;
}

class MockCreateRepository implements CreateRepository {
  @override
  Future<List<CreatePlaceSuggestion>> fetchRecommendedPlaces({
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    final candidates =
        _placeSuggestions.where((place) {
            if (flowType == CreateFlowType.classRegistration) {
              return true;
            }
            if (categoryIds.isEmpty) {
              return true;
            }
            return place.categoryIds.any(categoryIds.contains);
          }).toList()
          ..sort((left, right) => left.distanceKm.compareTo(right.distanceKm));
    return candidates.take(3).toList(growable: false);
  }

  @override
  Future<List<CreatePlaceSuggestion>> searchPlaces({
    required String query,
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 420));
    final normalized = query.trim().toLowerCase();
    if (normalized == 'network-error') {
      throw const CreateRepositoryException(
        CreateRepositoryFailureType.network,
      );
    }

    final filtered = _placeSuggestions.where((place) {
      final matchesQuery =
          place.name.toLowerCase().contains(normalized) ||
          place.address.toLowerCase().contains(normalized) ||
          place.description.toLowerCase().contains(normalized);
      if (!matchesQuery) {
        return false;
      }
      if (flowType == CreateFlowType.classRegistration || categoryIds.isEmpty) {
        return true;
      }
      return place.categoryIds.any(categoryIds.contains);
    }).toList();

    filtered.sort((left, right) {
      final leftStartsWith = left.name.toLowerCase().startsWith(normalized);
      final rightStartsWith = right.name.toLowerCase().startsWith(normalized);
      if (leftStartsWith != rightStartsWith) {
        return leftStartsWith ? -1 : 1;
      }
      return left.distanceKm.compareTo(right.distanceKm);
    });

    return filtered;
  }

  @override
  Future<CreateSubmitResult> submit(CreateSubmissionDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 720));
    return CreateSubmitResult(
      id: 'created-${DateTime.now().microsecondsSinceEpoch}',
      flowType: draft.flowType,
      title: draft.title,
      placeName: draft.place.name,
      eventStartsAt: draft.eventStartsAt,
      chatStatus: ChatProvisionStatus.created,
    );
  }

  @override
  Future<void> delete({
    required String id,
    required CreateFlowType flowType,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 360));
  }
}

const List<CreatePlaceSuggestion> _placeSuggestions = <CreatePlaceSuggestion>[
  CreatePlaceSuggestion(
    id: 'gyeongbokgung',
    name: '경복궁 흥례문 광장',
    address: '서울 종로구 사직로 161',
    description: '전통문화 모임과 관광형 클래스에 적합한 대표 장소',
    distanceKm: 1,
    latitude: 37.579617,
    longitude: 126.977041,
    categoryIds: <String>{'traditional', 'walk'},
  ),
  CreatePlaceSuggestion(
    id: 'bukchon',
    name: '북촌문화센터',
    address: '서울 종로구 계동길 37',
    description: '한옥, 공예, 전통문화 체험 운영에 적합한 공간',
    distanceKm: 2,
    latitude: 37.582604,
    longitude: 126.983998,
    categoryIds: <String>{'traditional', 'craft'},
  ),
  CreatePlaceSuggestion(
    id: 'seoul-forest',
    name: '서울숲 가족마당',
    address: '서울 성동구 뚝섬로 273',
    description: '산책형 모임과 야외 액티비티에 적합한 공원형 장소',
    distanceKm: 1,
    latitude: 37.544557,
    longitude: 127.037442,
    categoryIds: <String>{'walk', 'sports'},
  ),
  CreatePlaceSuggestion(
    id: 'ttukseom-sports',
    name: '뚝섬한강공원 수변무대',
    address: '서울 광진구 강변북로 139',
    description: '러닝, 피크닉, 한강 액티비티에 적합한 장소',
    distanceKm: 3,
    latitude: 37.531011,
    longitude: 127.066887,
    categoryIds: <String>{'sports', 'walk'},
  ),
  CreatePlaceSuggestion(
    id: 'gwangjang',
    name: '광장시장 동문 입구',
    address: '서울 종로구 창경궁로 88',
    description: '음식 체험과 관광형 모임 수요가 높은 위치',
    distanceKm: 4,
    latitude: 37.570404,
    longitude: 126.999177,
    categoryIds: <String>{'food', 'walk'},
  ),
  CreatePlaceSuggestion(
    id: 'hongdae-language',
    name: '홍대입구 글로벌 라운지',
    address: '서울 마포구 양화로 188',
    description: '언어교환과 소규모 커뮤니티 클래스 진행에 적합',
    distanceKm: 5,
    latitude: 37.557317,
    longitude: 126.924107,
    categoryIds: <String>{'language', 'etc'},
  ),
  CreatePlaceSuggestion(
    id: 'suwon-festival',
    name: '수원 화성행궁 광장',
    address: '경기 수원시 팔달구 정조로 825',
    description: '지역축제 연계 모임과 야외 행사에 적합한 장소',
    distanceKm: 9,
    latitude: 37.281962,
    longitude: 127.014306,
    categoryIds: <String>{'festival', 'traditional'},
  ),
  CreatePlaceSuggestion(
    id: 'icheon-ceramic',
    name: '이천 예스파크 공방동',
    address: '경기 이천시 신둔면 경충대로 3151',
    description: '공예 클래스와 체험형 수업에 적합한 전문 공간',
    distanceKm: 10,
    latitude: 37.293792,
    longitude: 127.409215,
    categoryIds: <String>{'craft'},
  ),
];
