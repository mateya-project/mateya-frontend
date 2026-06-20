import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../../../../shared/activity_categories/activity_category_repository.dart';
import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_skeleton.dart';
import '../../../../shared/widgets/mateya_text_field.dart';
import '../../../create/presentation/widgets/create_form_fields.dart'
    show SelectableChip;
import '../../../onboarding/domain/onboarding_flow.dart';
import '../../application/nearby_culture_map_controller.dart';
import '../../domain/nearby_culture_map_models.dart';
import '../widgets/home_feedback_states.dart' as home_feedback;
import '../widgets/nearby_culture_map_widgets.dart';

class NearbyCultureMapPage extends StatefulWidget {
  const NearbyCultureMapPage({super.key, required this.controller});

  final NearbyCultureMapController controller;

  @override
  State<NearbyCultureMapPage> createState() => _NearbyCultureMapPageState();
}

class _NearbyCultureMapPageState extends State<NearbyCultureMapPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.controller.keyword);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        _syncSearchController();
        final controller = widget.controller;
        if (controller.phase == AsyncPhase.loading && !controller.hasData) {
          return const _NearbyCultureMapSkeleton();
        }
        if ((controller.phase == AsyncPhase.networkError ||
                controller.phase == AsyncPhase.serverError) &&
            !controller.hasData) {
          return home_feedback.RetryState(
            message:
                controller.errorMessage ?? context.l10n.homeNearbyMapLoadError,
            onRetry: controller.search,
          );
        }

        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: _NearbyCultureMapStage(
                currentLocation: controller.currentLocation,
                places: controller.places,
                selectedPlaceId: controller.selectedPlace?.id,
                isLoading: controller.phase == AsyncPhase.loading,
                onMarkerTap: controller.selectPlace,
                onRecenterTap: controller.refreshCurrentLocation,
                onListButtonTap: _openPlaceListSheet,
              ),
            ),
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: _NearbyCultureMapOverlayControls(
                searchController: _searchController,
                currentLocationLabel:
                    controller.currentLocation?.displayName ??
                    context.l10n.homeNearbyMapCurrentLocationLabel,
                categories: controller.categories,
                selectedCategoryCode: controller.selectedCategoryCode,
                onSearchChanged: controller.updateKeyword,
                onSearch: controller.search,
                onCategorySelected: controller.selectCategory,
                errorMessage: controller.errorMessage,
                showError:
                    controller.errorMessage != null &&
                    controller.phase != AsyncPhase.loading,
              ),
            ),
          ],
        );
      },
    );
  }

  void _syncSearchController() {
    if (_searchController.text == widget.controller.keyword) {
      return;
    }
    _searchController.value = TextEditingValue(
      text: widget.controller.keyword,
      selection: TextSelection.collapsed(
        offset: widget.controller.keyword.length,
      ),
    );
  }

  Future<void> _openPlaceListSheet() async {
    final places = widget.controller.places;
    if (places.isEmpty) {
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return NearbyCultureMapPlaceListSheet(
          places: places,
          selectedPlaceId: widget.controller.selectedPlace?.id,
          onPlaceTap: (placeId) {
            widget.controller.selectPlace(placeId);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _NearbyCultureMapOverlayControls extends StatelessWidget {
  const _NearbyCultureMapOverlayControls({
    required this.searchController,
    required this.currentLocationLabel,
    required this.categories,
    required this.selectedCategoryCode,
    required this.onSearchChanged,
    required this.onSearch,
    required this.onCategorySelected,
    required this.errorMessage,
    required this.showError,
  });

  final TextEditingController searchController;
  final String currentLocationLabel;
  final List<ActivityCategoryMetadata> categories;
  final String selectedCategoryCode;
  final ValueChanged<String> onSearchChanged;
  final Future<void> Function() onSearch;
  final Future<void> Function(String categoryCode) onCategorySelected;
  final String? errorMessage;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MateyaTextField(
          controller: searchController,
          hintText: context.l10n.homeNearbyMapSearchHint,
          onChanged: onSearchChanged,
          onSubmitted: (_) => onSearch(),
          textInputAction: TextInputAction.search,
          suffixIcon: IconButton(
            onPressed: onSearch,
            icon: const Icon(Icons.search_rounded),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categories[index];
              return SelectableChip(
                label: category.label,
                selected: selectedCategoryCode == category.code,
                onTap: () => onCategorySelected(category.code),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Flexible(
              child: _OverlayBadge(
                icon: Icons.near_me_rounded,
                label: currentLocationLabel,
              ),
            ),
            if (showError && errorMessage != null) ...<Widget>[
              const SizedBox(width: 8),
              Expanded(child: _OverlayErrorBadge(message: errorMessage!)),
            ],
          ],
        ),
      ],
    );
  }
}

class _OverlayBadge extends StatelessWidget {
  const _OverlayBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.divider),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: AppColors.textPrimary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverlayErrorBadge extends StatelessWidget {
  const _OverlayErrorBadge({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x33D92D20)),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.warning_amber_rounded,
            size: 16,
            color: AppColors.error,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyCultureMapStage extends StatelessWidget {
  const _NearbyCultureMapStage({
    required this.currentLocation,
    required this.places,
    required this.selectedPlaceId,
    required this.isLoading,
    required this.onMarkerTap,
    required this.onRecenterTap,
    required this.onListButtonTap,
  });

  final NeighborhoodSelection? currentLocation;
  final List<NearbyCultureMapPlace> places;
  final String? selectedPlaceId;
  final bool isLoading;
  final ValueChanged<String> onMarkerTap;
  final Future<void> Function() onRecenterTap;
  final VoidCallback onListButtonTap;

  @override
  Widget build(BuildContext context) {
    const carouselBottomInset = 20.0;
    final buttonBottomInset = places.isEmpty ? 188.0 : 146.0;
    final mapUiBottomInset = places.isEmpty ? 112.0 : 84.0;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: _NearbyCultureMapCanvas(
            currentLocation: currentLocation,
            places: places,
            selectedPlaceId: selectedPlaceId,
            isLoading: isLoading,
            onMarkerTap: onMarkerTap,
            onRecenterTap: onRecenterTap,
            recenterBottomInset: buttonBottomInset,
            mapUiBottomInset: mapUiBottomInset,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: carouselBottomInset,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: NearbyCultureMapPlaceCarousel(
              places: places,
              selectedPlaceId: selectedPlaceId,
              onPlaceChanged: onMarkerTap,
              onListButtonTap: onListButtonTap,
            ),
          ),
        ),
      ],
    );
  }
}

class _NearbyCultureMapCanvas extends StatefulWidget {
  const _NearbyCultureMapCanvas({
    required this.currentLocation,
    required this.places,
    required this.selectedPlaceId,
    required this.isLoading,
    required this.onMarkerTap,
    required this.onRecenterTap,
    required this.recenterBottomInset,
    required this.mapUiBottomInset,
  });

  final NeighborhoodSelection? currentLocation;
  final List<NearbyCultureMapPlace> places;
  final String? selectedPlaceId;
  final bool isLoading;
  final ValueChanged<String> onMarkerTap;
  final Future<void> Function() onRecenterTap;
  final double recenterBottomInset;
  final double mapUiBottomInset;

  @override
  State<_NearbyCultureMapCanvas> createState() =>
      _NearbyCultureMapCanvasState();
}

class _NearbyCultureMapCanvasState extends State<_NearbyCultureMapCanvas> {
  NaverMapController? _mapController;
  bool _isMapReady = false;

  @override
  void didUpdateWidget(covariant _NearbyCultureMapCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_currentLocationKey(oldWidget.currentLocation) !=
        _currentLocationKey(widget.currentLocation)) {
      _mapController = null;
      _isMapReady = false;
    }
    _syncMap();
  }

  @override
  Widget build(BuildContext context) {
    final target = _targetLocation();
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          NaverMap(
            key: ValueKey<String>(_currentLocationKey(widget.currentLocation)),
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(target: target, zoom: 13),
              scaleBarEnable: false,
              contentPadding: EdgeInsets.only(bottom: widget.mapUiBottomInset),
            ),
            onMapReady: (mapController) async {
              _mapController = mapController;
              if (mounted && !_isMapReady) {
                setState(() {
                  _isMapReady = true;
                });
              }
              await _syncMap();
            },
          ),
          Positioned(
            right: 16,
            bottom: widget.recenterBottomInset,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: widget.onRecenterTap,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.my_location_rounded,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          if (widget.isLoading || !_isMapReady)
            const Positioned.fill(child: MateyaMapSkeleton()),
        ],
      ),
    );
  }

  String _currentLocationKey(NeighborhoodSelection? selection) {
    if (selection == null) {
      return 'nearby-culture-map-empty';
    }
    return '${selection.displayName}-${selection.latitude}-${selection.longitude}';
  }

  NLatLng _targetLocation() {
    final selected = widget.places.where((place) {
      return place.id == widget.selectedPlaceId && place.hasCoordinates;
    }).firstOrNull;
    if (selected != null) {
      return NLatLng(selected.latitude!, selected.longitude!);
    }
    final currentLocation = widget.currentLocation;
    if (currentLocation != null) {
      return NLatLng(currentLocation.latitude, currentLocation.longitude);
    }
    return const NLatLng(37.5665, 126.9780);
  }

  Future<void> _syncMap() async {
    final mapController = _mapController;
    if (mapController == null) {
      return;
    }

    await mapController.clearOverlays(type: NOverlayType.marker);
    final markers = <NMarker>{};
    for (final place in widget.places.where((place) => place.hasCoordinates)) {
      final marker = NMarker(
        id: place.id,
        position: NLatLng(place.latitude!, place.longitude!),
        caption: place.id == widget.selectedPlaceId
            ? NOverlayCaption(text: place.name)
            : null,
        iconTintColor: place.id == widget.selectedPlaceId
            ? AppColors.brandGreen
            : AppColors.brandGreenLight,
      )..setOnTapListener((_) => widget.onMarkerTap(place.id));
      markers.add(marker);
    }
    if (markers.isNotEmpty) {
      await mapController.addOverlayAll(markers);
    }
    await mapController.updateCamera(
      NCameraUpdate.scrollAndZoomTo(target: _targetLocation(), zoom: 13),
    );
  }
}

class _NearbyCultureMapSkeleton extends StatelessWidget {
  const _NearbyCultureMapSkeleton();

  @override
  Widget build(BuildContext context) {
    return MateyaSkeleton(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            MateyaSkeletonBlock(height: 52, radius: 18),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                MateyaSkeletonBlock(height: 44, width: 92, radius: 22),
                SizedBox(width: 8),
                MateyaSkeletonBlock(height: 44, width: 110, radius: 22),
              ],
            ),
            SizedBox(height: 10),
            MateyaSkeletonBlock(height: 36, width: 144, radius: 18),
            SizedBox(height: 16),
            Expanded(child: MateyaMapSkeleton()),
            SizedBox(height: 16),
            MateyaSkeletonBlock(height: 34, width: 108, radius: 17),
            SizedBox(height: 12),
            MateyaSkeletonBlock(height: 126, radius: 24),
          ],
        ),
      ),
    );
  }
}
