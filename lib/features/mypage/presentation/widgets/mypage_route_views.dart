import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../../shared/widgets/mateya_text_field.dart';
import '../../domain/mypage_models.dart';
import 'mypage_activity_widgets.dart';
import 'mypage_badge_catalog.dart';
import 'mypage_section_widgets.dart';

class PersonalMyPageView extends StatelessWidget {
  const PersonalMyPageView({
    super.key,
    required this.data,
    required this.isUpdatingProfileImage,
    this.onBack,
    required this.onOpenRecentActivities,
    required this.onEditHostedActivity,
    required this.onEditProfileImage,
    required this.onOpenSettings,
  });

  final PersonalMyPageData data;
  final bool isUpdatingProfileImage;
  final VoidCallback? onBack;
  final VoidCallback onOpenRecentActivities;
  final ValueChanged<ActivityHistoryEntry> onEditHostedActivity;
  final VoidCallback onEditProfileImage;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        onBack == null
            ? const MateyaHeader.noBackArrow()
            : MateyaHeader.backArrow(onBack: onBack),
        Expanded(
          child: ListView(
            key: const PageStorageKey<String>('mypage-personal-home-scroll'),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: <Widget>[
              _CenteredProfileCard(
                profile: data.profile,
                topRightAction: _CardCornerActionButton(
                  icon: Icons.settings_outlined,
                  onTap: onOpenSettings,
                ),
                avatarAction: _AvatarActionButton(
                  icon: isUpdatingProfileImage
                      ? Icons.hourglass_top_rounded
                      : Icons.photo_camera_outlined,
                  onTap: isUpdatingProfileImage ? null : onEditProfileImage,
                ),
              ),
              const SizedBox(height: 16),
              _ProfileMetricStrip(metrics: data.metrics),
              const SizedBox(height: 16),
              _BadgeGridSection(badges: data.badges),
              const SizedBox(height: 32),
              _RecentActivityListSection(
                activities: data.recentActivities,
                onViewAll: onOpenRecentActivities,
                onActivityTap: onEditHostedActivity,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OtherProfileView extends StatelessWidget {
  const OtherProfileView({
    super.key,
    required this.data,
    required this.isBusy,
    required this.onBack,
    required this.onFriendTap,
    required this.onBlockTap,
  });

  final OtherProfileData data;
  final bool isBusy;
  final VoidCallback onBack;
  final VoidCallback onFriendTap;
  final VoidCallback onBlockTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: onBack),
        Expanded(
          child: ListView(
            key: const PageStorageKey<String>('mypage-other-profile-scroll'),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: <Widget>[
              _CenteredProfileCard(
                profile: data.profile,
                avatarAction: !data.isFriend && !data.isBlocked
                    ? _AvatarActionButton(
                        icon: Icons.add_rounded,
                        onTap: isBusy ? null : onFriendTap,
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              _ProfileMetricStrip(metrics: data.metrics),
              const SizedBox(height: 16),
              _BadgeGridSection.otherProfile(badges: data.badges),
              const SizedBox(height: 16),
              _RecentActivityListSection(
                activities: data.recentActivities,
                onViewAll: () {},
                onActivityTap: (_) {},
                showButton: false,
              ),
              const SizedBox(height: 32),
              if (!data.isBlocked)
                MateyaButton(
                  label: isBusy
                      ? l10n.commonProcessing
                      : data.isFriend
                      ? l10n.mypageRemoveFriend
                      : l10n.mypageBlockUser,
                  enabled: !isBusy,
                  onPressed: data.isFriend ? onFriendTap : onBlockTap,
                )
              else
                Center(
                  child: TextButton(
                    onPressed: data.isBlocked ? null : onBlockTap,
                    child: Text(
                      data.isBlocked
                          ? l10n.mypageBlocked
                          : l10n.mypageBlockUser,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textMuted,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({
    super.key,
    required this.profile,
    required this.onBack,
    required this.onReport,
    required this.onEditPrimaryPreferences,
    required this.onEditActivityRegion,
    required this.onOpenConsentHistory,
    required this.onOpenPrivacyPolicy,
    required this.onOpenCustomerSupport,
    required this.onOpenBlockedUsers,
    required this.onLogout,
    required this.onWithdrawal,
  });

  final ProfileSummary profile;
  final VoidCallback onBack;
  final VoidCallback onReport;
  final VoidCallback onEditPrimaryPreferences;
  final VoidCallback onEditActivityRegion;
  final VoidCallback onOpenConsentHistory;
  final VoidCallback onOpenPrivacyPolicy;
  final VoidCallback onOpenCustomerSupport;
  final VoidCallback onOpenBlockedUsers;
  final VoidCallback onLogout;
  final VoidCallback onWithdrawal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: onBack, onReportTap: onReport),
        Expanded(
          child: CustomScrollView(
            key: const PageStorageKey<String>('mypage-settings-scroll'),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: _SettingsTitleBar(title: l10n.mypageTitle),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(height: 1, color: AppColors.divider),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Row(
                    children: <Widget>[
                      MyPageAvatarImage(
                        imageUrl: profile.profileImageUrl,
                        size: 56,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              profile.displayName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.residenceDisplay,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 18)),
              SliverToBoxAdapter(
                child: _SettingsMenuItem(
                  title: l10n.mypageEditPrimaryPreferences,
                  onTap: onEditPrimaryPreferences,
                ),
              ),
              SliverToBoxAdapter(
                child: _SettingsMenuItem(
                  title: l10n.mypageEditActivityRegion,
                  onTap: onEditActivityRegion,
                ),
              ),
              SliverToBoxAdapter(
                child: _SettingsMenuItem(
                  title: l10n.mypageConsentHistoryTitle,
                  onTap: onOpenConsentHistory,
                ),
              ),
              SliverToBoxAdapter(
                child: _SettingsMenuItem(
                  title: l10n.mypageOpenPrivacyPolicy,
                  onTap: onOpenPrivacyPolicy,
                ),
              ),
              SliverToBoxAdapter(
                child: _SettingsMenuItem(
                  title: l10n.mypageOpenCustomerSupport,
                  onTap: onOpenCustomerSupport,
                ),
              ),
              SliverToBoxAdapter(
                child: _SettingsMenuItem(
                  title: l10n.mypageOpenBlockedUsers,
                  onTap: onOpenBlockedUsers,
                ),
              ),
              SliverToBoxAdapter(
                child: _SettingsMenuItem(
                  title: l10n.mypageLogout,
                  onTap: onLogout,
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: onWithdrawal,
                      child: Text(
                        l10n.mypageOpenWithdrawal,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.textMuted,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ConsentHistoryView extends StatelessWidget {
  const ConsentHistoryView({
    super.key,
    required this.entries,
    required this.onBack,
    required this.onOpenDetail,
  });

  final List<ConsentHistoryEntry> entries;
  final VoidCallback onBack;
  final ValueChanged<ConsentHistoryEntry> onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: onBack),
        Expanded(
          child: ListView(
            key: const PageStorageKey<String>('mypage-consent-history-scroll'),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
            children: <Widget>[
              Text(
                l10n.mypageConsentHistoryTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                l10n.mypageConsentHistoryDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              if (entries.isEmpty)
                MyPageSectionCard(
                  child: Text(
                    l10n.mypageConsentHistoryEmpty,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              else
                for (final entry in entries) ...<Widget>[
                  MyPageSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          entry.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: l10n.mypageConsentVersion,
                          value: entry.versionLabel,
                        ),
                        const SizedBox(height: 8),
                        _DetailRow(
                          label: l10n.mypageConsentStatus,
                          value: entry.agreed
                              ? l10n.mypageConsentAgreed
                              : l10n.mypageConsentDeclined,
                        ),
                        const SizedBox(height: 8),
                        _DetailRow(
                          label: l10n.mypageConsentDate,
                          value: entry.agreedAtLabel,
                        ),
                        const SizedBox(height: 14),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => onOpenDetail(entry),
                            child: Text(l10n.commonSeeDetails),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
            ],
          ),
        ),
      ],
    );
  }
}

class BlockedUsersView extends StatelessWidget {
  const BlockedUsersView({
    super.key,
    required this.users,
    required this.onBack,
    required this.onUnblock,
  });

  final List<BlockedUserSummary> users;
  final VoidCallback onBack;
  final ValueChanged<String> onUnblock;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: onBack),
        Expanded(
          child: ListView(
            key: const PageStorageKey<String>('mypage-blocked-users-scroll'),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
            children: <Widget>[
              Text(
                l10n.mypageBlockedUsersTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              if (users.isEmpty)
                MyPageSectionCard(
                  child: Text(
                    l10n.mypageBlockedUsersEmpty,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              else
                for (final user in users) ...<Widget>[
                  MyPageSectionCard(
                    child: Row(
                      children: <Widget>[
                        MyPageAvatarImage(
                          imageUrl: user.profileImageUrl,
                          size: 48,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                user.displayName,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.residenceDisplay,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () => onUnblock(user.id),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            textStyle: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          child: Text(l10n.mypageUnblockAction),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
            ],
          ),
        ),
      ],
    );
  }
}

class RecentActivitiesView extends StatelessWidget {
  const RecentActivitiesView({
    super.key,
    required this.data,
    required this.onBack,
    required this.onEditHostedActivity,
  });

  final RecentActivityData data;
  final VoidCallback onBack;
  final ValueChanged<ActivityHistoryEntry> onEditHostedActivity;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: onBack),
        Expanded(
          child: ListView(
            key: const PageStorageKey<String>(
              'mypage-recent-activities-scroll',
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: <Widget>[
              Text(
                l10n.mypageRecentActivitiesTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.mypageRecentActivitiesDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              _RecentActivitySummaryCard(
                totalCount: data.stats.totalCount,
                hostedCount: data.stats.hostedCount,
                joinedCount: data.stats.joinedCount,
                reviewCount: data.stats.reviewCount,
              ),
              const SizedBox(height: 16),
              for (final activity in data.activities) ...<Widget>[
                MyPageActivityHistoryCard(
                  activity: activity,
                  onTap: activity.isHostedByMe
                      ? () => onEditHostedActivity(activity)
                      : null,
                ),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentActivitySummaryCard extends StatelessWidget {
  const _RecentActivitySummaryCard({
    required this.totalCount,
    required this.hostedCount,
    required this.joinedCount,
    required this.reviewCount,
  });

  final int totalCount;
  final int hostedCount;
  final int joinedCount;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return MyPageSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.mypageActivitySummaryTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: <Widget>[
              Expanded(
                child: _RecentActivityMetric(
                  label: l10n.commonAll,
                  value: '$totalCount',
                  highlight: true,
                ),
              ),
              Expanded(
                child: _RecentActivityMetric(
                  label: l10n.mypageHostedCount,
                  value: '$hostedCount',
                ),
              ),
              Expanded(
                child: _RecentActivityMetric(
                  label: l10n.mypageJoinedCount,
                  value: '$joinedCount',
                ),
              ),
              Expanded(
                child: _RecentActivityMetric(
                  label: l10n.mypageReviewCount,
                  value: '$reviewCount',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentActivityMetric extends StatelessWidget {
  const _RecentActivityMetric({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: highlight ? AppColors.brandGreen : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _CenteredProfileCard extends StatelessWidget {
  const _CenteredProfileCard({
    required this.profile,
    this.avatarAction,
    this.topRightAction,
  });

  final ProfileSummary profile;
  final Widget? avatarAction;
  final Widget? topRightAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MyPageSectionCard(
      child: Stack(
        children: <Widget>[
          if (topRightAction != null)
            Positioned(right: 0, top: 0, child: topRightAction!),
          SizedBox(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    MyPageAvatarImage(
                      imageUrl: profile.profileImageUrl,
                      size: 96,
                    ),
                    if (avatarAction != null)
                      Positioned(right: -4, bottom: -4, child: avatarAction!),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  profile.displayName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  profile.residenceDisplay,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.softGreenBorder,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    profile.isActiveWithin30Days
                        ? l10n.mypageActiveMember
                        : l10n.mypageInactiveMember,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.brandGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.subtleBackground,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    profile.primaryLanguageLabel,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMetricStrip extends StatelessWidget {
  const _ProfileMetricStrip({required this.metrics});

  final List<ProfileMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return MyPageSectionCard(
      child: Row(
        children: metrics
            .map(
              (metric) => Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      metric.value,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: AppColors.brandGreen),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      metric.label,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _BadgeGridSection extends StatelessWidget {
  const _BadgeGridSection({required this.badges})
    : titleMode = _BadgeGridTitleMode.mine;

  const _BadgeGridSection.otherProfile({required this.badges})
    : titleMode = _BadgeGridTitleMode.otherProfile;

  final List<ActivityBadge> badges;
  final _BadgeGridTitleMode titleMode;
  static const double _badgeSpacing = 8;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final badgeSlots = buildMyPageBadgeSlots(badges);
    final earnedBadgeCount = badgeSlots.where((slot) => slot.isEarned).length;
    final shouldShowCatalogSlots = titleMode == _BadgeGridTitleMode.mine;
    final visibleSlots = shouldShowCatalogSlots
        ? badgeSlots
        : badgeSlots.where((slot) => slot.isEarned).toList(growable: false);
    final title = switch (titleMode) {
      _BadgeGridTitleMode.mine => l10n.mypageBadgesTitle,
      _BadgeGridTitleMode.otherProfile => l10n.mypageOtherBadgesTitle,
    };
    final description = switch (titleMode) {
      _BadgeGridTitleMode.mine => l10n.mypageBadgesDescription,
      _BadgeGridTitleMode.otherProfile => l10n.mypageOtherBadgesDescription,
    };
    final countLabel = shouldShowCatalogSlots
        ? '$earnedBadgeCount/$kMyPageBadgeCatalogCount'
        : '$earnedBadgeCount';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Text(
              countLabel,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: AppColors.brandGreen),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        if (visibleSlots.isEmpty)
          Text(
            l10n.mypageOtherBadgesEmpty,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          )
        else
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final badgeWidth =
                  (constraints.maxWidth - (_badgeSpacing * 2)) / 3;

              return Wrap(
                spacing: _badgeSpacing,
                runSpacing: 10,
                children: visibleSlots
                    .map(
                      (badgeSlot) => SizedBox(
                        width: badgeWidth,
                        child: _BadgeGridTile(slot: badgeSlot),
                      ),
                    )
                    .toList(growable: false),
              );
            },
          ),
      ],
    );
  }
}

enum _BadgeGridTitleMode { mine, otherProfile }

class _BadgeGridTile extends StatelessWidget {
  const _BadgeGridTile({required this.slot});

  final MyPageBadgeDisplaySlot slot;
  static const double _badgeAspectRatio = 118 / 140;
  static const double _badgeRadius = 20;

  @override
  Widget build(BuildContext context) {
    final badgeChild = Image.asset(
      slot.visual.assetPathFor(slot.isEarned),
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      excludeFromSemantics: true,
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) =>
              _BadgeGridTileFallback(slot: slot),
    );
    final badgeImage = AspectRatio(
      aspectRatio: _badgeAspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_badgeRadius),
        child: badgeChild,
      ),
    );

    return Semantics(label: slot.visual.localizedLabel, child: badgeImage);
  }
}

class _BadgeGridTileFallback extends StatelessWidget {
  const _BadgeGridTileFallback({required this.slot});

  final MyPageBadgeDisplaySlot slot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_BadgeGridTile._badgeRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.workspace_premium_outlined,
              color: slot.isEarned
                  ? AppColors.brandGreen
                  : AppColors.textSecondary,
              size: 28,
            ),
            const SizedBox(height: 10),
            Text(
              slot.visual.localizedLabel,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: slot.isEarned
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivityListSection extends StatelessWidget {
  const _RecentActivityListSection({
    required this.activities,
    required this.onViewAll,
    required this.onActivityTap,
    this.showButton = true,
  });

  final List<ActivityHistoryEntry> activities;
  final VoidCallback onViewAll;
  final ValueChanged<ActivityHistoryEntry> onActivityTap;
  final bool showButton;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                l10n.mypageRecentActivitiesSectionTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            if (showButton)
              TextButton(onPressed: onViewAll, child: Text(l10n.commonSeeAll)),
          ],
        ),
        const SizedBox(height: 10),
        for (var index = 0; index < activities.length; index += 1) ...<Widget>[
          _RecentActivityRow(
            activity: activities[index],
            onTap: activities[index].isHostedByMe
                ? () => onActivityTap(activities[index])
                : null,
          ),
          if (index != activities.length - 1) const Divider(height: 28),
        ],
      ],
    );
  }
}

class _RecentActivityRow extends StatelessWidget {
  const _RecentActivityRow({required this.activity, this.onTap});

  final ActivityHistoryEntry activity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 102,
              height: 102,
              child: Image.network(
                activity.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.subtleBackground,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_outlined),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: SizedBox(
              height: 102,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    activity.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    activity.dateLabel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    activity.timeLabel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: <Widget>[
                      Text(
                        activity.priceLabel,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      if (activity.rating != null) ...<Widget>[
                        const Icon(Icons.star_rounded, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          activity.rating!.toStringAsFixed(2),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
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

class _AvatarActionButton extends StatelessWidget {
  const _AvatarActionButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: SizedBox(
        width: 36,
        height: 36,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Ink(
            decoration: const BoxDecoration(
              color: AppColors.brandGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}

class _CardCornerActionButton extends StatelessWidget {
  const _CardCornerActionButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 36,
        height: 36,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
    );
  }
}

class _SettingsTitleBar extends StatelessWidget {
  const _SettingsTitleBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}

class _SettingsMenuItem extends StatelessWidget {
  const _SettingsMenuItem({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          margin: const EdgeInsets.only(bottom: 12),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 74,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}

class PrimaryPreferencesView extends StatelessWidget {
  const PrimaryPreferencesView({
    super.key,
    required this.currentLanguageCode,
    required this.currentCountryCode,
    required this.languageOptions,
    required this.countryOptions,
    required this.englishNameController,
    required this.isSaving,
    required this.errorText,
    required this.onBack,
    required this.onLanguageChanged,
    required this.onCountryChanged,
    required this.onSave,
  });

  final String? currentLanguageCode;
  final String? currentCountryCode;
  final List<SelectionOption> languageOptions;
  final List<SelectionOption> countryOptions;
  final TextEditingController englishNameController;
  final bool isSaving;
  final String? errorText;
  final VoidCallback onBack;
  final ValueChanged<String?> onLanguageChanged;
  final ValueChanged<String?> onCountryChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: onBack),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.mypagePrimaryPreferencesTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.mypagePrimaryPreferencesDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                MyPageSelectionField(
                  label: l10n.mypageMyLanguage,
                  value: currentLanguageCode,
                  items: languageOptions,
                  onChanged: onLanguageChanged,
                ),
                const SizedBox(height: 16),
                MyPageSelectionField(
                  label: l10n.mypageMyCountry,
                  value: currentCountryCode,
                  items: countryOptions,
                  onChanged: onCountryChanged,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.mypageEnglishNameOptional,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                MateyaTextField(
                  controller: englishNameController,
                  hintText: 'Bak Minjeong',
                  textInputAction: TextInputAction.done,
                ),
                if (errorText != null) ...<Widget>[
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          errorText!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ],
                const Spacer(),
                MateyaButton(
                  label: isSaving
                      ? l10n.mypageSaving
                      : l10n.mypagePrimaryPreferencesSubmit,
                  enabled: !isSaving,
                  onPressed: onSave,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BusinessMyPageView extends StatelessWidget {
  const BusinessMyPageView({
    super.key,
    required this.data,
    required this.introductionController,
    required this.isSaving,
    required this.isUpdatingProfileImage,
    required this.isUpdatingActivityRegion,
    required this.errorText,
    required this.onEditActivity,
    required this.onEditProfileImage,
    required this.onEditActivityRegion,
    required this.onSave,
  });

  final BusinessMyPageData data;
  final TextEditingController introductionController;
  final bool isSaving;
  final bool isUpdatingProfileImage;
  final bool isUpdatingActivityRegion;
  final String? errorText;
  final ValueChanged<ActivityHistoryEntry> onEditActivity;
  final VoidCallback onEditProfileImage;
  final VoidCallback onEditActivityRegion;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: <Widget>[
        const MateyaHeader.noBackArrow(),
        Expanded(
          child: ListView(
            key: const PageStorageKey<String>('mypage-business-home-scroll'),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: <Widget>[
              MyPageProfileHeroCard(
                profile: data.profile,
                subtitle:
                    data.profile.placeLabel ?? data.profile.residenceDisplay,
                avatarAction: _AvatarActionButton(
                  icon: isUpdatingProfileImage
                      ? Icons.hourglass_top_rounded
                      : Icons.photo_camera_outlined,
                  onTap: isUpdatingProfileImage ? null : onEditProfileImage,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: isUpdatingActivityRegion
                      ? null
                      : onEditActivityRegion,
                  icon: Icon(
                    Icons.my_location_rounded,
                    color: isUpdatingActivityRegion
                        ? AppColors.textSecondary
                        : AppColors.brandGreen,
                  ),
                  label: Text(
                    isUpdatingActivityRegion
                        ? l10n.mypageUpdating
                        : l10n.mypageEditActivityRegion,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isUpdatingActivityRegion
                          ? AppColors.textSecondary
                          : AppColors.brandGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              MyPageStatsCard(items: data.metrics),
              const SizedBox(height: 16),
              MyPageSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.mypageBusinessIntroTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.mypageBusinessIntroDescription,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    MateyaTextField(
                      controller: introductionController,
                      hintText: l10n.mypageBusinessIntroHint,
                      maxLength: 500,
                      maxLines: 5,
                      minLines: 5,
                      errorText: errorText,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${introductionController.text.length}/500',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 16),
                    MateyaButton(
                      label: isSaving
                          ? l10n.mypageSaving
                          : l10n.mypageSaveIntroduction,
                      enabled: !isSaving,
                      onPressed: onSave,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              MyPageSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.mypageActiveExperiencesTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    for (final activity in data.activeExperiences) ...<Widget>[
                      MyPageActivityHistoryCard(
                        activity: activity,
                        onTap: () => onEditActivity(activity),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
