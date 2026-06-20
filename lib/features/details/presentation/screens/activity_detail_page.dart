import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/navigation/mateya_route_observer.dart';
import '../../../../shared/navigation/mateya_user_profile_navigation.dart';
import '../../../../shared/report/report_repository.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../../shared/widgets/mateya_profile_avatar.dart';
import '../../../../shared/widgets/mateya_report_sheet.dart';
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

class _ActivityDetailPageState extends State<ActivityDetailPage>
    with RouteAware {
  final PageController _pageController = PageController();
  final ReportRepository _reportRepository = ReportRepository();
  int _currentImagePage = 0;
  PageRoute<dynamic>? _route;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
    widget.controller.initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is! PageRoute<dynamic> || identical(route, _route)) {
      return;
    }
    if (_route != null) {
      mateyaRouteObserver.unsubscribe(this);
    }
    _route = route;
    mateyaRouteObserver.subscribe(this, route);
  }

  @override
  void dispose() {
    mateyaRouteObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    _pageController.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    _refreshDetail();
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
    await _refreshDetail();
  }

  Future<void> _openParticipantRequests() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ActivityParticipantRequestPage(
          controller: widget.controller,
          onOpenOtherProfile: _openProfile,
        ),
      ),
    );
    await _refreshDetail();
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
    await openMateyaUserProfile(context, userId);
    await _refreshDetail();
  }

  Future<void> _openReviewComposer([ActivityReview? review]) async {
    final isEditing = review != null;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReviewComposerSheet(
        initialRating: review?.rating ?? 0,
        initialBody: review?.originalText ?? '',
        initialImageUrls: review?.imageUrls ?? const <String>[],
        title: isEditing
            ? context.l10n.detailsReviewEditTitle
            : context.l10n.detailsReviewComposerTitle,
        submitLabel: isEditing
            ? context.l10n.detailsReviewEditSubmit
            : context.l10n.detailsReviewSubmit,
        submittingLabel: isEditing
            ? context.l10n.detailsReviewUpdating
            : context.l10n.detailsReviewSubmitting,
        successMessage: isEditing
            ? context.l10n.detailsReviewUpdated
            : context.l10n.detailsReviewSubmitted,
        onSubmit: (rating, body, imageUrls) => isEditing
            ? widget.controller.updateReview(
                reviewId: review.id,
                rating: rating,
                body: body,
                imageUrls: imageUrls,
              )
            : widget.controller.submitReview(
                rating: rating,
                body: body,
                imageUrls: imageUrls,
              ),
      ),
    );
  }

  Future<void> _handleEditReview(ActivityReview review) {
    return _openReviewComposer(review);
  }

  Future<void> _handleDeleteReview(ActivityReview review) async {
    final l10n = context.l10n;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.detailsReviewDeleteDialogTitle),
        content: Text(l10n.detailsReviewDeleteDialogBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !mounted) {
      return;
    }
    final message = await widget.controller.deleteReview(review.id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? l10n.detailsReviewDeleted)),
    );
  }

  Future<void> _refreshDetail() async {
    await widget.controller.retry();
  }

  late final WidgetsBindingObserver _lifecycleObserver =
      _ActivityDetailLifecycleObserver(onResumed: _refreshDetail);

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
                                  key: const PageStorageKey<String>(
                                    'activity-detail-scroll',
                                  ),
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
                                        onEditReview: _handleEditReview,
                                        onDeleteReview: _handleDeleteReview,
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
                                    onJoinTap: _handleJoinTap,
                                    isFavoriteActionInFlight:
                                        widget.controller.isMutatingFavorite,
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

class _ActivityDetailLifecycleObserver with WidgetsBindingObserver {
  _ActivityDetailLifecycleObserver({required this.onResumed});

  final Future<void> Function() onResumed;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      return;
    }
    onResumed();
  }
}

class ActivityReviewListPage extends StatefulWidget {
  const ActivityReviewListPage({super.key, required this.controller});

  final ActivityDetailController controller;

  @override
  State<ActivityReviewListPage> createState() => _ActivityReviewListPageState();
}

class ActivityParticipantRequestPage extends StatelessWidget {
  const ActivityParticipantRequestPage({
    super.key,
    required this.controller,
    required this.onOpenOtherProfile,
  });

  final ActivityDetailController controller;
  final Future<void> Function(String userId) onOpenOtherProfile;

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
          body: SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                MateyaHeader.backArrow(
                  onBack: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: ListView(
                    key: const PageStorageKey<String>(
                      'activity-participant-request-scroll',
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    children: <Widget>[
                      Text(
                        detail.activity.title,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 18),
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
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const Spacer(),
                                Text(
                                  remaining > 0
                                      ? l10n.detailsParticipantsRemaining(
                                          remaining,
                                        )
                                      : l10n.detailsRecruitmentClosed,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: remaining > 0
                                            ? AppColors.brandGreen
                                            : AppColors.error,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                                minHeight: 8,
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
                      for (final participant
                          in detail.participants) ...<Widget>[
                        _ParticipantCard(
                          participant: participant,
                          backgroundColor: Colors.white,
                          actionIcon: Icons.check_rounded,
                          actionColor: AppColors.brandGreen,
                          onTap: (context) => _openParticipantActions(
                            context,
                            participant: participant,
                            isPending: false,
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                      const SizedBox(height: 10),
                      Text(
                        l10n.detailsPendingParticipantsListTitle,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 14),
                      for (final participant
                          in detail.pendingParticipants) ...<Widget>[
                        _ParticipantCard(
                          participant: participant,
                          backgroundColor: AppColors.softGreenBorder,
                          actionIcon: Icons.add_rounded,
                          actionColor: AppColors.brandGreen,
                          onTap: (context) => _openParticipantActions(
                            context,
                            participant: participant,
                            isPending: true,
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
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

  Future<void> _openParticipantActions(
    BuildContext context, {
    required ActivityParticipant participant,
    required bool isPending,
  }) async {
    final l10n = context.l10n;
    final action = await showModalBottomSheet<_ParticipantAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: <Widget>[
                    MateyaProfileAvatar(
                      imageUrl: participant.avatarUrl,
                      size: 52,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            participant.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            participant.residenceLabel,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ParticipantActionTile(
                  icon: Icons.person_outline_rounded,
                  label: l10n.detailsParticipantActionViewProfile,
                  onTap: () => Navigator.of(
                    sheetContext,
                  ).pop(_ParticipantAction.openProfile),
                ),
                if (isPending)
                  _ParticipantActionTile(
                    icon: Icons.add_rounded,
                    label: l10n.detailsParticipantActionApprove,
                    onTap: () => Navigator.of(
                      sheetContext,
                    ).pop(_ParticipantAction.approve),
                  )
                else
                  _ParticipantActionTile(
                    icon: Icons.person_remove_alt_1_rounded,
                    label: l10n.detailsParticipantActionRemove,
                    isDanger: true,
                    onTap: () => Navigator.of(
                      sheetContext,
                    ).pop(_ParticipantAction.remove),
                  ),
                if (isPending)
                  _ParticipantActionTile(
                    icon: Icons.close_rounded,
                    label: l10n.detailsParticipantActionCancelRequest,
                    isDanger: true,
                    onTap: () => Navigator.of(
                      sheetContext,
                    ).pop(_ParticipantAction.remove),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (!context.mounted || action == null) {
      return;
    }

    switch (action) {
      case _ParticipantAction.openProfile:
        await onOpenOtherProfile(participant.id);
      case _ParticipantAction.approve:
        final message = await controller.approvePendingParticipant(
          participant.id,
        );
        if (!context.mounted) {
          return;
        }
        if (message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      case _ParticipantAction.remove:
        final message = isPending
            ? await controller.removePendingParticipant(participant.id)
            : await controller.removeApprovedParticipant(participant.id);
        if (!context.mounted) {
          return;
        }
        if (message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          return;
        }
        final successMessage = isPending
            ? l10n.detailsPendingCancelled
            : l10n.detailsParticipantRemoved;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(successMessage)));
    }
  }
}

class _ParticipantCard extends StatelessWidget {
  const _ParticipantCard({
    required this.participant,
    required this.actionIcon,
    required this.actionColor,
    required this.onTap,
    this.backgroundColor = Colors.white,
  });

  final ActivityParticipant participant;
  final IconData actionIcon;
  final Color actionColor;
  final Future<void> Function(BuildContext context) onTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => onTap(context),
      child: MyPageSectionCard(
        child: Container(
          color: backgroundColor,
          child: Row(
            children: <Widget>[
              MateyaProfileAvatar(imageUrl: participant.avatarUrl, size: 48),
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
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: actionColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(actionIcon, color: Colors.white, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ParticipantAction { openProfile, approve, remove }

class _ParticipantActionTile extends StatelessWidget {
  const _ParticipantActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? AppColors.error : AppColors.textPrimary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: <Widget>[
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
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
    await _openReviewComposerFor(null);
  }

  Future<void> _openReviewComposerFor(ActivityReview? review) async {
    final isEditing = review != null;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReviewComposerSheet(
        initialRating: review?.rating ?? 0,
        initialBody: review?.originalText ?? '',
        initialImageUrls: review?.imageUrls ?? const <String>[],
        title: isEditing
            ? context.l10n.detailsReviewEditTitle
            : context.l10n.detailsReviewComposerTitle,
        submitLabel: isEditing
            ? context.l10n.detailsReviewEditSubmit
            : context.l10n.detailsReviewSubmit,
        submittingLabel: isEditing
            ? context.l10n.detailsReviewUpdating
            : context.l10n.detailsReviewSubmitting,
        successMessage: isEditing
            ? context.l10n.detailsReviewUpdated
            : context.l10n.detailsReviewSubmitted,
        onSubmit: (rating, body, imageUrls) => isEditing
            ? widget.controller.updateReview(
                reviewId: review.id,
                rating: rating,
                body: body,
                imageUrls: imageUrls,
              )
            : widget.controller.submitReview(
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

  Future<void> _openProfile(String userId) async {
    await openMateyaUserProfile(context, userId);
    if (!mounted) {
      return;
    }
    await widget.controller.retry();
  }

  Future<void> _handleDeleteReview(ActivityReview review) async {
    final l10n = context.l10n;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.detailsReviewDeleteDialogTitle),
        content: Text(l10n.detailsReviewDeleteDialogBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !mounted) {
      return;
    }
    final message = await widget.controller.deleteReview(review.id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? l10n.detailsReviewDeleted)),
    );
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
                    key: const PageStorageKey<String>(
                      'activity-review-list-scroll',
                    ),
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
                          isHelpfulActionInFlight: widget.controller
                              .isHelpfulMutationInFlight(reviews[index].id),
                          onAuthorTap: () {
                            unawaited(
                              _openProfile(reviews[index].authorUserId),
                            );
                          },
                          onHelpfulTap: () {
                            _handleHelpfulTap(reviews[index].id);
                          },
                          onTranslationTap: reviews[index].supportsTranslation
                              ? () {
                                  unawaited(
                                    widget.controller.toggleTranslation(
                                      reviews[index].id,
                                    ),
                                  );
                                }
                              : null,
                          onEditTap:
                              widget.controller.canManageReview(reviews[index])
                              ? () {
                                  unawaited(
                                    _openReviewComposerFor(reviews[index]),
                                  );
                                }
                              : null,
                          onDeleteTap:
                              widget.controller.canManageReview(reviews[index])
                              ? () {
                                  unawaited(
                                    _handleDeleteReview(reviews[index]),
                                  );
                                }
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
