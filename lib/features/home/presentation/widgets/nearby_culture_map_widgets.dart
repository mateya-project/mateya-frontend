import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../create/presentation/widgets/create_place_widgets.dart'
    show EmptyStateCard;
import '../../domain/nearby_culture_map_models.dart';

class NearbyCultureMapPlaceCarousel extends StatefulWidget {
  const NearbyCultureMapPlaceCarousel({
    super.key,
    required this.places,
    required this.selectedPlaceId,
    required this.onPlaceChanged,
    required this.onListButtonTap,
  });

  final List<NearbyCultureMapPlace> places;
  final String? selectedPlaceId;
  final ValueChanged<String> onPlaceChanged;
  final VoidCallback onListButtonTap;

  @override
  State<NearbyCultureMapPlaceCarousel> createState() =>
      _NearbyCultureMapPlaceCarouselState();
}

class _NearbyCultureMapPlaceCarouselState
    extends State<NearbyCultureMapPlaceCarousel> {
  late final PageController _pageController;
  int _lastSyncedIndex = 0;

  @override
  void initState() {
    super.initState();
    _lastSyncedIndex = _selectedIndex();
    _pageController = PageController(
      initialPage: _lastSyncedIndex,
      viewportFraction: 0.96,
    );
  }

  @override
  void didUpdateWidget(covariant NearbyCultureMapPlaceCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextIndex = _selectedIndex();
    if (nextIndex == _lastSyncedIndex ||
        !mounted ||
        !_pageController.hasClients) {
      _lastSyncedIndex = nextIndex;
      return;
    }
    _lastSyncedIndex = nextIndex;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.places.isEmpty) {
      return EmptyStateCard(
        icon: Icons.map_outlined,
        title: context.l10n.homeNearbyMapEmptyTitle,
        body: context.l10n.homeNearbyMapEmptyBody,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _NearbyCultureMapListButton(onTap: widget.onListButtonTap),
        const SizedBox(height: 12),
        SizedBox(
          height: 144,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.places.length,
            onPageChanged: (index) {
              _lastSyncedIndex = index;
              widget.onPlaceChanged(widget.places[index].id);
            },
            itemBuilder: (context, index) {
              final place = widget.places[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: NearbyCultureMapPlaceCard(place: place),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Text(
                          '${index + 1} / ${widget.places.length}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  int _selectedIndex() {
    final selectedId = widget.selectedPlaceId;
    if (selectedId == null) {
      return 0;
    }
    final index = widget.places.indexWhere((place) => place.id == selectedId);
    return index < 0 ? 0 : index;
  }
}

class NearbyCultureMapPlaceCard extends StatelessWidget {
  const NearbyCultureMapPlaceCard({super.key, required this.place});

  final NearbyCultureMapPlace place;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NearbyCultureMapThumbnail(imageUrl: place.previewImageUrl),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  place.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  place.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softGreenBorder,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          place.badgeLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.brandGreen,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${place.distanceKm.toStringAsFixed(1)}km',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NearbyCultureMapThumbnail extends StatelessWidget {
  const NearbyCultureMapThumbnail({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    const size = 76.0;
    final borderRadius = BorderRadius.circular(18);
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.softGreenBorder,
          borderRadius: borderRadius,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.temple_buddhist_rounded,
          color: AppColors.brandGreen,
          size: 32,
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
              color: AppColors.softGreenBorder,
              alignment: Alignment.center,
              child: const Icon(
                Icons.temple_buddhist_rounded,
                color: AppColors.brandGreen,
                size: 32,
              ),
            );
          },
        ),
      ),
    );
  }
}

class NearbyCultureMapPlaceListSheet extends StatelessWidget {
  const NearbyCultureMapPlaceListSheet({
    super.key,
    required this.places,
    required this.selectedPlaceId,
    required this.onPlaceTap,
  });

  final List<NearbyCultureMapPlace> places;
  final String? selectedPlaceId;
  final ValueChanged<String> onPlaceTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20 + MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.disabledButton,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Text(
                  context.l10n.homeNearbyMapListTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Text(
                  context.l10n.homeNearbyMapPlaceCount(places.length),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: places.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final place = places[index];
                  final selected = place.id == selectedPlaceId;
                  return Material(
                    color: selected
                        ? AppColors.softGreenBorder
                        : AppColors.subtleBackground,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => onPlaceTap(place.id),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: <Widget>[
                            NearbyCultureMapThumbnail(
                              imageUrl: place.previewImageUrl,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    place.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    place.address,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${place.distanceKm.toStringAsFixed(1)}km',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: selected
                                        ? AppColors.brandGreen
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NearbyCultureMapListButton extends StatelessWidget {
  const _NearbyCultureMapListButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.list_rounded,
                size: 18,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 6),
              Text(
                context.l10n.homeNearbyMapListButton,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
