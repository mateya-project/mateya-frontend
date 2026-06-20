import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/logging/naver_map_diagnostics.dart';
import '../../../../shared/theme/app_responsive.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_skeleton.dart';
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
    final thumbnailUrl = place.previewImageUrl;

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
            _PlaceThumbnail(
              imageUrl: thumbnailUrl,
              selected: selected,
              size: 72,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    place.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    place.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    place.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
    final thumbnailUrl = place.previewImageUrl;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softGreenBorder,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _PlaceThumbnail(imageUrl: thumbnailUrl, selected: true, size: 56),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  place.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  place.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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

class _PlaceThumbnail extends StatelessWidget {
  const _PlaceThumbnail({
    required this.imageUrl,
    required this.selected,
    required this.size,
  });

  final String? imageUrl;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: selected ? AppColors.brandGreen : AppColors.subtleBackground,
          borderRadius: borderRadius,
        ),
        child: Icon(
          Icons.place_rounded,
          color: selected ? Colors.white : AppColors.textSecondary,
          size: size * 0.42,
        ),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: size,
        height: size,
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: selected
                  ? AppColors.brandGreen
                  : AppColors.subtleBackground,
              alignment: Alignment.center,
              child: Icon(
                Icons.place_rounded,
                color: selected ? Colors.white : AppColors.textSecondary,
                size: size * 0.42,
              ),
            );
          },
        ),
      ),
    );
  }
}

class PlaceMapCard extends StatefulWidget {
  const PlaceMapCard({super.key, required this.place, required this.isLoading});

  final CreatePlaceSuggestion? place;
  final bool isLoading;

  @override
  State<PlaceMapCard> createState() => _PlaceMapCardState();
}

class _PlaceMapCardState extends State<PlaceMapCard> {
  static const String _markerId = 'selected-place';

  late final NaverMapDiagnostics _diagnostics;

  @override
  void initState() {
    super.initState();
    _diagnostics = NaverMapDiagnostics(scope: 'create-place-map');
    _diagnostics.mounted(
      context: <String, Object?>{
        'placeId': widget.place?.id,
        'hasCoordinates': widget.place?.hasCoordinates ?? false,
      },
    );
  }

  @override
  void didUpdateWidget(covariant PlaceMapCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.place != widget.place ||
        oldWidget.isLoading != widget.isLoading) {
      _diagnostics.inputUpdated(
        context: <String, Object?>{
          'placeId': widget.place?.id,
          'hasCoordinates': widget.place?.hasCoordinates ?? false,
          'isLoading': widget.isLoading,
        },
      );
    }
  }

  @override
  void dispose() {
    _diagnostics.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final target = place != null && place.hasCoordinates
        ? NLatLng(place.latitude!, place.longitude!)
        : const NLatLng(37.5665, 126.9780);
    final mapHeight = AppResponsive.clampedHeight(
      context,
      ideal: 280,
      min: 192,
      max: 280,
      regularScale: 1,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: mapHeight,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            NaverMap(
              key: ValueKey<String>(
                place == null
                    ? 'empty-create-map'
                    : '${place.id}-${place.latitude}-${place.longitude}',
              ),
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: target,
                  zoom: 15,
                ),
              ),
              onMapLoaded: () {
                _diagnostics.mapLoaded(
                  context: <String, Object?>{
                    'placeId': place?.id,
                    'hasCoordinates': place?.hasCoordinates ?? false,
                  },
                );
              },
              onMapReady: (mapController) async {
                _diagnostics.mapReady(
                  context: <String, Object?>{
                    'placeId': place?.id,
                    'hasCoordinates': place?.hasCoordinates ?? false,
                    'latitude': target.latitude,
                    'longitude': target.longitude,
                  },
                );
                try {
                  if (place != null && place.hasCoordinates) {
                    await mapController.addOverlay(
                      NMarker(id: _markerId, position: target),
                    );
                    _diagnostics.syncSucceeded(
                      'selected-place',
                      context: <String, Object?>{
                        'markerCount': 1,
                        'placeId': place.id,
                      },
                    );
                    return;
                  }
                  _diagnostics.syncSkipped(
                    'selected-place',
                    context: const <String, Object?>{
                      'reason': 'place-without-coordinates',
                    },
                  );
                } catch (error, stackTrace) {
                  _diagnostics.syncFailed(
                    'selected-place',
                    error: error,
                    stackTrace: stackTrace,
                    context: <String, Object?>{'placeId': place?.id},
                  );
                }
              },
            ),
            if (place == null)
              Container(
                color: Colors.white.withValues(alpha: 0.8),
                alignment: Alignment.center,
                child: Text(context.l10n.createMapPlaceholder),
              ),
            if (widget.isLoading)
              const Positioned.fill(child: MateyaMapSkeleton()),
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
    return MateyaSkeleton(
      child: Column(
        children: List<Widget>.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: index == 2 ? 0 : 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  MateyaSkeletonBlock(width: 72, height: 72, radius: 16),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MateyaSkeletonBlock(height: 22, width: 152, radius: 11),
                        SizedBox(height: 8),
                        MateyaSkeletonBlock(height: 16, width: 214, radius: 8),
                        SizedBox(height: 8),
                        MateyaSkeletonBlock(height: 14, width: 188, radius: 7),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  MateyaSkeletonBlock(width: 36, height: 14, radius: 7),
                ],
              ),
            ),
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
