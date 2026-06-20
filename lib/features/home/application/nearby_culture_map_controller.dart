import 'package:flutter/foundation.dart';

import '../../../shared/activity_categories/activity_category_repository.dart';
import '../../../shared/localization/mateya_localizations.dart';
import '../../../shared/logging/app_logger.dart';
import '../../onboarding/data/location_repository.dart';
import '../../onboarding/domain/onboarding_flow.dart';
import '../data/nearby_culture_map_repository.dart';
import '../domain/nearby_culture_map_models.dart';

class NearbyCultureMapController extends ChangeNotifier {
  NearbyCultureMapController({
    required this.repository,
    required this.categoryRepository,
    required this.locationRepository,
    this.initialLocation,
    this.defaultCategoryCode = 'CULTURE_TRADITION',
    this.defaultRadiusKm = 10,
    AppLogger? logger,
  }) : _loggerOverride = logger;

  final NearbyCultureMapRepository repository;
  final ActivityCategoryRepository categoryRepository;
  final NeighborhoodLocationRepository locationRepository;
  final NeighborhoodSelection? initialLocation;
  final String defaultCategoryCode;
  final int defaultRadiusKm;
  final AppLogger? _loggerOverride;
  AppLogger get _logger => _loggerOverride ?? AppLogger.instance;

  AsyncPhase _phase = AsyncPhase.idle;
  List<ActivityCategoryMetadata> _categories = kFallbackActivityCategories;
  String _keyword = '';
  String _selectedCategoryCode = 'CULTURE_TRADITION';
  String? _selectedCategoryDetailCode;
  NeighborhoodSelection? _currentLocation;
  List<NearbyCultureMapPlace> _places = const <NearbyCultureMapPlace>[];
  NearbyCultureMapPlace? _selectedPlace;
  String? _errorMessage;
  bool _initialized = false;

  AsyncPhase get phase => _phase;
  List<ActivityCategoryMetadata> get categories => _categories;
  String get keyword => _keyword;
  String get selectedCategoryCode => _selectedCategoryCode;
  String? get selectedCategoryDetailCode => _selectedCategoryDetailCode;
  NeighborhoodSelection? get currentLocation => _currentLocation;
  List<NearbyCultureMapPlace> get places => _places;
  NearbyCultureMapPlace? get selectedPlace => _selectedPlace;
  String? get errorMessage => _errorMessage;
  bool get hasData => _places.isNotEmpty || _currentLocation != null;
  int get selectedPlaceIndex {
    final selectedId = _selectedPlace?.id;
    if (selectedId == null) {
      return -1;
    }
    return _places.indexWhere((place) => place.id == selectedId);
  }

  List<ActivityCategoryDetailMetadata> get availableCategoryDetails {
    final selectedCategory = _categories.where((category) {
      return category.active && category.code == _selectedCategoryCode;
    }).firstOrNull;
    return selectedCategory?.activeChildren ??
        const <ActivityCategoryDetailMetadata>[];
  }

  Future<void> initialize() async {
    final l10n = MateyaLocalizations.current;
    if (_initialized) {
      return;
    }
    _logger.info('Initializing nearby culture map');
    _initialized = true;
    _phase = AsyncPhase.loading;
    notifyListeners();

    _categories = (await categoryRepository.fetchActivityCategories())
        .where((category) => category.active)
        .toList(growable: false);
    _selectedCategoryCode =
        _categories.any((category) => category.code == defaultCategoryCode)
        ? defaultCategoryCode
        : (_categories.firstOrNull?.code ?? defaultCategoryCode);

    if (initialLocation != null) {
      _logger.info(
        'Nearby culture map will use initial location',
        context: <String, Object?>{'district': initialLocation?.displayName},
      );
      _currentLocation = initialLocation;
      await _loadPlaces();
      return;
    }

    final resolved = await locationRepository.resolveCurrentNeighborhood();
    if (!resolved.isSuccess || resolved.selection == null) {
      _logger.warning(
        'Nearby culture map failed to resolve current location',
        context: <String, Object?>{
          'failureType': resolved.failure?.type.name,
          'message': resolved.failure?.message,
        },
      );
      _phase = AsyncPhase.validationError;
      _errorMessage =
          resolved.failure?.message ?? l10n.homeNearbyMapLocationLoadError;
      notifyListeners();
      return;
    }

    _logger.info(
      'Nearby culture map resolved current location',
      context: <String, Object?>{'district': resolved.selection?.displayName},
    );
    _currentLocation = resolved.selection;
    await _loadPlaces();
  }

  void updateKeyword(String value) {
    _keyword = value;
    notifyListeners();
  }

  Future<void> search() => _loadPlaces();

  Future<void> selectCategory(String categoryCode) async {
    if (_selectedCategoryCode == categoryCode) {
      return;
    }
    _selectedCategoryCode = categoryCode;
    _selectedCategoryDetailCode = null;
    notifyListeners();
    await _loadPlaces();
  }

  Future<void> selectCategoryDetail(String? categoryDetailCode) async {
    if (_selectedCategoryDetailCode == categoryDetailCode) {
      return;
    }
    _selectedCategoryDetailCode = categoryDetailCode;
    notifyListeners();
    await _loadPlaces();
  }

  void selectPlace(String placeId) {
    final nextPlace = _places.where((place) => place.id == placeId).firstOrNull;
    if (nextPlace == null || _selectedPlace?.id == nextPlace.id) {
      return;
    }
    _selectedPlace = nextPlace;
    notifyListeners();
  }

  void selectPlaceAt(int index) {
    if (index < 0 || index >= _places.length) {
      return;
    }
    selectPlace(_places[index].id);
  }

  Future<void> refreshCurrentLocation() async {
    final l10n = MateyaLocalizations.current;
    _logger.info('Refreshing nearby culture map current location');
    final resolved = await locationRepository.resolveCurrentNeighborhood();
    if (!resolved.isSuccess || resolved.selection == null) {
      _logger.warning(
        'Nearby culture map failed to refresh current location',
        context: <String, Object?>{
          'failureType': resolved.failure?.type.name,
          'message': resolved.failure?.message,
        },
      );
      _phase = AsyncPhase.validationError;
      _errorMessage =
          resolved.failure?.message ?? l10n.homeNearbyMapLocationRefreshError;
      notifyListeners();
      return;
    }

    _currentLocation = resolved.selection;
    await _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    final l10n = MateyaLocalizations.current;
    final location = _currentLocation;
    if (location == null) {
      _logger.warning(
        'Nearby culture map cannot load places because current location is missing',
      );
      _phase = AsyncPhase.validationError;
      _errorMessage = l10n.homeNearbyMapLocationRequired;
      notifyListeners();
      return;
    }

    _phase = AsyncPhase.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _logger.info(
        'Loading nearby culture map places',
        context: <String, Object?>{
          'district': location.displayName,
          'categoryCode': _selectedCategoryCode,
          'categoryDetailCode': _selectedCategoryDetailCode,
          'hasKeyword': _keyword.trim().isNotEmpty,
          'radiusKm': defaultRadiusKm,
        },
      );
      final places = await repository.fetchPlaces(
        latitude: location.latitude,
        longitude: location.longitude,
        categoryCode: _selectedCategoryCode,
        categoryDetailCode: _selectedCategoryDetailCode,
        keyword: _keyword,
        radiusKm: defaultRadiusKm,
      );
      _places = places;
      _selectedPlace =
          places.where((place) => place.id == _selectedPlace?.id).firstOrNull ??
          places.firstOrNull;
      _phase = AsyncPhase.success;
      _errorMessage = null;
      _logger.info(
        'Nearby culture map places loaded',
        context: <String, Object?>{
          'district': location.displayName,
          'count': places.length,
          'selectedPlaceId': _selectedPlace?.id,
        },
      );
    } on NearbyCultureMapRepositoryException catch (error) {
      _phase = error.type == NearbyCultureMapLoadFailureType.network
          ? AsyncPhase.networkError
          : AsyncPhase.serverError;
      _errorMessage = error.message;
      _logger.warning(
        'Nearby culture map place load failed',
        error: error,
        context: <String, Object?>{
          'district': location.displayName,
          'categoryCode': _selectedCategoryCode,
          'categoryDetailCode': _selectedCategoryDetailCode,
          'hasKeyword': _keyword.trim().isNotEmpty,
          'failureType': error.type.name,
          'message': error.message,
        },
      );
    } catch (error, stackTrace) {
      _phase = AsyncPhase.serverError;
      _errorMessage = l10n.homeNearbyMapPlacesLoadError;
      _logger.error(
        'Nearby culture map place load failed unexpectedly',
        error: error,
        stackTrace: stackTrace,
        context: <String, Object?>{
          'district': location.displayName,
          'categoryCode': _selectedCategoryCode,
          'categoryDetailCode': _selectedCategoryDetailCode,
          'hasKeyword': _keyword.trim().isNotEmpty,
        },
      );
    }

    notifyListeners();
  }
}
