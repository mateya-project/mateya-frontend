import 'package:flutter/material.dart';

import '../../../shared/localization/mateya_localizations.dart';
import '../../../shared/theme/app_tokens.dart';
import '../data/ai_repository.dart';
import '../domain/ai_models.dart';
import 'ai_widgets.dart';

class AiPlaceDetailPage extends StatefulWidget {
  const AiPlaceDetailPage({
    super.key,
    required this.repository,
    required this.placeId,
    required this.onAskAi,
    required this.onCreateActivity,
    required this.onActivityTap,
  });

  final AiRepository repository;
  final String placeId;
  final ValueChanged<AiPlaceDetail> onAskAi;
  final ValueChanged<AiPlaceDetail> onCreateActivity;
  final ValueChanged<String> onActivityTap;

  @override
  State<AiPlaceDetailPage> createState() => _AiPlaceDetailPageState();
}

class _AiPlaceDetailPageState extends State<AiPlaceDetailPage> {
  late Future<(AiPlaceDetail, List<AiPlaceActivity>)> _data;
  bool? _favoriteOverride;

  @override
  void initState() {
    super.initState();
    _data = _load();
  }

  Future<(AiPlaceDetail, List<AiPlaceActivity>)> _load() async {
    final results = await Future.wait<Object>(<Future<Object>>[
      widget.repository.fetchPlace(widget.placeId),
      widget.repository.fetchPlaceActivities(widget.placeId),
    ]);
    return (results[0] as AiPlaceDetail, results[1] as List<AiPlaceActivity>);
  }

  Future<void> _toggleFavorite(AiPlaceDetail place) async {
    final previous = _favoriteOverride ?? place.favorited;
    setState(() => _favoriteOverride = !previous);
    try {
      final favorite = await widget.repository.togglePlaceFavorite(place.id);
      if (mounted) {
        setState(() => _favoriteOverride = favorite);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _favoriteOverride = previous);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.aiFavoriteFailed)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(context.l10n.aiPlaceDetailTitle),
      ),
      body: FutureBuilder<(AiPlaceDetail, List<AiPlaceActivity>)>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(
              child: AiPrimaryButton(
                label: context.l10n.commonRetry,
                expanded: false,
                onPressed: () => setState(() => _data = _load()),
              ),
            );
          }
          final (place, activities) = snapshot.data!;
          return _PlaceDetailContent(
            place: place,
            activities: activities,
            onAskAi: () => widget.onAskAi(place),
            onCreateActivity: () => widget.onCreateActivity(place),
            onActivityTap: widget.onActivityTap,
            favorited: _favoriteOverride ?? place.favorited,
            onFavorite: () => _toggleFavorite(place),
          );
        },
      ),
    );
  }
}

class _PlaceDetailContent extends StatelessWidget {
  const _PlaceDetailContent({
    required this.place,
    required this.activities,
    required this.onAskAi,
    required this.onCreateActivity,
    required this.onActivityTap,
    required this.favorited,
    required this.onFavorite,
  });

  final AiPlaceDetail place;
  final List<AiPlaceActivity> activities;
  final VoidCallback onAskAi;
  final VoidCallback onCreateActivity;
  final ValueChanged<String> onActivityTap;
  final bool favorited;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: <Widget>[
              SizedBox(
                height: 250,
                child: place.previewImageUrl == null
                    ? const ColoredBox(
                        color: AiColors.purple100,
                        child: Icon(
                          Icons.landscape_rounded,
                          size: 72,
                          color: AiColors.purple600,
                        ),
                      )
                    : Image.network(
                        place.previewImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const ColoredBox(
                          color: AiColors.purple100,
                          child: Icon(Icons.landscape_rounded, size: 72),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      place.categoryDetailName ?? place.category,
                      style: const TextStyle(
                        color: AiColors.purple800,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            place.name,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                        Semantics(
                          button: true,
                          toggled: favorited,
                          label: favorited
                              ? context.l10n.aiFavoriteRemove
                              : context.l10n.aiFavoriteAdd,
                          child: IconButton(
                            onPressed: onFavorite,
                            icon: Icon(
                              favorited
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: favorited
                                  ? AppColors.error
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Icon(Icons.place_outlined, size: 18),
                        const SizedBox(width: 6),
                        Expanded(child: Text(place.address)),
                      ],
                    ),
                    if (place.description.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 18),
                      Text(
                        place.description,
                        style: const TextStyle(height: 1.6),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AiColors.purple50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AiColors.purple200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const AiRobotAvatar(size: 40),
                              const SizedBox(width: 10),
                              Text(
                                context.l10n.aiRecommendationPoint,
                                style: const TextStyle(
                                  color: AiColors.purple800,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            context.l10n.aiPlaceLocalReason(
                              place.regionSigungu ?? place.regionSido ?? '-',
                            ),
                            style: const TextStyle(height: 1.5),
                          ),
                          const SizedBox(height: 14),
                          AiPrimaryButton(
                            label: context.l10n.aiAskAboutPlace,
                            onPressed: onAskAi,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AiEvidenceNotice(text: context.l10n.aiEvidenceNotice),
                    const SizedBox(height: 28),
                    Text(
                      context.l10n.aiPlaceActivities,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (activities.isEmpty)
                      Text(
                        context.l10n.aiNoActivities,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      )
                    else
                      for (final activity in activities)
                        ListTile(
                          onTap: () => onActivityTap(activity.id),
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            backgroundColor: AiColors.purple100,
                            child: Icon(Icons.groups_rounded),
                          ),
                          title: Text(activity.title),
                          subtitle: Text(activity.placeName),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.divider)),
          ),
          child: AiPrimaryButton(
            label: activities.isEmpty
                ? context.l10n.aiCreateAtPlace
                : context.l10n.aiCreateNewActivity,
            icon: Icons.group_add_outlined,
            onPressed: onCreateActivity,
          ),
        ),
      ],
    );
  }
}
