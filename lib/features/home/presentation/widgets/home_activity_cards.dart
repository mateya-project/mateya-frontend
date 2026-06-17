import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../domain/home_models.dart';
import 'home_activity_primitives.dart';
import 'home_formatters.dart';

class FeaturedActivityCard extends StatelessWidget {
  const FeaturedActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
  });

  final ActivityItem activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ActivityImage(
                imageUrl: activity.imageUrl,
                height: 338,
                borderRadius: const BorderRadius.all(Radius.circular(14)),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: CategoryBadge(
                  label: activity.categoryLabel,
                  filled: true,
                ),
              ),
              const Positioned(
                right: 16,
                top: 16,
                child: Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      activity.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.place,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${formatShortDate(activity.startAt)} ${formatTimeRange(activity.startAt, activity.endAt)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      formatPrice(activity.price),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RatingLabel(rating: activity.rating),
                  const SizedBox(height: 70),
                  ParticipantLabel(
                    current: activity.participantCount,
                    capacity: activity.participantCapacity,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VerticalActivityCard extends StatelessWidget {
  const VerticalActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
  });

  final ActivityItem activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 2,
              offset: Offset(0, 0),
            ),
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ActivityImage(
                  imageUrl: activity.imageUrl,
                  height: 239,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(13),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: CategoryBadge(
                    label: activity.categoryLabel,
                    filled: true,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 9, 13, 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          activity.title,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontSize: 18, height: 1.35),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 4,
                          children: <Widget>[
                            Text(
                              formatMonthDay(activity.startAt),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textMuted),
                            ),
                            const DotDivider(),
                            Text(
                              formatTimeRange(activity.startAt, activity.endAt),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textMuted),
                            ),
                            Text(
                              formatPrice(activity.price),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      RatingLabel(rating: activity.rating),
                      const SizedBox(height: 22),
                      ParticipantLabel(
                        current: activity.participantCount,
                        capacity: activity.participantCapacity,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompactActivityRow extends StatelessWidget {
  const CompactActivityRow({
    super.key,
    required this.activity,
    required this.onTap,
  });

  final ActivityItem activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ActivityImage(
                imageUrl: activity.imageUrl,
                width: 110,
                height: 110,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              Positioned(
                left: 8,
                bottom: 8,
                child: CategoryBadge(
                  label: activity.price == 0 ? 'FREE' : activity.categoryLabel,
                  filled: true,
                  small: true,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          activity.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(width: 8),
                      RatingLabel(rating: activity.rating, compact: true),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity.place,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: <Widget>[
                      Text(
                        formatRelativeDate(activity.startAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const DotDivider(),
                      Text(
                        formatTimeRange(activity.startAt, activity.endAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: <Widget>[
                      ParticipantLabel(
                        current: activity.participantCount,
                        capacity: activity.participantCapacity,
                        compact: true,
                      ),
                      const Spacer(),
                      CategoryBadge(
                        label: activity.categoryLabel,
                        compactOutline: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
