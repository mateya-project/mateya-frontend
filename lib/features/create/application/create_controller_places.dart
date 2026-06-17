part of 'create_controller.dart';

Future<void> _loadRecommendedPlacesFor(CreateController controller) async {
  controller._placePhase = AsyncPhase.loading;
  controller._fieldErrors.remove('place');
  controller._notifyChanged();

  try {
    controller._recommendedPlaces = await controller.repository
        .fetchRecommendedPlaces(
          flowType: controller.flowType,
          categoryIds: controller._selectedCategoryIds,
          categoryDetailCode: controller._selectedCategoryDetailCode,
        );
    controller._placePhase = AsyncPhase.success;
  } on CreateRepositoryException catch (error) {
    controller._recommendedPlaces = const <CreatePlaceSuggestion>[];
    controller._placePhase = error.type == CreateRepositoryFailureType.network
        ? AsyncPhase.networkError
        : AsyncPhase.serverError;
    controller._emitToast(
      error.type == CreateRepositoryFailureType.network
          ? '추천 장소를 불러오지 못했어요. 네트워크 상태를 확인해 주세요.'
          : '추천 장소를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.',
    );
  } catch (_) {
    controller._recommendedPlaces = const <CreatePlaceSuggestion>[];
    controller._placePhase = AsyncPhase.serverError;
    controller._emitToast('추천 장소를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.');
  }

  controller._notifyChanged();
}

Future<void> _searchPlacesFor(CreateController controller) async {
  final query = controller._searchQuery.trim();
  if (query.isEmpty) {
    controller._fieldErrors = <String, String?>{
      ...controller._fieldErrors,
      'searchQuery': '장소명을 입력해 주세요.',
    };
    controller._notifyChanged();
    return;
  }

  controller._placePhase = AsyncPhase.loading;
  controller._clearErrors(<String>{'searchQuery'});
  controller._notifyChanged();

  try {
    controller._searchResults = await controller.repository.searchPlaces(
      query: query,
      flowType: controller.flowType,
      categoryIds: controller._selectedCategoryIds,
      categoryDetailCode: controller._selectedCategoryDetailCode,
    );
    controller._placePhase = AsyncPhase.success;
  } on CreateRepositoryException catch (error) {
    controller._searchResults = const <CreatePlaceSuggestion>[];
    controller._placePhase = error.type == CreateRepositoryFailureType.network
        ? AsyncPhase.networkError
        : AsyncPhase.serverError;
    controller._emitToast(
      error.type == CreateRepositoryFailureType.network
          ? '장소 검색에 실패했어요. 연결 상태를 확인한 뒤 다시 시도해 주세요.'
          : '장소 검색에 실패했어요. 잠시 후 다시 시도해 주세요.',
    );
  } catch (_) {
    controller._searchResults = const <CreatePlaceSuggestion>[];
    controller._placePhase = AsyncPhase.serverError;
    controller._emitToast('장소 검색에 실패했어요. 잠시 후 다시 시도해 주세요.');
  }

  controller._notifyChanged();
}
