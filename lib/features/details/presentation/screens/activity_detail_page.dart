import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../mypage/application/mypage_controller.dart';
import '../../../mypage/data/mypage_repository.dart';
import '../../../mypage/presentation/screens/mypage_flow_page.dart';
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('공유 링크를 복사했어요. 원하는 메신저에 바로 붙여넣을 수 있습니다.')),
    );
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

  Future<void> _openReviewList() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ActivityReviewListPage(controller: widget.controller),
      ),
    );
  }

  Future<void> _openOtherProfile(String userId) async {
    if (userId.isEmpty) {
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final detail = widget.controller.detail;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: switch (widget.controller.phase) {
            AsyncPhase.loading || AsyncPhase.idle => const DetailLoadingState(),
            AsyncPhase.networkError ||
            AsyncPhase.serverError => DetailErrorState(
              message: widget.controller.errorMessage ?? '활동 정보를 불러오지 못했어요.',
              onRetry: widget.controller.retry,
            ),
            AsyncPhase.success || AsyncPhase.validationError =>
              detail == null
                  ? const DetailLoadingState()
                  : Stack(
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
                                onBack: () => Navigator.of(context).pop(),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: DetailBody(
                                detail: detail,
                                controller: widget.controller,
                                onOpenReviews: _openReviewList,
                                onHelpfulTap: _handleHelpfulTap,
                                onOpenOtherProfile: _openOtherProfile,
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
                            onShareTap: () => _copyShareUrl(detail.shareUrl),
                            onJoinTap: widget.controller.toggleJoin,
                          ),
                        ),
                      ],
                    ),
          },
        );
      },
    );
  }
}

class ActivityReviewListPage extends StatefulWidget {
  const ActivityReviewListPage({super.key, required this.controller});

  final ActivityDetailController controller;

  @override
  State<ActivityReviewListPage> createState() => _ActivityReviewListPageState();
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final detail = widget.controller.detail!;
        final summary = widget.controller.reviewSummary;
        final reviews = widget.controller.visibleReviews;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: AppColors.textPrimary,
            titleSpacing: 0,
            title: Text(
              detail.activity.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: MateyaButton(
                label: '후기 작성하기',
                onPressed: _openReviewComposer,
              ),
            ),
          ),
          body: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            children: <Widget>[
              Text(
                detail.activity.title,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 20),
              RatingSummaryPanel(summary: summary),
              const SizedBox(height: 24),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final option = ReviewSortOption.values[index];
                    final selected = widget.controller.reviewSort == option;
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
              const SizedBox(height: 20),
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
                  Divider(height: 32, color: AppColors.divider),
              ],
              if (widget.controller.canLoadMoreReviews)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Center(
                    child: Text(
                      '스크롤하면 후기를 더 불러옵니다.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
