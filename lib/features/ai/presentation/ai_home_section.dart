import 'package:flutter/material.dart';

import '../../../shared/localization/mateya_localizations.dart';
import '../../../shared/theme/app_tokens.dart';
import '../data/ai_repository.dart';
import '../domain/ai_models.dart';
import 'ai_widgets.dart';

class AiHomeSection extends StatefulWidget {
  const AiHomeSection({
    super.key,
    required this.repository,
    required this.onStartAi,
    required this.onPlaceTap,
  });

  final AiRepository repository;
  final VoidCallback onStartAi;
  final ValueChanged<String> onPlaceTap;

  @override
  State<AiHomeSection> createState() => _AiHomeSectionState();
}

class _AiHomeSectionState extends State<AiHomeSection> {
  late Future<List<AiHomeHighlight>> _highlights;

  @override
  void initState() {
    super.initState();
    _highlights = widget.repository.fetchHomeHighlights();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: AiColors.purple50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AiColors.purple200),
          ),
          child: Row(
            children: <Widget>[
              const AiRobotAvatar(size: 46),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'MateYa AI',
                      style: TextStyle(
                        color: AiColors.purple700,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.aiHomeHeadline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: widget.onStartAi,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AiColors.purple600,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  minimumSize: const Size(0, 28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                icon: const Icon(Icons.auto_awesome_rounded, size: 12),
                label: const Text(
                  '시작하기',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Text(
              context.l10n.aiHomeLocalTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.deepOrange,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          context.l10n.aiHomeLocalDescription,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 190,
          child: FutureBuilder<List<AiHomeHighlight>>(
            future: _highlights,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = snapshot.data ?? const <AiHomeHighlight>[];
              if (items.isEmpty) {
                return AiEvidenceNotice(text: context.l10n.aiHomeEmpty);
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, index) {
                  final item = items[index];
                  return _HomeHighlightCard(
                    item: item,
                    onTap: () => widget.onPlaceTap(item.placeId),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HomeHighlightCard extends StatelessWidget {
  const _HomeHighlightCard({required this.item, required this.onTap});

  final AiHomeHighlight item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 158,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 116,
                width: double.infinity,
                child: item.imageUrl == null
                    ? const ColoredBox(
                        color: AiColors.purple100,
                        child: Icon(
                          Icons.landscape_rounded,
                          color: AiColors.purple600,
                          size: 42,
                        ),
                      )
                    : Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const ColoredBox(
                          color: AiColors.purple100,
                          child: Icon(Icons.landscape_rounded),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 7, 8, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.anchorPlaceName}의 로컬 대안${item.distanceKm == null ? '' : ' · ${item.distanceKm!.toStringAsFixed(1)}km'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AiColors.purple800,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.reason,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
