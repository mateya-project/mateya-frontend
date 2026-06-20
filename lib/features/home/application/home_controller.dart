import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../shared/activity_categories/activity_category_repository.dart';
import '../../../shared/localization/mateya_localizations.dart';
import '../../onboarding/domain/onboarding_flow.dart';
import '../data/home_repository.dart';
import '../domain/home_models.dart';

class HomeController extends ChangeNotifier {
  HomeController({
    required this._repository,
    required this.categoryRepository,
    required this._flowKind,
    ExploreFilter? initialFilter,
    this.searchDebounceDuration = const Duration(milliseconds: 350),
  }) : _filter = initialFilter ?? const ExploreFilter(),
       _defaultFilter = initialFilter ?? const ExploreFilter();

  final HomeRepository _repository;
  final ActivityCategoryRepository categoryRepository;
  final FlowKind? _flowKind;
  final ExploreFilter _defaultFilter;
  final Duration searchDebounceDuration;

  AsyncPhase _homePhase = AsyncPhase.idle;
  AsyncPhase _explorePhase = AsyncPhase.idle;
  AsyncPhase _favoritePhase = AsyncPhase.idle;
  HomeSection _section = HomeSection.home;
  HomeSection _favoriteOriginSection = HomeSection.home;
  HomeSection _nearbyCultureMapOriginSection = HomeSection.home;
  ExploreFilter _filter;
  String _searchQuery = '';
  List<ActivityItem> _homeActivities = const <ActivityItem>[];
  List<ActivityItem> _exploreActivities = const <ActivityItem>[];
  List<ActivityItem> _favoriteActivities = const <ActivityItem>[];
  List<ActivityCategoryMetadata> _categoryMetadata =
      kFallbackActivityCategories;
  bool _hasLoadedExplore = false;
  bool _hasLoadedFavorites = false;
  bool _hasNextExplore = false;
  bool _isLoadingMoreExplore = false;
  int? _nextExplorePage;
  String? _homeErrorMessage;
  String? _exploreErrorMessage;
  String? _favoriteErrorMessage;
  String? _exploreLoadMoreErrorMessage;
  Timer? _searchDebounce;
  int _exploreRequestVersion = 0;

  AsyncPhase get phase => _homePhase;
  AsyncPhase get homePhase => _homePhase;
  AsyncPhase get explorePhase => _explorePhase;
  AsyncPhase get favoritePhase => _favoritePhase;
  HomeSection get section => _section;
  HomeSection get favoriteOriginSection => _favoriteOriginSection;
  HomeSection get nearbyCultureMapOriginSection =>
      _nearbyCultureMapOriginSection;
  ExploreFilter get filter => _filter;
  ExploreFilter get defaultFilter => _defaultFilter;
  String get searchQuery => _searchQuery;
  FlowKind? get flowKind => _flowKind;
  String? get errorMessage => _homeErrorMessage;
  String? get homeErrorMessage => _homeErrorMessage;
  String? get exploreErrorMessage => _exploreErrorMessage;
  String? get favoriteErrorMessage => _favoriteErrorMessage;
  String? get exploreLoadMoreErrorMessage => _exploreLoadMoreErrorMessage;
  List<ActivityItem> get exploreActivities => _exploreActivities;
  List<ActivityItem> get favoriteActivities => _favoriteActivities;
  List<ActivityCategory> get availableCategories => <ActivityCategory>[
    ActivityCategory(
      id: 'all',
      label: MateyaLocalizations.current.commonAll,
      isAll: true,
    ),
    ..._categoryMetadata
        .where((category) => category.active)
        .map(
          (category) =>
              ActivityCategory(id: category.code, label: category.label),
        ),
  ];

  bool get hasLoadedExplore => _hasLoadedExplore;
  bool get hasLoadedFavorites => _hasLoadedFavorites;
  bool get hasMoreExplore => _hasNextExplore;
  bool get isLoadingMoreExplore => _isLoadingMoreExplore;

  Future<void> initialize() async {
    if (_homePhase != AsyncPhase.idle) {
      return;
    }
    await Future.wait<void>(<Future<void>>[
      _loadCategoryMetadata(),
      _loadHomeActivities(),
    ]);
  }

  Future<void> retry() {
    return switch (_section) {
      HomeSection.explore => refreshExplore(),
      HomeSection.favorites => _loadFavoriteActivities(),
      _ => _loadHomeActivities(),
    };
  }

  Future<void> refreshAfterActivityMutation() async {
    final tasks = <Future<void>>[_loadHomeActivities()];

    if (_section == HomeSection.explore || _hasLoadedExplore) {
      tasks.add(refreshExplore());
    }
    if (_section == HomeSection.favorites || _hasLoadedFavorites) {
      tasks.add(_loadFavoriteActivities());
    }

    await Future.wait<void>(tasks);
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

  void openNearbyCultureMap() {
    _nearbyCultureMapOriginSection = _section;
    _section = HomeSection.nearbyCultureMap;
    notifyListeners();
  }

  void closeNearbyCultureMap() {
    _section = _nearbyCultureMapOriginSection;
    notifyListeners();
  }

  void openFavorites() {
    if (_section == HomeSection.home || _section == HomeSection.explore) {
      _favoriteOriginSection = _section;
    }
    _section = HomeSection.favorites;
    notifyListeners();
    if (!_hasLoadedFavorites) {
      unawaited(_loadFavoriteActivities());
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
    final l10n = MateyaLocalizations.current;
    if (draft.categoryIds.isEmpty) {
      return l10n.homeSelectAtLeastOneCategory;
    }
    if (draft.languages.isEmpty) {
      return l10n.homeSelectAtLeastOneLanguage;
    }
    if (draft.languages.any(
      (code) => !kSupportedExploreLanguageCodes.contains(code),
    )) {
      return l10n.homeUnsupportedExploreLanguageFilter;
    }
    if (draft.endDate != null &&
        draft.startDate != null &&
        draft.endDate!.isBefore(draft.startDate!)) {
      return l10n.homeEndDateBeforeStartDateError;
    }
    if (draft.minPrice != null &&
        draft.maxPrice != null &&
        draft.maxPrice! < draft.minPrice!) {
      return l10n.homeMaxPriceLessThanMinPriceError;
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
    final l10n = MateyaLocalizations.current;
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
          ? l10n.commonNetworkRetry
          : l10n.homeExploreError;
    } catch (_) {
      if (requestVersion != _exploreRequestVersion) {
        return;
      }

      _explorePhase = AsyncPhase.serverError;
      _exploreErrorMessage = l10n.homeExploreError;
    }

    notifyListeners();
  }

  Future<void> loadMoreExplore() async {
    final l10n = MateyaLocalizations.current;
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
          ? l10n.homeExploreLoadMoreFailedNetwork
          : l10n.homeExploreLoadMoreFailedServer;
    } catch (_) {
      if (requestVersion != _exploreRequestVersion) {
        return;
      }

      _isLoadingMoreExplore = false;
      _exploreLoadMoreErrorMessage = l10n.homeExploreLoadMoreFailedServer;
    }

    notifyListeners();
  }

  String get plusActionLabel => switch (_flowKind) {
    FlowKind.host => MateyaLocalizations.current.homeCreateClass,
    FlowKind.guest || null => MateyaLocalizations.current.homeCreateGroup,
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
    final l10n = MateyaLocalizations.current;
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
          ? l10n.commonNetworkRetry
          : l10n.homeLoadError;
    } catch (_) {
      _homePhase = AsyncPhase.serverError;
      _homeErrorMessage = l10n.homeLoadError;
    }

    notifyListeners();
  }

  Future<void> _loadFavoriteActivities() async {
    final l10n = MateyaLocalizations.current;
    _favoritePhase = AsyncPhase.loading;
    _favoriteErrorMessage = null;
    notifyListeners();

    try {
      _favoriteActivities = await _repository.fetchFavoriteActivities();
      _favoritePhase = AsyncPhase.success;
      _favoriteErrorMessage = null;
      _hasLoadedFavorites = true;
    } on HomeRepositoryException catch (error) {
      _favoritePhase = error.type == HomeLoadFailureType.network
          ? AsyncPhase.networkError
          : AsyncPhase.serverError;
      _favoriteErrorMessage = error.type == HomeLoadFailureType.network
          ? l10n.commonNetworkRetry
          : l10n.homeFavoritesLoadError;
    } catch (_) {
      _favoritePhase = AsyncPhase.serverError;
      _favoriteErrorMessage = l10n.homeFavoritesLoadError;
    }

    notifyListeners();
  }

  Future<void> _loadCategoryMetadata() async {
    final categories = await categoryRepository.fetchActivityCategories();
    _categoryMetadata = List<ActivityCategoryMetadata>.from(categories)
      ..sort((left, right) => left.displayOrder.compareTo(right.displayOrder));
    _reconcileFilterCategories();
    notifyListeners();
  }

  void _reconcileFilterCategories() {
    final validIds = availableCategories
        .where((category) => !category.isAll)
        .map((category) => category.id)
        .toSet();
    final normalized = _filter.categoryIds
        .where(
          (categoryId) => categoryId == 'all' || validIds.contains(categoryId),
        )
        .toSet();
    if (normalized.isEmpty) {
      normalized.add('all');
    }
    if (!setEquals(normalized, _filter.categoryIds)) {
      _filter = _filter.copyWith(categoryIds: normalized);
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
