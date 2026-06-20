import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
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
    final l10n = context.l10n;
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
              ? l10n.createPlaceGroupTitle
              : l10n.createPlaceClassTitle,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          controller.flowType == CreateFlowType.group
              ? l10n.createPlaceGroupDescription
              : l10n.createPlaceClassDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        if (controller.flowType ==
            CreateFlowType.classRegistration) ...<Widget>[
          Text(l10n.createClassCategoryTitle, style: theme.textTheme.titleLarge),
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
            Text(l10n.createCategoryDetailTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                SelectableChip(
                  label: l10n.commonAll,
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
          Text(l10n.createManualPlaceTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 10),
          MateyaTextField(
            controller: manualPlaceNameController,
            hintText: l10n.createManualPlaceNameHint,
            errorText: controller.errorFor('manualPlaceName'),
            onChanged: controller.updateManualPlaceName,
          ),
          const SizedBox(height: 12),
          MateyaTextField(
            controller: manualPlaceAddressController,
            hintText: l10n.createManualPlaceAddressHint,
            errorText: controller.errorFor('manualPlaceAddress'),
            onChanged: controller.updateManualPlaceAddress,
          ),
          const SizedBox(height: 20),
          Text(l10n.createOrSearchTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 10),
        ],
        MateyaTextField(
          controller: searchController,
          hintText: l10n.createPlaceSearchHint,
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
              description: l10n.createManualPlacePreviewDescription,
              distanceKm: 0,
            ),
          ),
        ],
        if (controller.errorFor('place') != null) ...<Widget>[
          const SizedBox(height: 12),
          InlineErrorText(text: controller.errorFor('place')!),
        ],
        const SizedBox(height: 24),
        Text(l10n.createSearchResultsTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 10),
        if (controller.placePhase == AsyncPhase.loading && hasSearched)
          const LoadingPlaceList()
        else if (showEmptyResult)
          EmptyStateCard(
            icon: Icons.search_off_rounded,
            title: l10n.createSearchEmptyTitle,
            body: l10n.createSearchEmptyBody,
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
          EmptyStateCard(
            icon: Icons.travel_explore_rounded,
            title: l10n.createSearchInitialTitle,
            body: l10n.createSearchInitialBody,
          ),
        const SizedBox(height: 20),
        PlaceMapCard(
          place: selectedPlace,
          isLoading: controller.placePhase == AsyncPhase.loading,
        ),
        const SizedBox(height: 24),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                l10n.createRecommendedTitle,
                style: theme.textTheme.titleLarge,
              ),
            ),
            TextButton(
              onPressed: controller.loadRecommendedPlaces,
              child: Text(l10n.createRefresh),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (controller.recommendedPlaces.isEmpty &&
            controller.placePhase == AsyncPhase.loading)
          const LoadingPlaceList()
        else if (controller.recommendedPlaces.isEmpty)
          EmptyStateCard(
            icon: Icons.location_off_outlined,
            title: l10n.createRecommendedEmptyTitle,
            body: l10n.createRecommendedEmptyBody,
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
      ],
    );
  }
}
