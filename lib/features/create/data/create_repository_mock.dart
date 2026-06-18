part of 'create_repository.dart';

class MockCreateRepository implements CreateRepository {
  @override
  Future<CreateEditableDraft> fetchEditableDraft({
    required String id,
    required CreateFlowType flowType,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    final place = _placeSuggestions.first;
    return CreateEditableDraft(
      activityId: id,
      flowType: flowType,
      categoryIds: place.categoryIds,
      categoryDetailCode: place.categoryDetailCode,
      place: place,
      title: flowType == CreateFlowType.group
          ? '수정 중인 북촌 산책 모임'
          : '수정 중인 전통 다도 클래스',
      description: '기존 등록 내용을 불러온 mock 수정 초안입니다.',
      eventDate: DateTime.now().add(const Duration(days: 7)),
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 16, minute: 0),
      participantCapacity: 6,
      registrationDeadlineDate: DateTime.now().add(const Duration(days: 6)),
      registrationDeadlineTime: const TimeOfDay(hour: 18, minute: 0),
      languageCodes: const <String>{'ko', 'en'},
      priceType: CreatePriceType.paid,
      priceText: '15000',
      audienceIds: const <String>{'everyone', 'foreigner'},
      images: const <CreateImageAsset>[
        CreateImageAsset(
          id: 'remote-0',
          path:
              'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?auto=format&fit=crop&w=1200&q=80',
          name: 'mateya-edit-sample.jpg',
          sizeBytes: 0,
          isPrimary: true,
        ),
      ],
    );
  }

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
  Future<CreateSubmitResult> submit(
    CreateSubmissionDraft draft, {
    String? editingId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 720));
    return CreateSubmitResult(
      id: editingId ?? 'created-${DateTime.now().microsecondsSinceEpoch}',
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
