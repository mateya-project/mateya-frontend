import 'package:flutter/foundation.dart';

import '../../onboarding/domain/onboarding_flow.dart';
import '../data/home_repository.dart';
import '../domain/home_models.dart';

class HomeController extends ChangeNotifier {
  HomeController({required this._repository, required this._flowKind});

  static const int pageSize = 10;

  final HomeRepository _repository;
  final FlowKind? _flowKind;

  AsyncPhase _phase = AsyncPhase.idle;
  HomeSection _section = HomeSection.home;
  ExploreFilter _filter = const ExploreFilter();
  String _searchQuery = '';
  List<ActivityItem> _activities = const <ActivityItem>[];
  int _currentPage = 1;
  String? _errorMessage;

  AsyncPhase get phase => _phase;
  HomeSection get section => _section;
  ExploreFilter get filter => _filter;
  String get searchQuery => _searchQuery;
  int get currentPage => _currentPage;
  FlowKind? get flowKind => _flowKind;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    if (_phase != AsyncPhase.idle) {
      return;
    }
    await _loadActivities();
  }

  Future<void> retry() => _loadActivities();

  void openHome() {
    _section = HomeSection.home;
    notifyListeners();
  }

  void openExplore({String? initialQuery}) {
    _section = HomeSection.explore;
    if (initialQuery != null) {
      _searchQuery = initialQuery;
    }
    _currentPage = 1;
    notifyListeners();
  }

  void openChat() {
    _section = HomeSection.chat;
    notifyListeners();
  }

  void openProfile() {
    _section = HomeSection.profile;
    notifyListeners();
  }

  void updateSearchQuery(String value) {
    if (_searchQuery == value) {
      return;
    }
    _searchQuery = value;
    _currentPage = 1;
    notifyListeners();
  }

  String? validateFilterDraft(ExploreFilter draft) {
    if (draft.categoryIds.isEmpty) {
      return '카테고리를 1개 이상 선택해 주세요.';
    }
    if (draft.languages.isEmpty) {
      return '언어를 1개 이상 선택해 주세요.';
    }
    if (draft.endDate != null &&
        draft.startDate != null &&
        draft.endDate!.isBefore(draft.startDate!)) {
      return '종료일은 시작일보다 빠를 수 없어요.';
    }
    if (draft.minPrice != null &&
        draft.maxPrice != null &&
        draft.maxPrice! < draft.minPrice!) {
      return '최대 금액은 최소 금액보다 크거나 같아야 해요.';
    }
    return null;
  }

  void applyFilter(ExploreFilter draft) {
    final validationMessage = validateFilterDraft(draft);
    if (validationMessage != null) {
      _phase = AsyncPhase.validationError;
      _errorMessage = validationMessage;
      notifyListeners();
      return;
    }
    _phase = AsyncPhase.success;
    _errorMessage = null;
    _filter = draft;
    _currentPage = 1;
    notifyListeners();
  }

  void resetFilters() {
    _filter = const ExploreFilter();
    _searchQuery = '';
    _currentPage = 1;
    _phase = AsyncPhase.success;
    _errorMessage = null;
    notifyListeners();
  }

  void goToPage(int page) {
    if (page < 1 || page > paginatedExplore.pageCount || page == _currentPage) {
      return;
    }
    _currentPage = page;
    notifyListeners();
  }

  String get plusActionLabel => switch (_flowKind) {
    FlowKind.host => '클래스 등록',
    FlowKind.guest || null => '모임 생성',
  };

  List<ActivityItem> get homePopularActivities {
    final items = List<ActivityItem>.from(_activities)
      ..sort((left, right) => right.rating.compareTo(left.rating));
    return items.where((item) => !item.isFeatured).take(3).toList();
  }

  ActivityItem? get featuredActivity {
    for (final item in _activities) {
      if (item.isFeatured) {
        return item;
      }
    }
    return _activities.isEmpty ? null : _activities.first;
  }

  List<ActivityItem> get filteredExploreActivities {
    final items = _activities
        .where((item) => item.matchesKeyword(_searchQuery))
        .where((item) => item.matchesFilter(_filter))
        .toList();

    items.sort((left, right) {
      return switch (_filter.sort) {
        ActivitySortOption.recommended => right.rating.compareTo(left.rating),
        ActivitySortOption.popular => right.participantCount.compareTo(
          left.participantCount,
        ),
        ActivitySortOption.latest => left.startAt.compareTo(right.startAt),
        ActivitySortOption.closingSoon => left.endAt.compareTo(right.endAt),
        ActivitySortOption.nearby => left.distanceKm.compareTo(
          right.distanceKm,
        ),
      };
    });
    return items;
  }

  PaginatedActivities get paginatedExplore {
    final filtered = filteredExploreActivities;
    final pageCount = filtered.isEmpty
        ? 1
        : (filtered.length / pageSize).ceil();
    final safePage = _currentPage.clamp(1, pageCount);
    final startIndex = (safePage - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, filtered.length);

    return PaginatedActivities(
      items: filtered.sublist(startIndex, endIndex),
      totalCount: filtered.length,
      currentPage: safePage,
      pageCount: pageCount,
    );
  }

  Future<void> _loadActivities() async {
    _phase = AsyncPhase.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _activities = await _repository.fetchActivities();
      _phase = AsyncPhase.success;
      _errorMessage = null;
    } on HomeRepositoryException catch (error) {
      _phase = error.type == HomeLoadFailureType.network
          ? AsyncPhase.networkError
          : AsyncPhase.serverError;
      _errorMessage = error.type == HomeLoadFailureType.network
          ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
          : '서버 응답이 지연되고 있어요. 잠시 후 다시 시도해 주세요.';
    } catch (_) {
      _phase = AsyncPhase.serverError;
      _errorMessage = '데이터를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
    }

    notifyListeners();
  }
}
