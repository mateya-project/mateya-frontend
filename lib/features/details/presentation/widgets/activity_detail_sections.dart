import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../application/activity_detail_controller.dart';
import '../../domain/activity_detail_models.dart';
import 'activity_detail_formatters.dart';
import 'activity_detail_primitives.dart';
import 'activity_detail_review_widgets.dart';

class DetailHeroSection extends StatelessWidget {
  const DetailHeroSection({
    super.key,
    required this.detail,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  final ActivityDetail detail;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 324,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: detail.imageUrls.length,
                  onPageChanged: onPageChanged,
                  itemBuilder: (context, index) {
                    return NetworkOrFileImage(
                      imageUrl: detail.imageUrls[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(0x12000000),
                          Color(0x00000000),
                          Color(0x26000000),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: IgnorePointer(
                  child: CategoryPill(
                    label: detail.activity.categoryLabel,
                    filled: true,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 14,
                child: IgnorePointer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                      detail.imageUrls.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: EdgeInsets.only(
                          right: index == detail.imageUrls.length - 1 ? 0 : 6,
                        ),
                        width: currentPage == index ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({
    super.key,
    required this.detail,
    required this.controller,
    required this.onOpenReviews,
    required this.onOpenParticipantRequests,
    required this.onHelpfulTap,
    required this.onOpenOtherProfile,
    required this.onEditReview,
    required this.onDeleteReview,
  });

  final ActivityDetail detail;
  final ActivityDetailController controller;
  final VoidCallback onOpenReviews;
  final VoidCallback onOpenParticipantRequests;
  final Future<void> Function(String reviewId)? onHelpfulTap;
  final Future<void> Function(String userId) onOpenOtherProfile;
  final Future<void> Function(ActivityReview review) onEditReview;
  final Future<void> Function(ActivityReview review) onDeleteReview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final remaining =
        detail.activity.participantCapacity - detail.activity.participantCount;
    final summary = controller.reviewSummary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 132),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            detail.activity.title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 20),
          InfoLine(
            icon: Icons.calendar_today_rounded,
            text: formatLongDate(detail.activity.startAt),
          ),
          const SizedBox(height: 10),
          InfoLine(
            icon: Icons.schedule_rounded,
            text: formatTimeRange(
              detail.activity.startAt,
              detail.activity.endAt,
            ),
          ),
          const SizedBox(height: 10),
          InfoLine(
            icon: Icons.star_rounded,
            text: l10n.detailsReviewSummary(
              summary.averageRating.toStringAsFixed(2),
              summary.totalCount,
            ),
          ),
          const SizedBox(height: 10),
          InfoLine(
            icon: Icons.groups_2_outlined,
            text: l10n.detailsParticipantSummary(
              detail.activity.participantCount,
              detail.activity.participantCapacity,
            ),
          ),
          const SizedBox(height: 10),
          InfoLine(icon: Icons.place_outlined, text: detail.locationLabel),
          const SizedBox(height: 28),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      l10n.detailsParticipantsJoined(
                        detail.activity.participantCount,
                      ),
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 18),
                    ),
                    const Spacer(),
                    Text(
                      remaining > 0
                          ? l10n.detailsParticipantsRemaining(remaining)
                          : l10n.detailsRecruitmentClosed,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: remaining > 0
                            ? AppColors.brandGreen
                            : AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                      child: InkWell(
                        onTap: onOpenParticipantRequests,
                        borderRadius: BorderRadius.circular(999),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            size: 22,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: detail.activity.participantCapacity == 0
                        ? 0
                        : detail.activity.participantCount /
                              detail.activity.participantCapacity,
                    minHeight: 10,
                    backgroundColor: AppColors.subtleBackground,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.brandGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ParticipantAvatarRow(
                  participants: detail.participants,
                  onParticipantTap: onOpenOtherProfile,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionCard(
            child: InkWell(
              onTap: () => onOpenOtherProfile(detail.host.userId),
              borderRadius: BorderRadius.circular(18),
              child: Row(
                children: <Widget>[
                  AvatarCircle(
                    imageUrl: detail.host.avatarUrl,
                    size: 54,
                    initials: 'H',
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          detail.host.displayName,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          detail.host.locationLabel,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SectionHeader(title: l10n.detailsIntroduction),
          const SizedBox(height: 10),
          Text(
            detail.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: <Widget>[
              Expanded(
                child: SectionHeader(
                  title: l10n.detailsReviewsTitle(summary.totalCount),
                  compact: true,
                ),
              ),
              TextButton(
                onPressed: onOpenReviews,
                child: Text(l10n.commonSeeAll),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (controller.previewReviews.isEmpty)
            SectionCard(
              child: Text(
                l10n.detailsReviewsEmpty,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else
            for (
              var index = 0;
              index < controller.previewReviews.length;
              index += 1
            ) ...<Widget>[
              ReviewCard(
                review: controller.previewReviews[index],
                onAuthorTap: () {
                  unawaited(
                    onOpenOtherProfile(
                      controller.previewReviews[index].authorUserId,
                    ),
                  );
                },
                onHelpfulTap: () {
                  onHelpfulTap?.call(controller.previewReviews[index].id);
                },
                onTranslationTap:
                    controller.previewReviews[index].supportsTranslation
                    ? () {
                        unawaited(
                          controller.toggleTranslation(
                            controller.previewReviews[index].id,
                          ),
                        );
                      }
                    : null,
                onEditTap:
                    controller.canManageReview(controller.previewReviews[index])
                    ? () {
                        unawaited(
                          onEditReview(controller.previewReviews[index]),
                        );
                      }
                    : null,
                onDeleteTap:
                    controller.canManageReview(controller.previewReviews[index])
                    ? () {
                        unawaited(
                          onDeleteReview(controller.previewReviews[index]),
                        );
                      }
                    : null,
              ),
              if (index != controller.previewReviews.length - 1)
                const SizedBox(height: 16),
            ],
        ],
      ),
    );
  }
}

class DetailBottomBar extends StatelessWidget {
  const DetailBottomBar({
    super.key,
    required this.detail,
    required this.onFavoriteTap,
    required this.onJoinTap,
    this.isJoinActionInFlight = false,
  });

  final ActivityDetail detail;
  final Future<void> Function() onFavoriteTap;
  final Future<void> Function() onJoinTap;
  final bool isJoinActionInFlight;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      l10n.detailsPriceLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatPrice(detail.activity.price),
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
              BottomGlyphButton(
                icon: detail.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                onTap: () {
                  onFavoriteTap();
                },
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 146,
                child: MateyaButton(
                  label: isJoinActionInFlight
                      ? l10n.detailsJoinRequesting
                      : detail.participationState.ctaLabel,
                  onPressed: () {
                    onJoinTap();
                  },
                  enabled:
                      detail.participationState.canRequestJoin &&
                      !isJoinActionInFlight,
                  tone: detail.participationState.canRequestJoin
                      ? MateyaButtonTone.brand
                      : MateyaButtonTone.dark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
