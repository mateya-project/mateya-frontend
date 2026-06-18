import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../onboarding/domain/onboarding_flow.dart';
import '../data/home_repository.dart';
import '../domain/home_models.dart';

class HomeController extends ChangeNotifier {
  HomeController({
    required this._repository,
    required this._flowKind,
    ExploreFilter? initialFilter,
    this.searchDebounceDuration = const Duration(milliseconds: 350),
  }) : _filter = initialFilter ?? const ExploreFilter(),
       _defaultFilter = initialFilter ?? const ExploreFilter();

  final HomeRepository _repository;
  final FlowKind? _flowKind;
  final ExploreFilter _defaultFilter;
  final Duration searchDebounceDuration;

  AsyncPhase _homePhase = AsyncPhase.idle;
  AsyncPhase _explorePhase = AsyncPhase.idle;
  HomeSection _section = HomeSection.home;
  HomeSection _favoriteOriginSection = HomeSection.home;
  ExploreFilter _filter;
  String _searchQuery = '';
  List<ActivityItem> _homeActivities = const <ActivityItem>[];
  List<ActivityItem> _exploreActivities = const <ActivityItem>[];
  bool _hasLoadedExplore = false;
  bool _hasNextExplore = false;
  bool _isLoadingMoreExplore = false;
  int? _nextExplorePage;
  String? _homeErrorMessage;
  String? _exploreErrorMessage;
  String? _exploreLoadMoreErrorMessage;
  Timer? _searchDebounce;
  int _exploreRequestVersion = 0;

  AsyncPhase get phase => _homePhase;
  AsyncPhase get homePhase => _homePhase;
  AsyncPhase get explorePhase => _explorePhase;
  HomeSection get section => _section;
  HomeSection get favoriteOriginSection => _favoriteOriginSection;
  ExploreFilter get filter => _filter;
  ExploreFilter get defaultFilter => _defaultFilter;
  String get searchQuery => _searchQuery;
  FlowKind? get flowKind => _flowKind;
  String? get errorMessage => _homeErrorMessage;
  String? get homeErrorMessage => _homeErrorMessage;
  String? get exploreErrorMessage => _exploreErrorMessage;
  String? get exploreLoadMoreErrorMessage => _exploreLoadMoreErrorMessage;
  List<ActivityItem> get exploreActivities => _exploreActivities;
  List<ActivityItem> get favoriteActivities {
    final ordered = <String, ActivityItem>{};
    for (final activity in <ActivityItem>[
      ..._homeActivities.where((item) => item.isFeatured),
      ..._homeActivities.take(2),
      ..._exploreActivities.take(4),
    ]) {
      ordered.putIfAbsent(activity.id, () => activity);
    }
    return ordered.values.take(6).toList(growable: false);
  }

  bool get hasLoadedExplore => _hasLoadedExplore;
  bool get hasMoreExplore => _hasNextExplore;
  bool get isLoadingMoreExplore => _isLoadingMoreExplore;

  Future<void> initialize() async {
    if (_homePhase != AsyncPhase.idle) {
      return;
    }
    await _loadHomeActivities();
  }

  Future<void> retry() {
    return switch (_section) {
      HomeSection.explore => refreshExplore(),
      _ => _loadHomeActivities(),
    };
  }

  void openHome() {
    _section = HomeSection.home;
    notifyListeners();
  }

  void openExplore({String? initialQuery}) {
    final queryChanged =
        initialQuery != null && initialQuery.trim() != _searchQuery;
    _section = HomeSection.explore;
    if (initialQuery != null) {
      _searchQuery = initialQuery.trim();
    }
    notifyListeners();
    unawaited(
      ensureExploreLoaded(forceRefresh: queryChanged || !_hasLoadedExplore),
    );
  }

  void openChat() {
    _section = HomeSection.chat;
    notifyListeners();
  }

  void openFavorites() {
    if (_section == HomeSection.home || _section == HomeSection.explore) {
      _favoriteOriginSection = _section;
    }
    _section = HomeSection.favorites;
    notifyListeners();
    if (!_hasLoadedExplore) {
      unawaited(ensureExploreLoaded());
    }
  }

  void openProfile() {
    _section = HomeSection.profile;
    notifyListeners();
  }

  void updateSearchQuery(String value) {
    final normalized = value.trim();
    if (_searchQuery == normalized) {
      return;
    }
    _searchQuery = normalized;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(searchDebounceDuration, () {
      unawaited(refreshExplore());
    });
    notifyListeners();
  }

  String? validateFilterDraft(ExploreFilter draft) {
    if (draft.categoryIds.isEmpty) {
      return '카테고리를 1개 이상 선택해 주세요.';
    }
    if (draft.languages.isEmpty) {
      return '언어를 1개 이상 선택해 주세요.';
    }
    if (draft.languages.any(
      (code) => !kSupportedExploreLanguageCodes.contains(code),
    )) {
      return '둘러보기 언어 필터는 한국어, 영어, 중국어, 일본어만 지원합니다.';
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
      _explorePhase = AsyncPhase.validationError;
      _exploreErrorMessage = validationMessage;
      notifyListeners();
      return;
    }
    _filter = draft;
    _explorePhase = AsyncPhase.success;
    _exploreErrorMessage = null;
    notifyListeners();
    unawaited(refreshExplore());
  }

  void resetFilters() {
    _filter = _defaultFilter;
    _searchQuery = '';
    _explorePhase = AsyncPhase.success;
    _exploreErrorMessage = null;
    notifyListeners();
    unawaited(refreshExplore());
  }

  Future<void> ensureExploreLoaded({bool forceRefresh = false}) async {
    if (_hasLoadedExplore && !forceRefresh) {
      return;
    }
    await refreshExplore();
  }

  Future<void> refreshExplore() async {
    final validationMessage = validateFilterDraft(_filter);
    if (validationMessage != null) {
      _explorePhase = AsyncPhase.validationError;
      _exploreErrorMessage = validationMessage;
      notifyListeners();
      return;
    }

    _searchDebounce?.cancel();
    final requestVersion = ++_exploreRequestVersion;
    _explorePhase = AsyncPhase.loading;
    _exploreErrorMessage = null;
    _exploreLoadMoreErrorMessage = null;
    _isLoadingMoreExplore = false;
    _hasNextExplore = false;
    _nextExplorePage = null;
    notifyListeners();

    try {
      final page = await _repository.fetchExploreActivities(
        page: 0,
        keyword: _searchQuery,
        filter: _filter,
      );
      if (requestVersion != _exploreRequestVersion) {
        return;
      }

      _exploreActivities = page.items;
      _hasLoadedExplore = true;
      _hasNextExplore = page.hasNext;
      _nextExplorePage = page.nextPage;
      _explorePhase = AsyncPhase.success;
      _exploreErrorMessage = null;
    } on HomeRepositoryException catch (error) {
      if (requestVersion != _exploreRequestVersion) {
        return;
      }

      _explorePhase = error.type == HomeLoadFailureType.network
          ? AsyncPhase.networkError
          : AsyncPhase.serverError;
      _exploreErrorMessage = error.type == HomeLoadFailureType.network
          ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
          : '서버 응답이 지연되고 있어요. 잠시 후 다시 시도해 주세요.';
    } catch (_) {
      if (requestVersion != _exploreRequestVersion) {
        return;
      }

      _explorePhase = AsyncPhase.serverError;
      _exploreErrorMessage = '결과를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
    }

    notifyListeners();
  }

  Future<void> loadMoreExplore() async {
    if (_explorePhase != AsyncPhase.success ||
        !_hasNextExplore ||
        _isLoadingMoreExplore ||
        _nextExplorePage == null) {
      return;
    }

    final requestVersion = _exploreRequestVersion;
    final nextPage = _nextExplorePage!;
    _isLoadingMoreExplore = true;
    _exploreLoadMoreErrorMessage = null;
    notifyListeners();

    try {
      final page = await _repository.fetchExploreActivities(
        page: nextPage,
        keyword: _searchQuery,
        filter: _filter,
      );
      if (requestVersion != _exploreRequestVersion) {
        return;
      }

      final merged = <String, ActivityItem>{
        for (final item in _exploreActivities) item.id: item,
      };
      for (final item in page.items) {
        merged[item.id] = item;
      }
      _exploreActivities = merged.values.toList(growable: false);
      _hasNextExplore = page.hasNext;
      _nextExplorePage = page.nextPage;
      _isLoadingMoreExplore = false;
      _exploreLoadMoreErrorMessage = null;
    } on HomeRepositoryException catch (error) {
      if (requestVersion != _exploreRequestVersion) {
        return;
      }

      _isLoadingMoreExplore = false;
      _exploreLoadMoreErrorMessage = error.type == HomeLoadFailureType.network
          ? '추가 결과를 불러오지 못했어요. 네트워크를 확인해 주세요.'
          : '추가 결과를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
    } catch (_) {
      if (requestVersion != _exploreRequestVersion) {
        return;
      }

      _isLoadingMoreExplore = false;
      _exploreLoadMoreErrorMessage = '추가 결과를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
    }

    notifyListeners();
  }

  String get plusActionLabel => switch (_flowKind) {
    FlowKind.host => '클래스 등록',
    FlowKind.guest || null => '모임 생성',
  };

  List<ActivityItem> get homePopularActivities {
    final items = List<ActivityItem>.from(_homeActivities)
      ..sort((left, right) => right.rating.compareTo(left.rating));
    return items.where((item) => !item.isFeatured).take(3).toList();
  }

  ActivityItem? get featuredActivity {
    for (final item in _homeActivities) {
      if (item.isFeatured) {
        return item;
      }
    }
    return _homeActivities.isEmpty ? null : _homeActivities.first;
  }

  Future<void> _loadHomeActivities() async {
    _homePhase = AsyncPhase.loading;
    _homeErrorMessage = null;
    notifyListeners();

    try {
      _homeActivities = await _repository.fetchHomeActivities();
      _homePhase = AsyncPhase.success;
      _homeErrorMessage = null;
    } on HomeRepositoryException catch (error) {
      _homePhase = error.type == HomeLoadFailureType.network
          ? AsyncPhase.networkError
          : AsyncPhase.serverError;
      _homeErrorMessage = error.type == HomeLoadFailureType.network
          ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
          : '서버 응답이 지연되고 있어요. 잠시 후 다시 시도해 주세요.';
    } catch (_) {
      _homePhase = AsyncPhase.serverError;
      _homeErrorMessage = '데이터를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
