import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../details/application/activity_detail_controller.dart';
import '../../../details/data/activity_detail_repository.dart';
import '../../../details/presentation/screens/activity_detail_page.dart';
import '../../../chat/application/chat_controller.dart';
import '../../../chat/data/chat_repository.dart';
import '../../../chat/presentation/screens/chat_flow_page.dart';
import '../../../create/application/create_controller.dart';
import '../../../create/data/create_repository.dart';
import '../../../create/domain/create_models.dart';
import '../../../create/presentation/screens/create_flow_page.dart';
import '../../../mypage/application/mypage_controller.dart';
import '../../../mypage/data/mypage_repository.dart';
import '../../../mypage/presentation/screens/mypage_flow_page.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_bottom_navigation.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../onboarding/domain/onboarding_flow.dart';
import '../../application/home_controller.dart';
import '../../data/home_repository.dart';
import '../../domain/home_models.dart';

class HomeFlowPage extends StatefulWidget {
  const HomeFlowPage({super.key, required this.flowKind, required this.onBack});

  final FlowKind? flowKind;
  final VoidCallback onBack;

  @override
  State<HomeFlowPage> createState() => _HomeFlowPageState();
}

class _HomeFlowPageState extends State<HomeFlowPage> {
  late final HomeController _controller;
  late final ChatController _chatController;
  late final MyPageController _myPageController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = HomeController(
      repository: MockHomeRepository(),
      flowKind: widget.flowKind,
    );
    _chatController = ChatController(repository: MockChatRepository());
    _myPageController = MyPageController(
      repository: MockMyPageRepository(),
      flowKind: widget.flowKind,
    );
    _controller.initialize();
    _chatController.initialize();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _chatController.dispose();
    _myPageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openFilterSheet() async {
    final nextFilter = await showModalBottomSheet<ExploreFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _ExploreFilterSheet(
          initialFilter: _controller.filter,
          validator: _controller.validateFilterDraft,
        );
      },
    );
    if (!mounted || nextFilter == null) {
      return;
    }
    _controller.applyFilter(nextFilter);
  }

  void _openExploreAndFocus() {
    _controller.openExplore();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  Future<void> _openCreateFlow() async {
    final flowType = _controller.flowKind == FlowKind.host
        ? CreateFlowType.classRegistration
        : CreateFlowType.group;
    await Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (_) => CreateFlowPage(
          controller: CreateController(
            repository: MockCreateRepository(),
            flowType: flowType,
          ),
        ),
      ),
    );
  }

  Future<void> _openActivityDetail(ActivityItem activity) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ActivityDetailPage(
          controller: ActivityDetailController(
            repository: MockActivityDetailRepository(),
            activity: activity,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        _syncSearchController();
        if (_controller.section == HomeSection.chat) {
          return ChatFlowPage(
            controller: _chatController,
            onBack: widget.onBack,
            onHomeTap: _controller.openHome,
            onExploreTap: _controller.openExplore,
            onPlusTap: _openCreateFlow,
            onProfileTap: _controller.openProfile,
          );
        }
        if (_controller.section == HomeSection.profile) {
          return Column(
            children: <Widget>[
              Expanded(child: MyPageFlowPage(controller: _myPageController)),
              MateyaBottomNavigation(
                currentTab: MateyaBottomTab.profile,
                onHomeTap: _controller.openHome,
                onExploreTap: _controller.openExplore,
                onPlusTap: _openCreateFlow,
                onChatTap: _controller.openChat,
                onProfileTap: _controller.openProfile,
              ),
            ],
          );
        }
        return Column(
          children: <Widget>[
            _controller.section == HomeSection.home
                ? MateyaHeader.backArrow(onBack: widget.onBack)
                : const MateyaHeader.noBackArrow(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: _controller.section == HomeSection.home
                    ? _HomeScreen(
                        key: const ValueKey<String>('home-screen'),
                        controller: _controller,
                        onSearchTap: _openExploreAndFocus,
                        onActivityTap: _openActivityDetail,
                      )
                    : _ExploreScreen(
                        key: const ValueKey<String>('explore-screen'),
                        controller: _controller,
                        searchController: _searchController,
                        searchFocusNode: _searchFocusNode,
                        onOpenFilter: _openFilterSheet,
                        onActivityTap: _openActivityDetail,
                      ),
              ),
            ),
            MateyaBottomNavigation(
              currentTab: _controller.section == HomeSection.home
                  ? MateyaBottomTab.home
                  : MateyaBottomTab.explore,
              onHomeTap: _controller.openHome,
              onExploreTap: _controller.openExplore,
              onPlusTap: _openCreateFlow,
              onChatTap: _controller.openChat,
              onProfileTap: _controller.openProfile,
            ),
          ],
        );
      },
    );
  }

  void _syncSearchController() {
    if (_searchController.text == _controller.searchQuery) {
      return;
    }
    _searchController.value = TextEditingValue(
      text: _controller.searchQuery,
      selection: TextSelection.collapsed(
        offset: _controller.searchQuery.length,
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({
    super.key,
    required this.controller,
    required this.onSearchTap,
    required this.onActivityTap,
  });

  final HomeController controller;
  final VoidCallback onSearchTap;
  final ValueChanged<ActivityItem> onActivityTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 24),
          _SearchBar(
            readOnly: true,
            hintText: '언제든 어디서든',
            helperText: '누구와도 메이트가 되는 곳, 메이트야',
            onTap: onSearchTap,
            onFilterTap: onSearchTap,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _HomeContent(
              controller: controller,
              onActivityTap: onActivityTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.controller, required this.onActivityTap});

  final HomeController controller;
  final ValueChanged<ActivityItem> onActivityTap;

  @override
  Widget build(BuildContext context) {
    switch (controller.phase) {
      case AsyncPhase.loading:
      case AsyncPhase.idle:
        return const _HomeSkeleton();
      case AsyncPhase.networkError:
      case AsyncPhase.serverError:
        return _RetryState(
          message: controller.errorMessage ?? '데이터를 불러오지 못했어요.',
          onRetry: controller.retry,
        );
      case AsyncPhase.success:
      case AsyncPhase.validationError:
        final featured = controller.featuredActivity;
        final popular = controller.homePopularActivities;
        return ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: <Widget>[
            Text('인기 급상승 🔥', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            if (featured != null)
              _FeaturedActivityCard(
                activity: featured,
                onTap: () => onActivityTap(featured),
              ),
            const SizedBox(height: 24),
            Text(
              '함께할 수 있는 경험',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 23),
            for (final activity in popular) ...<Widget>[
              _VerticalActivityCard(
                activity: activity,
                onTap: () => onActivityTap(activity),
              ),
              const SizedBox(height: 32),
            ],
          ],
        );
    }
  }
}

class _ExploreScreen extends StatelessWidget {
  const _ExploreScreen({
    super.key,
    required this.controller,
    required this.searchController,
    required this.searchFocusNode,
    required this.onOpenFilter,
    required this.onActivityTap,
  });

  final HomeController controller;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback onOpenFilter;
  final ValueChanged<ActivityItem> onActivityTap;

  @override
  Widget build(BuildContext context) {
    final paginated = controller.paginatedExplore;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 24),
          _SearchBar(
            controller: searchController,
            focusNode: searchFocusNode,
            hintText: '이름, 장소를 검색해 보세요',
            helperText: '누구와도 메이트가 되는 곳, 메이트야',
            onChanged: controller.updateSearchQuery,
            onFilterTap: onOpenFilter,
          ),
          const SizedBox(height: 10),
          _ExploreCategoryStrip(
            selectedCategoryIds: controller.filter.categoryIds,
            onSelectCategory: (categoryId) {
              final current = Set<String>.from(controller.filter.categoryIds);
              if (categoryId == 'all') {
                controller.applyFilter(
                  controller.filter.copyWith(categoryIds: <String>{'all'}),
                );
                return;
              }
              current.remove('all');
              if (!current.add(categoryId)) {
                current.remove(categoryId);
              }
              if (current.isEmpty) {
                current.add('all');
              }
              controller.applyFilter(
                controller.filter.copyWith(categoryIds: current),
              );
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: switch (controller.phase) {
              AsyncPhase.loading || AsyncPhase.idle => const _ExploreSkeleton(),
              AsyncPhase.networkError || AsyncPhase.serverError => _RetryState(
                message: controller.errorMessage ?? '결과를 불러오지 못했어요.',
                onRetry: controller.retry,
              ),
              AsyncPhase.success || AsyncPhase.validationError =>
                paginated.items.isEmpty
                    ? const _EmptyState()
                    : Column(
                        children: <Widget>[
                          if (controller.phase == AsyncPhase.validationError &&
                              controller.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _InlineErrorText(
                                message: controller.errorMessage!,
                              ),
                            ),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.only(
                                top: 6,
                                bottom: 16,
                              ),
                              itemBuilder: (context, index) {
                                final activity = paginated.items[index];
                                return _CompactActivityRow(
                                  activity: activity,
                                  onTap: () => onActivityTap(activity),
                                );
                              },
                              separatorBuilder: (_, _) =>
                                  Divider(height: 32, color: AppColors.divider),
                              itemCount: paginated.items.length,
                            ),
                          ),
                          _PaginationBar(
                            currentPage: paginated.currentPage,
                            pageCount: paginated.pageCount,
                            totalCount: paginated.totalCount,
                            onPageSelected: controller.goToPage,
                          ),
                        ],
                      ),
            },
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    this.controller,
    this.focusNode,
    required this.hintText,
    required this.helperText,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    required this.onFilterTap,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final String helperText;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: IgnorePointer(
                    ignoring: readOnly,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          controller: controller,
                          focusNode: focusNode,
                          readOnly: readOnly,
                          onTap: onTap,
                          onChanged: onChanged,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hintText: hintText,
                            hintStyle: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textPrimary),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          helperText,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onFilterTap,
                  icon: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.subtleBackground,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: AppColors.textPrimary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedActivityCard extends StatelessWidget {
  const _FeaturedActivityCard({required this.activity, required this.onTap});

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
              _ActivityImage(
                imageUrl: activity.imageUrl,
                height: 338,
                borderRadius: const BorderRadius.all(Radius.circular(14)),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: _CategoryBadge(
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
                      '${_formatShortDate(activity.startAt)} ${_formatTimeRange(activity.startAt, activity.endAt)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      _formatPrice(activity.price),
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
                  _RatingLabel(rating: activity.rating),
                  const SizedBox(height: 70),
                  _ParticipantLabel(
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

class _VerticalActivityCard extends StatelessWidget {
  const _VerticalActivityCard({required this.activity, required this.onTap});

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
                _ActivityImage(
                  imageUrl: activity.imageUrl,
                  height: 239,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(13),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: _CategoryBadge(
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
                              _formatMonthDay(activity.startAt),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textMuted),
                            ),
                            const _DotDivider(),
                            Text(
                              _formatTimeRange(
                                activity.startAt,
                                activity.endAt,
                              ),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textMuted),
                            ),
                            Text(
                              _formatPrice(activity.price),
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
                      _RatingLabel(rating: activity.rating),
                      const SizedBox(height: 22),
                      _ParticipantLabel(
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

class _CompactActivityRow extends StatelessWidget {
  const _CompactActivityRow({required this.activity, required this.onTap});

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
              _ActivityImage(
                imageUrl: activity.imageUrl,
                width: 110,
                height: 110,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              Positioned(
                left: 8,
                bottom: 8,
                child: _CategoryBadge(
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
                      _RatingLabel(rating: activity.rating, compact: true),
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
                        _formatRelativeDate(activity.startAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const _DotDivider(),
                      Text(
                        _formatTimeRange(activity.startAt, activity.endAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: <Widget>[
                      _ParticipantLabel(
                        current: activity.participantCount,
                        capacity: activity.participantCapacity,
                        compact: true,
                      ),
                      const Spacer(),
                      _CategoryBadge(
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

class _ActivityImage extends StatelessWidget {
  const _ActivityImage({
    this.imageUrl,
    this.width,
    required this.height,
    required this.borderRadius,
  });

  final String? imageUrl;
  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFB8E8B2), Color(0xFFE9F7EE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.white, size: 34),
      ),
    );

    if (imageUrl == null) {
      return fallback;
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }
          return fallback;
        },
      ),
    );
  }
}

class _RatingLabel extends StatelessWidget {
  const _RatingLabel({required this.rating, this.compact = false});

  final double rating;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final style = compact
        ? Theme.of(context).textTheme.bodyMedium
        : Theme.of(context).textTheme.bodyLarge;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.star_rounded, color: AppColors.textPrimary, size: 18),
        const SizedBox(width: 4),
        Text(rating.toStringAsFixed(2), style: style),
      ],
    );
  }
}

class _ParticipantLabel extends StatelessWidget {
  const _ParticipantLabel({
    required this.current,
    required this.capacity,
    this.compact = false,
  });

  final int current;
  final int capacity;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final style = compact
        ? Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.brandGreen)
        : Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.brandGreen);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.groups_2_outlined,
          color: AppColors.brandGreen,
          size: compact ? 18 : 20,
        ),
        const SizedBox(width: 4),
        Text('$current/$capacity 참여', style: style),
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({
    required this.label,
    this.filled = false,
    this.small = false,
    this.compactOutline = false,
  });

  final String label;
  final bool filled;
  final bool small;
  final bool compactOutline;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = filled ? AppColors.brandGreen : Colors.white;
    final borderColor = compactOutline
        ? AppColors.softGreenBorder
        : filled
        ? AppColors.brandGreen
        : AppColors.divider;
    final textColor = filled ? Colors.white : AppColors.textPrimary;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compactOutline || small ? 8 : 12,
        vertical: small ? 4 : 8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _ExploreCategoryStrip extends StatelessWidget {
  const _ExploreCategoryStrip({
    required this.selectedCategoryIds,
    required this.onSelectCategory,
  });

  final Set<String> selectedCategoryIds;
  final ValueChanged<String> onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = kExploreCategories[index];
          final isSelected = category.isAll
              ? selectedCategoryIds.contains('all')
              : selectedCategoryIds.contains(category.id);
          return ChoiceChip(
            label: Text(category.label),
            selected: isSelected,
            onSelected: (_) => onSelectCategory(category.id),
            showCheckmark: false,
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
            selectedColor: AppColors.brandGreen,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected ? AppColors.brandGreen : AppColors.divider,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: kExploreCategories.length,
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.currentPage,
    required this.pageCount,
    required this.totalCount,
    required this.onPageSelected,
  });

  final int currentPage;
  final int pageCount;
  final int totalCount;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: <Widget>[
          Text(
            '$totalCount개 결과 중 $currentPage / $pageCount 페이지',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlinedButton(
                onPressed: currentPage > 1
                    ? () => onPageSelected(currentPage - 1)
                    : null,
                child: const Text('이전'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: currentPage < pageCount
                    ? () => onPageSelected(currentPage + 1)
                    : null,
                child: const Text('다음'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RetryState extends StatelessWidget {
  const _RetryState({required this.message, required this.onRetry});

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
            const Icon(Icons.wifi_tethering_error_rounded, size: 36),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.travel_explore_rounded,
              size: 44,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 12),
            Text(
              '조건에 맞는 활동이 아직 없어요.',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '검색어 또는 필터를 조정해서 다시 찾아보세요.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineErrorText extends StatelessWidget {
  const _InlineErrorText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.warning_amber_rounded,
          color: AppColors.error,
          size: 16,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: const <Widget>[
        _SkeletonBox(height: 34, width: 168),
        SizedBox(height: 16),
        _SkeletonBox(height: 470),
        SizedBox(height: 24),
        _SkeletonBox(height: 34, width: 220),
        SizedBox(height: 23),
        _SkeletonBox(height: 336),
        SizedBox(height: 32),
        _SkeletonBox(height: 336),
      ],
    );
  }
}

class _ExploreSkeleton extends StatelessWidget {
  const _ExploreSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 6, bottom: 16),
      children: const <Widget>[
        _SkeletonBox(height: 110),
        SizedBox(height: 24),
        _SkeletonBox(height: 110),
        SizedBox(height: 24),
        _SkeletonBox(height: 110),
        SizedBox(height: 24),
        _SkeletonBox(height: 110),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.height, this.width});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.subtleBackground,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _ExploreFilterSheet extends StatefulWidget {
  const _ExploreFilterSheet({
    required this.initialFilter,
    required this.validator,
  });

  final ExploreFilter initialFilter;
  final String? Function(ExploreFilter filter) validator;

  @override
  State<_ExploreFilterSheet> createState() => _ExploreFilterSheetState();
}

class _ExploreFilterSheetState extends State<_ExploreFilterSheet> {
  late ExploreFilter _draft;
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  bool _showMoreLanguages = false;
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialFilter;
    _minPriceController = TextEditingController(
      text: _draft.minPrice?.toString() ?? '',
    );
    _maxPriceController = TextEditingController(
      text: _draft.maxPrice?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Container(
      color: const Color(0x80000000),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                      Expanded(
                        child: Text(
                          '필터',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Divider(height: 1, color: AppColors.divider),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      16,
                      20,
                      20 + viewInsets.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _FilterSection(
                          title: '정렬',
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ActivitySortOption.values.map((option) {
                              return _FilterChip(
                                label: option.label,
                                selected: _draft.sort == option,
                                onTap: () {
                                  setState(() {
                                    _draft = _draft.copyWith(sort: option);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        _FilterSection(
                          title: '카테고리',
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: kExploreCategories.map((category) {
                              final selected = category.isAll
                                  ? _draft.categoryIds.contains('all')
                                  : _draft.categoryIds.contains(category.id);
                              return _FilterChip(
                                label: category.label,
                                selected: selected,
                                onTap: () => _toggleCategory(category),
                              );
                            }).toList(),
                          ),
                        ),
                        _FilterSection(
                          title: '참가대상',
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ActivityAudienceOption.values.map((
                              option,
                            ) {
                              return _FilterChip(
                                label: option.label,
                                selected: _draft.audiences.contains(option),
                                inverted:
                                    option != ActivityAudienceOption.everyone,
                                onTap: () => _toggleAudience(option),
                              );
                            }).toList(),
                          ),
                        ),
                        _FilterSection(
                          title: '언어',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children:
                                    <ActivityLanguageOption>[
                                      ...kPrimaryLanguages,
                                      if (_showMoreLanguages)
                                        ...kExtraLanguages,
                                    ].map((language) {
                                      return _CheckboxTag(
                                        label: language.label,
                                        selected: _draft.languages.contains(
                                          language.code,
                                        ),
                                        onTap: () =>
                                            _toggleLanguage(language.code),
                                      );
                                    }).toList(),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showMoreLanguages = !_showMoreLanguages;
                                  });
                                },
                                child: Text(
                                  _showMoreLanguages
                                      ? '언어 목록 접기'
                                      : '+ 24개 언어 더보기',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.brandGreen),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _FilterSection(
                          title: '지역',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '우만동과 근처 지역 34개',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: AppColors.brandGreen,
                                  inactiveTrackColor:
                                      AppColors.subtleBackground,
                                  thumbColor: Colors.white,
                                  overlayColor: AppColors.brandGreen.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                                child: Slider(
                                  value: _draft.distance.index.toDouble(),
                                  divisions:
                                      DistanceRangeOption.values.length - 1,
                                  max: 3,
                                  min: 0,
                                  onChanged: (value) {
                                    setState(() {
                                      _draft = _draft.copyWith(
                                        distance: DistanceRangeOption
                                            .values[value.round()],
                                      );
                                    });
                                  },
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '내 지역',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '먼 지역',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _FilterSection(
                          title: '일정',
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: _DateField(
                                  label: _draft.startDate == null
                                      ? '시작일'
                                      : _formatIsoDate(_draft.startDate!),
                                  onTap: () async {
                                    final selected = await _pickDate(
                                      _draft.startDate,
                                    );
                                    if (selected != null) {
                                      setState(() {
                                        _draft = _draft.copyWith(
                                          startDate: selected,
                                        );
                                      });
                                    }
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('-'),
                              ),
                              Expanded(
                                child: _DateField(
                                  label: _draft.endDate == null
                                      ? '종료일'
                                      : _formatIsoDate(_draft.endDate!),
                                  onTap: () async {
                                    final selected = await _pickDate(
                                      _draft.endDate,
                                    );
                                    if (selected != null) {
                                      setState(() {
                                        _draft = _draft.copyWith(
                                          endDate: selected,
                                        );
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        _FilterSection(
                          title: '비용',
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: _CompactNumberField(
                                  controller: _minPriceController,
                                  hintText: '최소금액',
                                  onChanged: (_) => _syncPriceDraft(),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('-'),
                              ),
                              Expanded(
                                child: _CompactNumberField(
                                  controller: _maxPriceController,
                                  hintText: '최대금액',
                                  onChanged: (_) => _syncPriceDraft(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _FilterSection(
                          title: '모집상태',
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ActivityStatusOption.values.map((status) {
                              return _FilterChip(
                                label: status.label,
                                selected: _draft.statuses.contains(status),
                                inverted: true,
                                onTap: () {
                                  final next = Set<ActivityStatusOption>.from(
                                    _draft.statuses,
                                  );
                                  if (!next.add(status)) {
                                    next.remove(status);
                                  }
                                  setState(() {
                                    _draft = _draft.copyWith(statuses: next);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(height: 1, color: AppColors.divider),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Column(
                    children: <Widget>[
                      if (_validationMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _InlineErrorText(message: _validationMessage!),
                        ),
                      Row(
                        children: <Widget>[
                          TextButton(
                            onPressed: _resetDraft,
                            child: const Text(
                              '초기화',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 175,
                            height: 54,
                            child: FilledButton(
                              onPressed: _applyAndClose,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.brandGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('적용하기'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate(DateTime? initialDate) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime(2026, 6, 4),
      firstDate: DateTime(2025),
      lastDate: DateTime(2027, 12, 31),
    );
  }

  void _toggleCategory(ActivityCategory category) {
    final next = Set<String>.from(_draft.categoryIds);
    if (category.isAll) {
      setState(() {
        _draft = _draft.copyWith(categoryIds: <String>{'all'});
      });
      return;
    }

    next.remove('all');
    if (!next.add(category.id)) {
      next.remove(category.id);
    }
    if (next.isEmpty) {
      next.add('all');
    }
    setState(() {
      _draft = _draft.copyWith(categoryIds: next);
    });
  }

  void _toggleAudience(ActivityAudienceOption option) {
    final next = Set<ActivityAudienceOption>.from(_draft.audiences);
    if (!next.add(option)) {
      next.remove(option);
    }
    if (next.isEmpty) {
      next.add(ActivityAudienceOption.everyone);
    }
    setState(() {
      _draft = _draft.copyWith(audiences: next);
    });
  }

  void _toggleLanguage(String code) {
    final next = Set<String>.from(_draft.languages);
    if (!next.add(code)) {
      next.remove(code);
    }
    setState(() {
      _draft = _draft.copyWith(languages: next);
    });
  }

  void _syncPriceDraft() {
    setState(() {
      _draft = _draft.copyWith(
        minPrice: _parseNumber(_minPriceController.text),
        maxPrice: _parseNumber(_maxPriceController.text),
      );
    });
  }

  void _resetDraft() {
    setState(() {
      _draft = const ExploreFilter();
      _validationMessage = null;
      _minPriceController.clear();
      _maxPriceController.clear();
      _showMoreLanguages = false;
    });
  }

  void _applyAndClose() {
    final message = widget.validator(_draft);
    if (message != null) {
      setState(() {
        _validationMessage = message;
      });
      return;
    }
    Navigator.of(context).pop(_draft);
  }

  int? _parseNumber(String value) {
    final normalized = value.replaceAll(',', '').trim();
    if (normalized.isEmpty) {
      return null;
    }
    return int.tryParse(normalized);
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.inverted = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected && !inverted
        ? AppColors.brandGreen
        : Colors.white;
    final borderColor = selected ? AppColors.brandGreen : AppColors.divider;
    final textColor = selected && !inverted
        ? Colors.white
        : AppColors.textPrimary;
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: textColor),
        ),
      ),
    );
  }
}

class _CheckboxTag extends StatelessWidget {
  const _CheckboxTag({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: selected ? AppColors.brandGreen : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: selected
                    ? AppColors.brandGreen
                    : AppColors.fieldBorderLight,
              ),
            ),
            child: selected
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.fieldBorderLight),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: label.contains('-')
                      ? AppColors.textMuted
                      : AppColors.textSecondary,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactNumberField extends StatelessWidget {
  const _CompactNumberField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.fieldBorderLight),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.fieldBorderLight,
                ),
              ),
            ),
          ),
          Text(
            '원',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _DotDivider extends StatelessWidget {
  const _DotDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: const BoxDecoration(
        color: AppColors.textMuted,
        shape: BoxShape.circle,
      ),
    );
  }
}

String _formatPrice(int price) {
  if (price == 0) {
    return 'FREE';
  }
  final digits = price.toString();
  final buffer = StringBuffer('₩ ');
  for (var index = 0; index < digits.length; index += 1) {
    final reverseIndex = digits.length - index;
    buffer.write(digits[index]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}

String _formatShortDate(DateTime dateTime) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[dateTime.month - 1]} ${dateTime.day}';
}

String _formatMonthDay(DateTime dateTime) => _formatShortDate(dateTime);

String _formatRelativeDate(DateTime dateTime) {
  final now = DateTime(2026, 6, 13);
  final target = DateTime(dateTime.year, dateTime.month, dateTime.day);
  final difference = target.difference(now).inDays;
  return switch (difference) {
    0 => '오늘',
    1 => '내일',
    _ => _formatMonthDay(dateTime),
  };
}

String _formatTimeRange(DateTime start, DateTime end) {
  return '${_formatKoreanTime(start)} - ${_formatKoreanTime(end)}';
}

String _formatKoreanTime(DateTime dateTime) {
  final period = dateTime.hour >= 12 ? '오후' : '오전';
  final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$period $hour:$minute';
}

String _formatIsoDate(DateTime dateTime) {
  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');
  return '${dateTime.year}-$month-$day';
}
