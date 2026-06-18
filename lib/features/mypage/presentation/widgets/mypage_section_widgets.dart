import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../domain/mypage_models.dart';
import 'mypage_activity_widgets.dart';

class MyPageProfileHeroCard extends StatelessWidget {
  const MyPageProfileHeroCard({
    super.key,
    required this.profile,
    required this.subtitle,
    this.avatarAction,
    this.trailing,
  });

  final ProfileSummary profile;
  final String subtitle;
  final Widget? avatarAction;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return MyPageSectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              MyPageAvatarImage(imageUrl: profile.profileImageUrl, size: 72),
              if (avatarAction != null)
                Positioned(right: -4, bottom: -4, child: avatarAction!),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: profile.isActiveWithin30Days
                            ? AppColors.softGreenBorder
                            : AppColors.subtleBackground,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        profile.isActiveWithin30Days ? '30일 내 접속' : '최근 접속 없음',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: profile.isActiveWithin30Days
                              ? AppColors.brandGreen
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.residence,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (profile.oneLineIntroduction != null &&
                    profile.oneLineIntroduction!.trim().isNotEmpty) ...<Widget>[
                  const SizedBox(height: 10),
                  Text(
                    profile.oneLineIntroduction!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: 12),
            Flexible(child: trailing!),
          ],
        ],
      ),
    );
  }
}

class MyPageMetricSection extends StatelessWidget {
  const MyPageMetricSection({super.key, required this.metrics});

  final List<ProfileMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return MyPageStatsCard(items: metrics);
  }
}

class MyPageActionSection extends StatelessWidget {
  const MyPageActionSection({super.key, required this.items});

  final List<MyPageActionItem> items;

  @override
  Widget build(BuildContext context) {
    return MyPageSectionCard(
      child: Column(
        children: <Widget>[
          for (var index = 0; index < items.length; index += 1) ...<Widget>[
            MyPageActionTile(item: items[index]),
            if (index != items.length - 1) const Divider(height: 24),
          ],
        ],
      ),
    );
  }
}

class MyPageBadgeSection extends StatelessWidget {
  const MyPageBadgeSection({super.key, required this.badges});

  final List<ActivityBadge> badges;

  @override
  Widget build(BuildContext context) {
    return MyPageSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('뱃지', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: badges
                .map(
                  (badge) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.softGreenBorder,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          badge.label,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.brandGreen,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          badge.categoryLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class MyPageRecentActivityPreviewSection extends StatelessWidget {
  const MyPageRecentActivityPreviewSection({
    super.key,
    required this.activities,
    required this.onViewAll,
    this.onActivityTap,
    this.showButton = true,
  });

  final List<ActivityHistoryEntry> activities;
  final VoidCallback onViewAll;
  final ValueChanged<ActivityHistoryEntry>? onActivityTap;
  final bool showButton;

  @override
  Widget build(BuildContext context) {
    return MyPageSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '활동 이력',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (showButton)
                TextButton(onPressed: onViewAll, child: const Text('전체보기')),
            ],
          ),
          const SizedBox(height: 12),
          for (
            var index = 0;
            index < activities.length;
            index += 1
          ) ...<Widget>[
            MyPageActivityHistoryCard(
              activity: activities[index],
              onTap: activities[index].isHostedByMe && onActivityTap != null
                  ? () => onActivityTap!(activities[index])
                  : null,
            ),
            if (index != activities.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class MyPageStatsCard extends StatelessWidget {
  const MyPageStatsCard({super.key, required this.items});

  final List<ProfileMetric> items;

  @override
  Widget build(BuildContext context) {
    return MyPageSectionCard(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: items
            .map(
              (metric) => SizedBox(
                width: (MediaQuery.sizeOf(context).width - 72) / 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.subtleBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        metric.label,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        metric.value,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
