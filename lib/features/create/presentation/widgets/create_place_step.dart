import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_text_field.dart';
import '../../../onboarding/domain/onboarding_flow.dart';
import '../../application/create_controller.dart';
import '../../domain/create_models.dart';
import 'create_form_fields.dart';
import 'create_place_widgets.dart';

class PlaceStepView extends StatelessWidget {
  const PlaceStepView({
    super.key,
    required this.controller,
    required this.searchController,
    required this.manualPlaceNameController,
    required this.manualPlaceAddressController,
    required this.hasSearched,
    required this.onCategorySelected,
    required this.onCategoryDetailSelected,
    required this.onSearchChanged,
    required this.onSearch,
  });

  final CreateController controller;
  final TextEditingController searchController;
  final TextEditingController manualPlaceNameController;
  final TextEditingController manualPlaceAddressController;
  final bool hasSearched;
  final Future<void> Function(String categoryId) onCategorySelected;
  final Future<void> Function(String? categoryDetailCode)
  onCategoryDetailSelected;
  final ValueChanged<String> onSearchChanged;
  final Future<void> Function() onSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedPlace = controller.selectedPlace;
    final showEmptyResult =
        hasSearched &&
        controller.placePhase == AsyncPhase.success &&
        controller.searchResults.isEmpty;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      children: <Widget>[
        Text(
          controller.flowType == CreateFlowType.group
              ? '진행할 장소를 찾아주세요'
              : '클래스 장소를 선택해 주세요',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          controller.flowType == CreateFlowType.group
              ? '검색 결과 또는 추천 목록에서 1곳을 선택하면 지도에 바로 표시됩니다.'
              : '클래스는 서비스 카테고리를 먼저 맞춘 뒤, 추천 장소를 고르거나 장소명과 주소를 직접 입력할 수 있습니다.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        if (controller.flowType ==
            CreateFlowType.classRegistration) ...<Widget>[
          Text('클래스 카테고리', style: theme.textTheme.titleLarge),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: controller.availableCategories
                .map(
                  (category) => SelectableChip(
                    label: category.label,
                    selected: controller.selectedCategoryIds.contains(
                      category.id,
                    ),
                    onTap: () => onCategorySelected(category.id),
                  ),
                )
                .toList(growable: false),
          ),
          if (controller.errorFor('categories') != null) ...<Widget>[
            const SizedBox(height: 12),
            InlineErrorText(text: controller.errorFor('categories')!),
          ],
          if (controller.availableCategoryDetails.isNotEmpty) ...<Widget>[
            const SizedBox(height: 20),
            Text('세부유형', style: theme.textTheme.titleLarge),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                SelectableChip(
                  label: '전체',
                  selected: controller.selectedCategoryDetailCode == null,
                  onTap: () => onCategoryDetailSelected(null),
                ),
                ...controller.availableCategoryDetails.map(
                  (detail) => SelectableChip(
                    label: detail.label,
                    selected:
                        controller.selectedCategoryDetailCode == detail.code,
                    onTap: () => onCategoryDetailSelected(detail.code),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          Text('직접 장소 입력', style: theme.textTheme.titleLarge),
          const SizedBox(height: 10),
          MateyaTextField(
            controller: manualPlaceNameController,
            hintText: '예: 성수 티 스튜디오',
            errorText: controller.errorFor('manualPlaceName'),
            onChanged: controller.updateManualPlaceName,
          ),
          const SizedBox(height: 12),
          MateyaTextField(
            controller: manualPlaceAddressController,
            hintText: '예: 서울 성동구 성수일로 32',
            errorText: controller.errorFor('manualPlaceAddress'),
            onChanged: controller.updateManualPlaceAddress,
          ),
          const SizedBox(height: 20),
          Text('또는 검색으로 선택', style: theme.textTheme.titleLarge),
          const SizedBox(height: 10),
        ],
        MateyaTextField(
          controller: searchController,
          hintText: '장소명으로 검색',
          errorText: controller.errorFor('searchQuery'),
          onChanged: onSearchChanged,
          onSubmitted: (_) => onSearch(),
          textInputAction: TextInputAction.search,
          suffixIcon: IconButton(
            onPressed: onSearch,
            icon: const Icon(Icons.search_rounded),
          ),
        ),
        if (selectedPlace != null) ...<Widget>[
          const SizedBox(height: 18),
          SelectedPlaceCard(place: selectedPlace),
        ] else if (controller.flowType == CreateFlowType.classRegistration &&
            controller.manualPlaceName.trim().isNotEmpty &&
            controller.manualPlaceAddress.trim().isNotEmpty) ...<Widget>[
          const SizedBox(height: 18),
          SelectedPlaceCard(
            place: CreatePlaceSuggestion(
              id: 'manual-preview',
              name: controller.manualPlaceName.trim(),
              address: controller.manualPlaceAddress.trim(),
              description: '직접 입력한 클래스 장소',
              distanceKm: 0,
            ),
          ),
        ],
        if (controller.errorFor('place') != null) ...<Widget>[
          const SizedBox(height: 12),
          InlineErrorText(text: controller.errorFor('place')!),
        ],
        const SizedBox(height: 20),
        PlaceMapCard(
          place: selectedPlace,
          isLoading: controller.placePhase == AsyncPhase.loading,
        ),
        const SizedBox(height: 24),
        Row(
          children: <Widget>[
            Expanded(
              child: Text('내 동네 기준 추천', style: theme.textTheme.titleLarge),
            ),
            TextButton(
              onPressed: controller.loadRecommendedPlaces,
              child: const Text('새로고침'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (controller.recommendedPlaces.isEmpty &&
            controller.placePhase == AsyncPhase.loading)
          const LoadingPlaceList()
        else if (controller.recommendedPlaces.isEmpty)
          const EmptyStateCard(
            icon: Icons.location_off_outlined,
            title: '추천 장소가 없어요',
            body: '카테고리를 바꾸거나 직접 검색해서 장소를 선택해 주세요.',
          )
        else
          ...controller.recommendedPlaces.map(
            (place) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PlaceTile(
                place: place,
                selected: selectedPlace?.id == place.id,
                onTap: () => controller.selectPlace(place),
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text('검색 결과', style: theme.textTheme.titleLarge),
        const SizedBox(height: 10),
        if (controller.placePhase == AsyncPhase.loading && hasSearched)
          const LoadingPlaceList()
        else if (showEmptyResult)
          const EmptyStateCard(
            icon: Icons.search_off_rounded,
            title: '검색 결과가 없어요',
            body: '다른 키워드로 다시 검색해 주세요.',
          )
        else if (hasSearched)
          ...controller.searchResults.map(
            (place) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PlaceTile(
                place: place,
                selected: selectedPlace?.id == place.id,
                onTap: () => controller.selectPlace(place),
              ),
            ),
          )
        else
          const EmptyStateCard(
            icon: Icons.travel_explore_rounded,
            title: '장소를 검색해 보세요',
            body: '`장소명` 기준 검색과 추천 목록 선택을 모두 지원하도록 프론트 흐름을 준비했습니다.',
          ),
      ],
    );
  }
}
