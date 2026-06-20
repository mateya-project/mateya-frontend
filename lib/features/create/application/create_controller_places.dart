part of 'create_controller.dart';

Future<void> _loadRecommendedPlacesFor(CreateController controller) async {
  final l10n = MateyaLocalizations.current;
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
          ? l10n.createRecommendedLoadFailedNetwork
          : l10n.createRecommendedLoadFailedServer,
    );
  } catch (_) {
    controller._recommendedPlaces = const <CreatePlaceSuggestion>[];
    controller._placePhase = AsyncPhase.serverError;
    controller._emitToast(l10n.createRecommendedLoadFailedServer);
  }

  controller._notifyChanged();
}

Future<void> _searchPlacesFor(CreateController controller) async {
  final l10n = MateyaLocalizations.current;
  final query = controller._searchQuery.trim();
  if (query.isEmpty) {
    controller._fieldErrors = <String, String?>{
      ...controller._fieldErrors,
      'searchQuery': l10n.createPlaceSearchQueryRequired,
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
          ? l10n.createPlaceSearchFailedNetwork
          : l10n.createPlaceSearchFailedServer,
    );
  } catch (_) {
    controller._searchResults = const <CreatePlaceSuggestion>[];
    controller._placePhase = AsyncPhase.serverError;
    controller._emitToast(l10n.createPlaceSearchFailedServer);
  }

  controller._notifyChanged();
}
