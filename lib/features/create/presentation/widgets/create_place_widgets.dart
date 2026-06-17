import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../domain/create_models.dart';

class PlaceTile extends StatelessWidget {
  const PlaceTile({
    super.key,
    required this.place,
    required this.selected,
    required this.onTap,
  });

  final CreatePlaceSuggestion place;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.softGreenBorder : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.brandGreen : AppColors.divider,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.brandGreen
                    : AppColors.subtleBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.place_rounded,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(place.name, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(
                    place.address,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    place.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '${place.distanceKm}km',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? AppColors.brandGreen
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected
                      ? AppColors.brandGreen
                      : AppColors.fieldBorderLight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SelectedPlaceCard extends StatelessWidget {
  const SelectedPlaceCard({super.key, required this.place});

  final CreatePlaceSuggestion place;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softGreenBorder,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.check_circle_rounded, color: AppColors.brandGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(place.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  place.address,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceMapCard extends StatelessWidget {
  const PlaceMapCard({super.key, required this.place, required this.isLoading});

  final CreatePlaceSuggestion? place;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final target = place != null && place!.hasCoordinates
        ? NLatLng(place!.latitude!, place!.longitude!)
        : const NLatLng(37.5665, 126.9780);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 280,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            NaverMap(
              key: ValueKey<String>(
                place == null
                    ? 'empty-create-map'
                    : '${place!.id}-${place!.latitude}-${place!.longitude}',
              ),
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: target,
                  zoom: 15,
                ),
              ),
              onMapReady: (mapController) async {
                if (place != null && place!.hasCoordinates) {
                  await mapController.addOverlay(
                    NMarker(id: 'selected-place', position: target),
                  );
                }
              },
            ),
            if (place == null)
              Container(
                color: Colors.white.withValues(alpha: 0.8),
                alignment: Alignment.center,
                child: const Text('장소를 선택하면 이 영역에 위치가 표시됩니다.'),
              ),
            if (isLoading)
              Container(
                color: Colors.white.withValues(alpha: 0.72),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

class LoadingPlaceList extends StatelessWidget {
  const LoadingPlaceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
        3,
        (index) => Container(
          margin: EdgeInsets.only(bottom: index == 2 ? 0 : 12),
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.subtleBackground,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.subtleBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, size: 34, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
