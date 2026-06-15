import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../onboarding/domain/onboarding_flow.dart';
import '../../application/activity_detail_controller.dart';
import '../../domain/activity_detail_models.dart';

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

  Future<void> _openReviewList() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ActivityReviewListPage(controller: widget.controller),
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
            AsyncPhase.loading ||
            AsyncPhase.idle => const _DetailLoadingState(),
            AsyncPhase.networkError ||
            AsyncPhase.serverError => _DetailErrorState(
              message: widget.controller.errorMessage ?? '활동 정보를 불러오지 못했어요.',
              onRetry: widget.controller.retry,
            ),
            AsyncPhase.success || AsyncPhase.validationError =>
              detail == null
                  ? const _DetailLoadingState()
                  : Stack(
                      children: <Widget>[
                        CustomScrollView(
                          slivers: <Widget>[
                            SliverToBoxAdapter(
                              child: _DetailHeroSection(
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
                              child: _DetailBody(
                                detail: detail,
                                controller: widget.controller,
                                onOpenReviews: _openReviewList,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: _DetailBottomBar(
                            detail: detail,
                            onFavoriteTap: widget.controller.toggleFavorite,
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
      builder: (context) => _ReviewComposerSheet(
        onSubmit: (rating, body, imageUrls) {
          final didSubmit = widget.controller.submitReview(
            rating: rating,
            body: body,
            imageUrls: imageUrls,
          );
          if (!didSubmit) {
            return false;
          }
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            this.context,
          ).showSnackBar(const SnackBar(content: Text('후기를 등록했어요.')));
          return true;
        },
      ),
    );
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
              _RatingSummaryPanel(summary: summary),
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
                _ReviewCard(
                  review: reviews[index],
                  onHelpfulTap: () =>
                      widget.controller.toggleHelpful(reviews[index].id),
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

class _DetailHeroSection extends StatelessWidget {
  const _DetailHeroSection({
    required this.detail,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    required this.onBack,
  });

  final ActivityDetail detail;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Stack(
        children: <Widget>[
          PageView.builder(
            controller: pageController,
            itemCount: detail.imageUrls.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return _NetworkOrFileImage(
                imageUrl: detail.imageUrls[index],
                fit: BoxFit.cover,
              );
            },
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0x50000000),
                    Color(0x00000000),
                    Color(0x38000000),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: <Widget>[
                  _HeroCircleButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: onBack,
                  ),
                  const Spacer(),
                  _CategoryPill(
                    label: detail.activity.categoryLabel,
                    filled: true,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: Row(
              children: List<Widget>.generate(
                detail.imageUrls.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: EdgeInsets.only(
                    right: index == detail.imageUrls.length - 1 ? 0 : 6,
                  ),
                  width: currentPage == index ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.detail,
    required this.controller,
    required this.onOpenReviews,
  });

  final ActivityDetail detail;
  final ActivityDetailController controller;
  final VoidCallback onOpenReviews;

  @override
  Widget build(BuildContext context) {
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
          _InfoLine(
            icon: Icons.calendar_today_rounded,
            text: _formatLongDate(detail.activity.startAt),
          ),
          const SizedBox(height: 10),
          _InfoLine(
            icon: Icons.schedule_rounded,
            text: _formatTimeRange(
              detail.activity.startAt,
              detail.activity.endAt,
            ),
          ),
          const SizedBox(height: 10),
          _InfoLine(
            icon: Icons.star_rounded,
            text:
                '${summary.averageRating.toStringAsFixed(2)} (리뷰 ${summary.totalCount}개)',
          ),
          const SizedBox(height: 10),
          _InfoLine(
            icon: Icons.groups_2_outlined,
            text:
                '${detail.activity.participantCount}/${detail.activity.participantCapacity} 참여',
          ),
          const SizedBox(height: 10),
          _InfoLine(icon: Icons.place_outlined, text: detail.locationLabel),
          const SizedBox(height: 28),
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '${detail.activity.participantCount}명 참여중',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 18),
                    ),
                    const Spacer(),
                    Text(
                      remaining > 0 ? '$remaining명 남았어요' : '모집 마감',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: remaining > 0
                            ? AppColors.brandGreen
                            : AppColors.error,
                        fontWeight: FontWeight.w600,
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
                _ParticipantAvatarRow(participants: detail.participants),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionCard(
            child: Row(
              children: <Widget>[
                _AvatarCircle(
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
                        '${detail.host.name} ${detail.host.localizedName}',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        detail.host.locationLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: controller.toggleHostFriend,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: detail.host.isFriend
                          ? AppColors.brandGreen
                          : AppColors.divider,
                    ),
                    foregroundColor: detail.host.isFriend
                        ? AppColors.brandGreen
                        : AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(detail.host.isFriend ? '친구됨' : '친구추가'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionHeader(title: '활동 소개'),
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
                child: _SectionHeader(
                  title: '후기 ${summary.totalCount}개',
                  compact: true,
                ),
              ),
              TextButton(onPressed: onOpenReviews, child: const Text('전체보기')),
            ],
          ),
          const SizedBox(height: 8),
          if (controller.previewReviews.isEmpty)
            _SectionCard(
              child: Text(
                '아직 등록된 후기가 없어요. 첫 후기를 남겨보세요.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else
            for (
              var index = 0;
              index < controller.previewReviews.length;
              index += 1
            ) ...<Widget>[
              _ReviewCard(
                review: controller.previewReviews[index],
                onHelpfulTap: () => controller.toggleHelpful(
                  controller.previewReviews[index].id,
                ),
                onTranslationTap:
                    controller.previewReviews[index].supportsTranslation
                    ? () => controller.toggleTranslation(
                        controller.previewReviews[index].id,
                      )
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

class _DetailBottomBar extends StatelessWidget {
  const _DetailBottomBar({
    required this.detail,
    required this.onFavoriteTap,
    required this.onShareTap,
    required this.onJoinTap,
  });

  final ActivityDetail detail;
  final VoidCallback onFavoriteTap;
  final VoidCallback onShareTap;
  final VoidCallback onJoinTap;

  @override
  Widget build(BuildContext context) {
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
                      '체험료',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatPrice(detail.activity.price),
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
              _BottomGlyphButton(
                icon: detail.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                onTap: onFavoriteTap,
              ),
              const SizedBox(width: 10),
              _BottomGlyphButton(icon: Icons.share_outlined, onTap: onShareTap),
              const SizedBox(width: 12),
              SizedBox(
                width: 146,
                child: MateyaButton(
                  label: detail.isJoined ? '참가중' : '참가하기',
                  onPressed: onJoinTap,
                  tone: detail.isJoined
                      ? MateyaButtonTone.dark
                      : MateyaButtonTone.brand,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewComposerSheet extends StatefulWidget {
  const _ReviewComposerSheet({required this.onSubmit});

  final bool Function(int rating, String body, List<String> imageUrls) onSubmit;

  @override
  State<_ReviewComposerSheet> createState() => _ReviewComposerSheetState();
}

class _ReviewComposerSheetState extends State<_ReviewComposerSheet> {
  static const int _maxImageCount = 5;

  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _bodyController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<XFile> _images = <XFile>[];

  int _rating = 0;
  int? _draggingIndex;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _bodyController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get _canSubmit => _rating > 0 && _bodyController.text.trim().isNotEmpty;

  Future<void> _pickImages() async {
    final available = _maxImageCount - _images.length;
    if (available <= 0) {
      return;
    }
    final picked = await _imagePicker.pickMultiImage(imageQuality: 88);
    if (!mounted || picked.isEmpty) {
      return;
    }
    setState(() {
      _images.addAll(picked.take(available));
    });
  }

  void _moveImage(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) {
      return;
    }
    setState(() {
      final item = _images.removeAt(fromIndex);
      _images.insert(toIndex, item);
      _draggingIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final textLength = _bodyController.text.length;

    return Container(
      color: AppColors.overlay,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                      Expanded(
                        child: Text(
                          '후기 작성하기',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List<Widget>.generate(5, (index) {
                      final star = index + 1;
                      final isActive = star <= _rating;
                      return IconButton(
                        onPressed: () => setState(() => _rating = star),
                        icon: Icon(
                          isActive
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: isActive
                              ? AppColors.textPrimary
                              : AppColors.fieldBorderLight,
                          size: 34,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _focusNode.hasFocus
                            ? AppColors.textPrimary
                            : AppColors.fieldBorderLight,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        TextField(
                          controller: _bodyController,
                          focusNode: _focusNode,
                          maxLines: 6,
                          maxLength: 500,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            hintText: '활동에서 좋았던 점이나 다음 참가자에게 도움이 될 내용을 남겨 주세요.',
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        Text(
                          '$textLength/500 자',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '사진 첨부 (${_images.length}/$_maxImageCount)',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontSize: 17),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _images.length >= _maxImageCount
                            ? null
                            : _pickImages,
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                        label: const Text('추가'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_images.isNotEmpty)
                    SizedBox(
                      height: 92,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => DragTarget<int>(
                          onWillAcceptWithDetails: (details) =>
                              details.data != index,
                          onAcceptWithDetails: (details) =>
                              _moveImage(details.data, index),
                          builder: (context, candidateData, rejectedData) {
                            final item = _images[index];
                            final isDragging = _draggingIndex == index;
                            return Opacity(
                              opacity: isDragging ? 0.6 : 1,
                              child: LongPressDraggable<int>(
                                data: index,
                                onDragStarted: () =>
                                    setState(() => _draggingIndex = index),
                                onDragEnd: (_) =>
                                    setState(() => _draggingIndex = null),
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: _ReviewImageTile(
                                    imagePath: item.path,
                                    index: index,
                                    onRemove: null,
                                  ),
                                ),
                                child: _ReviewImageTile(
                                  imagePath: item.path,
                                  index: index,
                                  onRemove: () =>
                                      setState(() => _images.removeAt(index)),
                                ),
                              ),
                            );
                          },
                        ),
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemCount: _images.length,
                      ),
                    )
                  else
                    Container(
                      height: 92,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider),
                        color: AppColors.subtleBackground,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '첫 번째 사진이 대표 이미지가 됩니다. 길게 눌러 순서를 바꿀 수 있어요.',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  MateyaButton(
                    label: '작성하기',
                    enabled: _canSubmit,
                    onPressed: _canSubmit
                        ? () => widget.onSubmit(
                            _rating,
                            _bodyController.text,
                            _images
                                .map((image) => image.path)
                                .toList(growable: false),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RatingSummaryPanel extends StatelessWidget {
  const _RatingSummaryPanel({required this.summary});

  final ReviewSummary summary;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 86,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  summary.averageRating.toStringAsFixed(2),
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                ),
                const SizedBox(height: 6),
                Row(
                  children: List<Widget>.generate(
                    5,
                    (_) => const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '총 ${summary.totalCount}개 후기',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: List<Widget>.generate(5, (index) {
                final star = 5 - index;
                final count = summary.ratingCounts[star] ?? 0;
                final ratio = summary.totalCount == 0
                    ? 0.0
                    : count / summary.totalCount;
                return Padding(
                  padding: EdgeInsets.only(bottom: index == 4 ? 0 : 10),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 18,
                        child: Text(
                          '$star',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 8,
                            backgroundColor: AppColors.subtleBackground,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.brandGreen,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 20,
                        child: Text(
                          '$count',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.review,
    required this.onHelpfulTap,
    required this.onTranslationTap,
  });

  final ActivityReview review;
  final VoidCallback onHelpfulTap;
  final VoidCallback? onTranslationTap;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _AvatarCircle(
                imageUrl: review.authorAvatarUrl,
                size: 42,
                initials: review.authorName.isNotEmpty
                    ? review.authorName.substring(0, 1)
                    : 'U',
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      review.authorName,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatReviewDate(review.submittedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${review.rating}점',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            review.visibleBody,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
          if (review.imageUrls.isNotEmpty) ...<Widget>[
            const SizedBox(height: 14),
            SizedBox(
              height: 84,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 84,
                    child: _NetworkOrFileImage(
                      imageUrl: review.imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemCount: review.imageUrls.length,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: onHelpfulTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 4,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        review.isHelpfulByMe
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: review.isHelpfulByMe
                            ? AppColors.brandGreen
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '도움이 돼요',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: review.isHelpfulByMe
                              ? AppColors.brandGreen
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${review.helpfulCount}명에게 도움이 됨',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              if (onTranslationTap != null)
                TextButton(
                  onPressed: onTranslationTap,
                  child: Text(review.isTranslationVisible ? '원문보기' : '번역보기'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewImageTile extends StatelessWidget {
  const _ReviewImageTile({
    required this.imagePath,
    required this.index,
    required this.onRemove,
  });

  final String imagePath;
  final int index;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 92,
            height: 92,
            child: _NetworkOrFileImage(imageUrl: imagePath, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          left: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              index == 0 ? '대표' : '${index + 1}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white),
            ),
          ),
        ),
        if (onRemove != null)
          Positioned(
            right: 6,
            top: 6,
            child: InkWell(
              onTap: onRemove,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.58),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ParticipantAvatarRow extends StatelessWidget {
  const _ParticipantAvatarRow({required this.participants});

  final List<ActivityParticipant> participants;

  @override
  Widget build(BuildContext context) {
    final visible = participants.take(8).toList(growable: false);
    final remaining = participants.length - visible.length;

    return SizedBox(
      height: 40,
      child: Stack(
        children: <Widget>[
          for (var index = 0; index < visible.length; index += 1)
            Positioned(
              left: index * 26,
              child: _AvatarCircle(
                imageUrl: visible[index].avatarUrl,
                size: 40,
                initials: visible[index].name.substring(0, 1),
                borderColor: Colors.white,
              ),
            ),
          if (remaining > 0)
            Positioned(
              left: visible.length * 26,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.darkButton,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$remaining',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({
    required this.imageUrl,
    required this.size,
    required this.initials,
    this.borderColor,
  });

  final String? imageUrl;
  final double size;
  final String initials;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      shape: BoxShape.circle,
      border: borderColor == null
          ? null
          : Border.all(color: borderColor!, width: 2),
      color: AppColors.subtleBackground,
    );

    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: decoration,
        alignment: Alignment.center,
        child: Text(
          initials.toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: decoration,
      clipBehavior: Clip.antiAlias,
      child: _NetworkOrFileImage(imageUrl: imageUrl!, fit: BoxFit.cover),
    );
  }
}

class _NetworkOrFileImage extends StatelessWidget {
  const _NetworkOrFileImage({required this.imageUrl, this.fit = BoxFit.cover});

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final fallback = DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFB8E8B2), Color(0xFFE9F7EE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.white, size: 28),
      ),
    );

    if (imageUrl.startsWith('/')) {
      return Image.file(
        File(imageUrl),
        fit: fit,
        errorBuilder: (_, _, _) => fallback,
      );
    }

    return Image.network(
      imageUrl,
      fit: fit,
      errorBuilder: (_, _, _) => fallback,
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }
        return fallback;
      },
    );
  }
}

class _HeroCircleButton extends StatelessWidget {
  const _HeroCircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.36),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class _BottomGlyphButton extends StatelessWidget {
  const _BottomGlyphButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.subtleBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 18, color: AppColors.textPrimary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.compact = false});

  final String title;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: compact
          ? Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 19)
          : Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      padding: padding,
      child: child,
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label, this.filled = false});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? AppColors.brandGreen : Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: filled ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _DetailLoadingState extends StatelessWidget {
  const _DetailLoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        _LoadingBlock(height: 360),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: <Widget>[
              _LoadingBlock(height: 34),
              SizedBox(height: 20),
              _LoadingBlock(height: 180),
              SizedBox(height: 20),
              _LoadingBlock(height: 96),
              SizedBox(height: 20),
              _LoadingBlock(height: 148),
              SizedBox(height: 20),
              _LoadingBlock(height: 320),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.subtleBackground,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _DetailErrorState extends StatelessWidget {
  const _DetailErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.travel_explore_rounded, size: 40),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brandGreen,
              ),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatLongDate(DateTime value) {
  return '${value.year}년 ${value.month.toString().padLeft(2, '0')}월 ${value.day.toString().padLeft(2, '0')}일';
}

String _formatReviewDate(DateTime value) {
  return '${value.year}년 ${value.month}월 ${value.day}일';
}

String _formatTimeRange(DateTime start, DateTime end) {
  return '${_formatPeriod(start)} ${_formatHourMinute(start)} ~ ${_formatHourMinute(end)}';
}

String _formatPeriod(DateTime value) => value.hour < 12 ? '오전' : '오후';

String _formatHourMinute(DateTime value) {
  final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
  return '${hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}

String _formatPrice(int price) {
  if (price == 0) {
    return '무료';
  }
  final digits = price.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index += 1) {
    final reverseIndex = digits.length - index;
    buffer.write(digits[index]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write(',');
    }
  }
  return '${buffer.toString()}원';
}
