import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../shared/activity_categories/activity_category_repository.dart';
import '../../../../shared/auth/auth_session.dart';
import '../../../../shared/navigation/mateya_auth_flow.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_bottom_navigation.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../chat/application/chat_controller.dart';
import '../../../chat/data/chat_repository.dart';
import '../../../chat/presentation/screens/chat_flow_page.dart';
import '../../../create/application/create_controller.dart';
import '../../../create/data/create_repository.dart';
import '../../../create/domain/create_models.dart';
import '../../../create/presentation/screens/create_flow_page.dart';
import '../../../details/application/activity_detail_controller.dart';
import '../../../details/data/activity_detail_repository.dart';
import '../../../details/presentation/screens/activity_detail_page.dart';
import '../../../mypage/application/mypage_controller.dart';
import '../../../mypage/data/mypage_repository.dart';
import '../../../mypage/presentation/screens/mypage_flow_page.dart';
import '../../../onboarding/data/location_repository.dart';
import '../../../onboarding/domain/onboarding_flow.dart';
import '../../application/home_controller.dart';
import '../../application/nearby_culture_map_controller.dart';
import '../../data/home_repository.dart';
import '../../data/nearby_culture_map_repository.dart';
import '../../domain/home_models.dart';
import '../widgets/home_plus_action_overlay.dart';
import '../widgets/explore_filter_sheet.dart';
import '../widgets/home_content.dart';
import 'nearby_culture_map_page.dart';

class HomeFlowPage extends StatefulWidget {
  const HomeFlowPage({super.key, required this.flowKind, this.onBack});

  final FlowKind? flowKind;
  final VoidCallback? onBack;

  @override
  State<HomeFlowPage> createState() => _HomeFlowPageState();
}

class _HomeFlowPageState extends State<HomeFlowPage> {
  late final HomeController _controller;
  late final ChatController _chatController;
  late final MyPageController _myPageController;
  late final NearbyCultureMapController _nearbyCultureMapController;
  late final ActivityDetailRepository _activityDetailRepository;
  late final ActivityCategoryRepository _activityCategoryRepository;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isPlusOverlayOpen = false;
  bool _hasInitializedNearbyCultureMap = false;
  bool _isRedirectingToAuth = false;

  @override
  void initState() {
    super.initState();
    final hasSession = AuthSessionStore.instance.hasSession;
    _activityCategoryRepository = hasSession
        ? ApiActivityCategoryRepository()
        : MockActivityCategoryRepository();
    final defaultLanguage = AuthSessionStore
        .instance
        .session
        ?.user
        .primaryLanguage
        .toLowerCase();
    _controller = HomeController(
      repository: hasSession ? ApiHomeRepository() : MockHomeRepository(),
      categoryRepository: _activityCategoryRepository,
      flowKind: widget.flowKind,
      initialFilter: ExploreFilter(
        languages: kSupportedExploreLanguageCodes.contains(defaultLanguage)
            ? <String>{defaultLanguage!}
            : const <String>{'ko'},
      ),
    );
    _chatController = ChatController(
      repository: hasSession ? ApiChatRepository() : MockChatRepository(),
    );
    _myPageController = MyPageController(
      repository: hasSession ? ApiMyPageRepository() : MockMyPageRepository(),
      flowKind: widget.flowKind,
    );
    _activityDetailRepository = hasSession
        ? ApiActivityDetailRepository()
        : MockActivityDetailRepository();
    final sessionUser = AuthSessionStore.instance.session?.user;
    _nearbyCultureMapController = NearbyCultureMapController(
      repository: hasSession
          ? ApiNearbyCultureMapRepository()
          : MockNearbyCultureMapRepository(),
      categoryRepository: _activityCategoryRepository,
      locationRepository: DeviceNeighborhoodLocationRepository(),
      initialLocation:
          sessionUser?.activityLatitude != null &&
              sessionUser?.activityLongitude != null
          ? NeighborhoodSelection(
              displayName: sessionUser?.activityRegionName ?? '활동 지역',
              latitude: sessionUser!.activityLatitude!,
              longitude: sessionUser.activityLongitude!,
            )
          : null,
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
    _nearbyCultureMapController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openFilterSheet() async {
    final nextFilter = await showModalBottomSheet<ExploreFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ExploreFilterSheet(
          categories: _controller.availableCategories,
          initialFilter: _controller.filter,
          defaultFilter: _controller.defaultFilter,
          validator: _controller.validateFilterDraft,
          activityRegionName:
              AuthSessionStore.instance.session?.user.activityRegionName,
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
    _dismissPlusOverlay();
    final flowType = _controller.flowKind == FlowKind.host
        ? CreateFlowType.classRegistration
        : CreateFlowType.group;
    final hasSession = AuthSessionStore.instance.hasSession;
    if (!hasSession) {
      await _redirectToOnboardingIfNeeded();
      return;
    }
    final didCreate = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CreateFlowPage(
          controller: CreateController(
            repository: ApiCreateRepository(),
            categoryRepository: _activityCategoryRepository,
            flowType: flowType,
          ),
        ),
      ),
    );
    if (didCreate == true) {
      await Future.wait<void>(<Future<void>>[
        _controller.refreshAfterActivityMutation(),
        _chatController.retryRooms(),
        _myPageController.retry(),
      ]);
    }
  }

  Future<void> _openActivityDetail(ActivityItem activity) async {
    _dismissPlusOverlay();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ActivityDetailPage(
          controller: ActivityDetailController(
            repository: _activityDetailRepository,
            activity: activity,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthSessionStore.instance.hasSession) {
      unawaited(_redirectToOnboardingIfNeeded());
      return const Scaffold(body: SizedBox.shrink());
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            _syncSearchController();
            return Stack(
              children: <Widget>[
                Positioned.fill(child: _buildSectionBody()),
                if (_isPlusOverlayOpen)
                  Positioned.fill(
                    child: HomePlusActionOverlay(
                      createLabel: _controller.plusActionLabel,
                      onDismiss: _dismissPlusOverlay,
                      onCreateTap: _openCreateFlow,
                      onNearbyCultureTap: _openNearbyCultureMap,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _redirectToOnboardingIfNeeded() async {
    if (_isRedirectingToAuth || !mounted) {
      return;
    }
    _isRedirectingToAuth = true;
    await AuthSessionStore.instance.flush();
    if (!mounted) {
      return;
    }
    await replaceWithMateyaOnboardingFlow(context);
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

  Widget _buildSectionBody() {
    if (_controller.section == HomeSection.chat) {
      return ChatFlowPage(
        controller: _chatController,
        onBack: widget.onBack,
        onHomeTap: _openHomeTab,
        onExploreTap: _openExploreTab,
        onPlusTap: _togglePlusOverlay,
        onProfileTap: _openProfileTab,
      );
    }
    if (_controller.section == HomeSection.profile) {
      return Column(
        children: <Widget>[
          Expanded(child: MyPageFlowPage(controller: _myPageController)),
          MateyaBottomNavigation(
            currentTab: MateyaBottomTab.profile,
            plusActive: _isPlusOverlayOpen,
            onHomeTap: _openHomeTab,
            onExploreTap: _openExploreTab,
            onPlusTap: _togglePlusOverlay,
            onChatTap: _openChatTab,
            onProfileTap: _openProfileTab,
          ),
        ],
      );
    }
    return Column(
      children: <Widget>[
        switch (_controller.section) {
          HomeSection.favorites => MateyaHeader.backArrow(
            onBack: _controller.favoriteOriginSection == HomeSection.explore
                ? _openExploreTab
                : _openHomeTab,
          ),
          HomeSection.nearbyCultureMap => MateyaHeader.backArrow(
            onBack: _controller.closeNearbyCultureMap,
          ),
          _ => const MateyaHeader.noBackArrow(),
        },
        Expanded(
          child: Stack(
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: switch (_controller.section) {
                  HomeSection.home => HomeScreen(
                    key: const ValueKey<String>('home-screen'),
                    controller: _controller,
                    onSearchTap: _openExploreAndFocus,
                    onActivityTap: _openActivityDetail,
                  ),
                  HomeSection.explore => ExploreScreen(
                    key: const ValueKey<String>('explore-screen'),
                    controller: _controller,
                    searchController: _searchController,
                    searchFocusNode: _searchFocusNode,
                    onOpenFilter: _openFilterSheet,
                    onActivityTap: _openActivityDetail,
                  ),
                  HomeSection.favorites => FavoritesScreen(
                    key: const ValueKey<String>('favorites-screen'),
                    controller: _controller,
                    onActivityTap: _openActivityDetail,
                  ),
                  HomeSection.nearbyCultureMap => NearbyCultureMapPage(
                    key: const ValueKey<String>('nearby-culture-map-screen'),
                    controller: _nearbyCultureMapController,
                  ),
                  _ => const SizedBox.shrink(),
                },
              ),
              if (_controller.section == HomeSection.home ||
                  _controller.section == HomeSection.explore)
                Positioned(
                  right: 20,
                  bottom: 18,
                  child: GestureDetector(
                    onTap: _controller.openFavorites,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.brandGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        MateyaBottomNavigation(
          currentTab: switch (_controller.section) {
            HomeSection.home => MateyaBottomTab.home,
            HomeSection.explore => MateyaBottomTab.explore,
            HomeSection.favorites =>
              _controller.favoriteOriginSection == HomeSection.explore
                  ? MateyaBottomTab.explore
                  : MateyaBottomTab.home,
            HomeSection.nearbyCultureMap => null,
            _ => MateyaBottomTab.home,
          },
          plusActive: _isPlusOverlayOpen,
          onHomeTap: _openHomeTab,
          onExploreTap: _openExploreTab,
          onPlusTap: _togglePlusOverlay,
          onChatTap: _openChatTab,
          onProfileTap: _openProfileTab,
        ),
      ],
    );
  }

  void _togglePlusOverlay() {
    setState(() {
      _isPlusOverlayOpen = !_isPlusOverlayOpen;
    });
  }

  void _dismissPlusOverlay() {
    if (!_isPlusOverlayOpen) {
      return;
    }
    setState(() {
      _isPlusOverlayOpen = false;
    });
  }

  void _openHomeTab() {
    _dismissPlusOverlay();
    _controller.openHome();
  }

  void _openExploreTab() {
    _dismissPlusOverlay();
    _controller.openExplore();
  }

  void _openChatTab() {
    _dismissPlusOverlay();
    _controller.openChat();
  }

  void _openProfileTab() {
    _dismissPlusOverlay();
    _controller.openProfile();
    _myPageController.openRoot();
  }

  Future<void> _openNearbyCultureMap() async {
    _dismissPlusOverlay();
    _controller.openNearbyCultureMap();
    if (_hasInitializedNearbyCultureMap) {
      return;
    }
    _hasInitializedNearbyCultureMap = true;
    await _nearbyCultureMapController.initialize();
  }
}
