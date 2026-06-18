import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../shared/activity_categories/activity_category_repository.dart';
import '../../../../shared/auth/auth_session.dart';
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
import '../../../onboarding/domain/onboarding_flow.dart';
import '../../application/home_controller.dart';
import '../../data/home_repository.dart';
import '../../domain/home_models.dart';
import '../widgets/explore_filter_sheet.dart';
import '../widgets/home_content.dart';

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
  late final ActivityDetailRepository _activityDetailRepository;
  late final ActivityCategoryRepository _activityCategoryRepository;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

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
        return ExploreFilterSheet(
          categories: _controller.availableCategories,
          initialFilter: _controller.filter,
          defaultFilter: _controller.defaultFilter,
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
    final hasSession = AuthSessionStore.instance.hasSession;
    await Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (_) => CreateFlowPage(
          controller: CreateController(
            repository: hasSession
                ? ApiCreateRepository()
                : MockCreateRepository(),
            categoryRepository: _activityCategoryRepository,
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
            repository: _activityDetailRepository,
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
            onProfileTap: () {
              _controller.openProfile();
              _myPageController.openRoot();
            },
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
                onProfileTap: () {
                  _controller.openProfile();
                  _myPageController.openRoot();
                },
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
                        onBack:
                            _controller.favoriteOriginSection ==
                                HomeSection.explore
                            ? _controller.openExplore
                            : _controller.openHome,
                        onActivityTap: _openActivityDetail,
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
                _ => MateyaBottomTab.home,
              },
              onHomeTap: _controller.openHome,
              onExploreTap: _controller.openExplore,
              onPlusTap: _openCreateFlow,
              onChatTap: _controller.openChat,
              onProfileTap: () {
                _controller.openProfile();
                _myPageController.openRoot();
              },
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
