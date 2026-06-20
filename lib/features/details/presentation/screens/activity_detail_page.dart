import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/auth/auth_session.dart';
import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/navigation/mateya_auth_flow.dart';
import '../../../../shared/report/report_repository.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../../shared/widgets/mateya_report_sheet.dart';
import '../../../mypage/application/mypage_controller.dart';
import '../../../mypage/data/mypage_repository.dart';
import '../../../mypage/presentation/screens/mypage_flow_page.dart';
import '../../../mypage/presentation/widgets/mypage_activity_widgets.dart';
import '../../../onboarding/domain/onboarding_flow.dart';
import '../../application/activity_detail_controller.dart';
import '../../domain/activity_detail_models.dart';
import '../widgets/activity_detail_review_composer.dart';
import '../widgets/activity_detail_review_widgets.dart';
import '../widgets/activity_detail_sections.dart';
import '../widgets/activity_detail_states.dart';

class ActivityDetailPage extends StatefulWidget {
  const ActivityDetailPage({super.key, required this.controller});

  final ActivityDetailController controller;

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  final PageController _pageController = PageController();
  final ReportRepository _reportRepository = ReportRepository();
  int _currentImagePage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.initialize();
  }

  @override
  void dispose() {
    _pageController.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  Future<void> _copyShareUrl(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.detailsShareCopied)));
  }

  Future<void> _handleFavoriteTap() async {
    final message = await widget.controller.toggleFavorite();
    if (!mounted || message == null) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleHelpfulTap(String reviewId) async {
    final message = await widget.controller.toggleHelpful(reviewId);
    if (!mounted || message == null) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleJoinTap() async {
    final message = await widget.controller.requestJoin();
    if (!mounted || message == null) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openReviewList() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ActivityReviewListPage(controller: widget.controller),
      ),
    );
  }

  Future<void> _openParticipantRequests() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ActivityParticipantRequestPage(controller: widget.controller),
      ),
    );
  }

  Future<String?> _submitActivityReport(String body, List<XFile> images) async {
    final detail = widget.controller.detail;
    if (detail == null) {
      return context.l10n.detailsReportActivityReload;
    }

    try {
      await _reportRepository.submitReport(
        targetType: ReportTargetType.activity,
        targetId: detail.activity.id,
        reason: body,
        images: images,
      );
      return null;
    } on ReportRepositoryException catch (error) {
      return error.message;
    }
  }

  Future<void> _openReportSheet(String subjectLabel) {
    return showMateyaReportSheet(
      context,
      subjectLabel: subjectLabel,
      onSubmit: _submitActivityReport,
    );
  }

  Future<void> _openProfile(String userId) async {
    if (userId.isEmpty) {
      return;
    }
    final session = AuthSessionStore.instance.session;
    final currentUserId = session?.user.id.toString();
    final isHostFlow = _isHostRole(session?.user.role);
    final hasSession = AuthSessionStore.instance.hasSession;
    if (!hasSession) {
      await replaceWithMateyaOnboardingFlow(context);
      return;
    }

    if (currentUserId != null && currentUserId == userId) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => MyPageFlowPage(
            controller: MyPageController(
              repository: ApiMyPageRepository(),
              flowKind: isHostFlow ? FlowKind.host : FlowKind.guest,
            ),
            onRootBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MyPageFlowPage(
          controller: MyPageController(
            repository: ApiMyPageRepository(),
            flowKind: FlowKind.guest,
            initialOtherProfileUserId: userId,
          ),
          onRootBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final l10n = context.l10n;
        final detail = widget.controller.detail;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: switch (widget.controller.phase) {
            AsyncPhase.loading || AsyncPhase.idle => const DetailLoadingState(),
            AsyncPhase.networkError ||
            AsyncPhase.serverError => DetailErrorState(
              message: widget.controller.errorMessage ?? l10n.detailsLoadError,
              onRetry: widget.controller.retry,
            ),
            AsyncPhase.success || AsyncPhase.validationError =>
              detail == null
                  ? const DetailLoadingState()
                  : SafeArea(
                      bottom: false,
                      child: Column(
                        children: <Widget>[
                          MateyaHeader.backArrow(
                            onBack: () => Navigator.of(context).pop(),
                            onReportTap: () =>
                                _openReportSheet(detail.activity.title),
                          ),
                          Expanded(
                            child: Stack(
                              children: <Widget>[
                                CustomScrollView(
                                  slivers: <Widget>[
                                    SliverToBoxAdapter(
                                      child: DetailHeroSection(
                                        detail: detail,
                                        pageController: _pageController,
                                        currentPage: _currentImagePage,
                                        onPageChanged: (value) {
                                          if (_currentImagePage == value) {
                                            return;
                                          }
                                          setState(() {
                                            _currentImagePage = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SliverToBoxAdapter(
                                      child: DetailBody(
                                        detail: detail,
                                        controller: widget.controller,
                                        onOpenReviews: _openReviewList,
                                        onOpenParticipantRequests:
                                            _openParticipantRequests,
                                        onHelpfulTap: _handleHelpfulTap,
                                        onOpenOtherProfile: _openProfile,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: DetailBottomBar(
                                    detail: detail,
                                    onFavoriteTap: _handleFavoriteTap,
                                    onShareTap: () =>
                                        _copyShareUrl(detail.shareUrl),
                                    onJoinTap: _handleJoinTap,
                                    isJoinActionInFlight:
                                        widget.controller.isRequestingJoin,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
          },
        );
      },
    );
  }
}

bool _isHostRole(String? role) {
  final normalizedRole = role?.trim().toUpperCase() ?? '';
  return normalizedRole == 'BUSINESS' || normalizedRole == 'HOST';
}

class ActivityReviewListPage extends StatefulWidget {
  const ActivityReviewListPage({super.key, required this.controller});

  final ActivityDetailController controller;

  @override
  State<ActivityReviewListPage> createState() => _ActivityReviewListPageState();
}

class ActivityParticipantRequestPage extends StatelessWidget {
  const ActivityParticipantRequestPage({super.key, required this.controller});

  final ActivityDetailController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final l10n = context.l10n;
        final detail = controller.detail!;
        final remaining =
            detail.activity.participantCapacity -
            detail.activity.participantCount;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: AppColors.textPrimary,
            title: Text(
              detail.activity.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: <Widget>[
              MyPageSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          l10n.detailsParticipantsJoined(
                            detail.activity.participantCount,
                          ),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        Text(
                          remaining > 0
                              ? l10n.detailsParticipantsRemaining(remaining)
                              : l10n.detailsRecruitmentClosed,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.brandGreen),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: detail.activity.participantCapacity == 0
                            ? 0
                            : detail.activity.participantCount /
                                  detail.activity.participantCapacity,
                        minHeight: 10,
                        backgroundColor: AppColors.divider,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.brandGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                l10n.detailsParticipantsListTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 14),
              for (final participant in detail.participants) ...<Widget>[
                _ParticipantCard(
                  participant: participant,
                  actionIcon:
                      controller.armedParticipantRemovalId == participant.id
                      ? Icons.remove_rounded
                      : Icons.check_rounded,
                  actionColor:
                      controller.armedParticipantRemovalId == participant.id
                      ? const Color(0xFFC73E19)
                      : AppColors.brandGreen,
                  onTap: (context) async {
                    if (controller.armedParticipantRemovalId ==
                        participant.id) {
                      final message = await controller
                          .removeApprovedParticipant(participant.id);
                      if (!context.mounted) {
                        return;
                      }
                      if (message != null) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.detailsParticipantRemoved)),
                      );
                    } else {
                      controller.armParticipantRemoval(participant.id);
                    }
                  },
                  onDismissAttempt: (context) async {
                    final message = await controller.removeApprovedParticipant(
                      participant.id,
                    );
                    if (!context.mounted) {
                      return false;
                    }
                    if (message != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                      return false;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.detailsParticipantRemoved)),
                    );
                    return true;
                  },
                ),
                const SizedBox(height: 14),
              ],
              const SizedBox(height: 16),
              Text(
                l10n.detailsPendingParticipantsListTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 14),
              for (final participant in detail.pendingParticipants) ...<Widget>[
                _ParticipantCard(
                  participant: participant,
                  backgroundColor: AppColors.softGreenBorder,
                  actionIcon: Icons.add_rounded,
                  actionColor: AppColors.brandGreen,
                  onTap: (context) async {
                    final message = await controller.approvePendingParticipant(
                      participant.id,
                    );
                    if (!context.mounted) {
                      return;
                    }
                    if (message == null) {
                      return;
                    }
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(message)));
                  },
                  onDismissAttempt: (context) async {
                    final message = await controller.removePendingParticipant(
                      participant.id,
                    );
                    if (!context.mounted) {
                      return false;
                    }
                    if (message != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                      return false;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.detailsPendingCancelled)),
                    );
                    return true;
                  },
                ),
                const SizedBox(height: 14),
              ],
              const SizedBox(height: 8),
              Text(
                l10n.detailsParticipantSwipeHint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ParticipantCard extends StatelessWidget {
  const _ParticipantCard({
    required this.participant,
    required this.actionIcon,
    required this.actionColor,
    required this.onTap,
    required this.onDismissAttempt,
    this.backgroundColor = Colors.white,
  });

  final ActivityParticipant participant;
  final IconData actionIcon;
  final Color actionColor;
  final Future<void> Function(BuildContext context) onTap;
  final Future<bool> Function(BuildContext context) onDismissAttempt;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<String>('participant-${participant.id}-$actionIcon'),
      background: const SizedBox.shrink(),
      secondaryBackground: const SizedBox.shrink(),
      confirmDismiss: (_) => onDismissAttempt(context),
      child: MyPageSectionCard(
        child: Container(
          color: backgroundColor,
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 24,
                backgroundImage: participant.avatarUrl == null
                    ? null
                    : NetworkImage(participant.avatarUrl!),
                child: participant.avatarUrl == null
                    ? const Icon(Icons.person_outline_rounded)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      participant.name,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      participant.residenceLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => onTap(context),
                icon: Icon(actionIcon),
                color: Colors.white,
                style: IconButton.styleFrom(
                  backgroundColor: actionColor,
                  fixedSize: const Size(34, 34),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityReviewListPageState extends State<ActivityReviewListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    if (position.extentAfter < 280) {
      widget.controller.loadMoreReviews();
    }
  }

  Future<void> _openReviewComposer() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReviewComposerSheet(
        onSubmit: (rating, body, imageUrls) => widget.controller.submitReview(
          rating: rating,
          body: body,
          imageUrls: imageUrls,
        ),
      ),
    );
  }

  Future<void> _handleHelpfulTap(String reviewId) async {
    final message = await widget.controller.toggleHelpful(reviewId);
    if (!mounted || message == null) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openReportSheet(String subjectLabel) {
    return showMateyaReportSheet(context, subjectLabel: subjectLabel);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final l10n = context.l10n;
        final detail = widget.controller.detail!;
        final summary = widget.controller.reviewSummary;
        final reviews = widget.controller.visibleReviews;

        return Scaffold(
          backgroundColor: AppColors.appSurface,
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: MateyaButton(
                label: l10n.detailsReviewComposerTitle,
                onPressed: _openReviewComposer,
              ),
            ),
          ),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                MateyaHeader.backArrow(
                  onBack: () => Navigator.of(context).pop(),
                  onReportTap: () => _openReportSheet(
                    l10n.detailsReviewListReportSubject(detail.activity.title),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                    children: <Widget>[
                      Text(
                        detail.activity.title,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontSize: 26),
                      ),
                      const SizedBox(height: 18),
                      RatingSummaryPanel(summary: summary),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final option = ReviewSortOption.values[index];
                            final selected =
                                widget.controller.reviewSort == option;
                            return ChoiceChip(
                              label: Text(option.label),
                              selected: selected,
                              onSelected: (_) =>
                                  widget.controller.updateReviewSort(option),
                              showCheckmark: false,
                              selectedColor: AppColors.brandGreen,
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                color: selected
                                    ? AppColors.brandGreen
                                    : AppColors.divider,
                              ),
                              labelStyle: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: selected
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                  ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            );
                          },
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemCount: ReviewSortOption.values.length,
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (
                        var index = 0;
                        index < reviews.length;
                        index += 1
                      ) ...<Widget>[
                        ReviewCard(
                          review: reviews[index],
                          onHelpfulTap: () {
                            _handleHelpfulTap(reviews[index].id);
                          },
                          onTranslationTap: reviews[index].supportsTranslation
                              ? () => widget.controller.toggleTranslation(
                                  reviews[index].id,
                                )
                              : null,
                        ),
                        if (index != reviews.length - 1)
                          const SizedBox(height: 16),
                      ],
                      if (widget.controller.canLoadMoreReviews)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Center(
                            child: Text(
                              l10n.detailsReviewLoadMoreHint,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
