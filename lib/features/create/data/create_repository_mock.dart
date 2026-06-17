part of 'create_repository.dart';

class MockCreateRepository implements CreateRepository {
  @override
  Future<List<CreatePlaceSuggestion>> fetchRecommendedPlaces({
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
    String? categoryDetailCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    final candidates =
        _placeSuggestions
            .where((place) {
              if (flowType == CreateFlowType.classRegistration) {
                return true;
              }
              if (categoryIds.isEmpty) {
                return true;
              }
              return place.categoryIds.any(categoryIds.contains);
            })
            .toList()
            .where(
              (place) =>
                  categoryDetailCode == null ||
                  place.categoryDetailCode == categoryDetailCode,
            )
            .toList()
          ..sort((left, right) => left.distanceKm.compareTo(right.distanceKm));
    return candidates.take(3).toList(growable: false);
  }

  @override
  Future<List<CreatePlaceSuggestion>> searchPlaces({
    required String query,
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
    String? categoryDetailCode,
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
        return categoryDetailCode == null ||
            place.categoryDetailCode == categoryDetailCode;
      }
      return place.categoryIds.any(categoryIds.contains) &&
          (categoryDetailCode == null ||
              place.categoryDetailCode == categoryDetailCode);
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
