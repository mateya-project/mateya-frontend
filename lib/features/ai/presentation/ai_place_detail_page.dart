import 'package:flutter/material.dart';

import '../../../shared/localization/mateya_localizations.dart';
import '../../../shared/theme/app_tokens.dart';
import '../../../shared/widgets/mateya_header.dart';
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
        toolbarHeight: 68,
        centerTitle: true,
        title: const _MateyaWordmark(),
        leading: const BackButton(),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AiRobotAvatar(size: 28),
                SizedBox(width: 6),
                MateyaLanguageButton(),
              ],
            ),
          ),
        ],
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            place.name,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 23,
                                ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AiColors.purple50,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.smart_toy_outlined,
                                size: 12,
                                color: AiColors.purple700,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'MateYa AI 추천',
                                style: TextStyle(
                                  color: AiColors.purple700,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
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
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: <Widget>[
                        _MetadataLabel(
                          icon: Icons.location_on_outlined,
                          label: place.address,
                        ),
                        if ((place.categoryDetailName ?? place.category)
                            .isNotEmpty)
                          _MetadataLabel(
                            icon: Icons.account_balance_outlined,
                            label: place.categoryDetailName ?? place.category,
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AiColors.purple50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const AiRobotAvatar(size: 40),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${place.name}과 비슷한 로컬 경험',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
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
                          const SizedBox(height: 12),
                          const Wrap(
                            spacing: 8,
                            children: <Widget>[
                              Chip(
                                avatar: Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 15,
                                  color: AiColors.purple700,
                                ),
                                label: Text('비슷한 경험'),
                              ),
                              Chip(
                                avatar: Icon(
                                  Icons.hub_outlined,
                                  size: 15,
                                  color: AiColors.purple700,
                                ),
                                label: Text('지역 분산'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.bar_chart_rounded,
                            color: AiColors.purple700,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.l10n.aiEvidenceNotice,
                              style: const TextStyle(fontSize: 12, height: 1.4),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.divider),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            onTap: () => onActivityTap(activity.id),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            leading: const CircleAvatar(
                              backgroundColor: AiColors.purple100,
                              child: Icon(Icons.groups_rounded),
                            ),
                            title: Text(activity.title),
                            subtitle: Text(activity.placeName),
                            trailing: const Icon(Icons.chevron_right_rounded),
                          ),
                        ),
                    const SizedBox(height: 4),
                    OutlinedButton.icon(
                      onPressed: onAskAi,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.brandGreen,
                        side: const BorderSide(
                          color: AppColors.softGreenBorder,
                        ),
                        minimumSize: const Size(double.infinity, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const AiRobotAvatar(size: 24),
                      label: const Text('다른 날짜와 장소를 AI에게 물어보기'),
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
          child: Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: onCreateActivity,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.brandGreen,
                    side: const BorderSide(color: AppColors.brandGreen),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(context.l10n.aiCreateAtPlace),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: activities.isEmpty
                      ? onAskAi
                      : () => onActivityTap(activities.first.id),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brandGreen,
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(activities.isEmpty ? 'AI에게 물어보기' : '모임 참여하기'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MateyaWordmark extends StatelessWidget {
  const _MateyaWordmark();

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: 'Mate',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'Ya',
            style: TextStyle(color: AppColors.brandGreen),
          ),
        ],
      ),
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
    );
  }
}

class _MetadataLabel extends StatelessWidget {
  const _MetadataLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}
