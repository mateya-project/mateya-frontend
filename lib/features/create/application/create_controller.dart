import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../onboarding/domain/onboarding_flow.dart';
import '../data/create_repository.dart';
import '../domain/create_models.dart';

part 'create_controller_images.dart';
part 'create_controller_places.dart';
part 'create_controller_validation.dart';

class CreateController extends ChangeNotifier {
  CreateController({
    required this.repository,
    required this.flowType,
    this.isEditMode = false,
    this.editingId,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       _step = flowType == CreateFlowType.group
           ? CreateStep.category
           : CreateStep.place;

  static const int maxImageCount = 5;
  static const int maxImageBytes = 10 * 1024 * 1024;
  static const List<String> allowedExtensions = <String>[
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
  ];

  final CreateRepository repository;
  final CreateFlowType flowType;
  final bool isEditMode;
  final String? editingId;
  final DateTime Function() _now;

  CreateStep _step;
  AsyncPhase _placePhase = AsyncPhase.idle;
  AsyncPhase _submitPhase = AsyncPhase.idle;
  AsyncPhase _deletePhase = AsyncPhase.idle;
  String _searchQuery = '';
  List<CreatePlaceSuggestion> _searchResults = const <CreatePlaceSuggestion>[];
  List<CreatePlaceSuggestion> _recommendedPlaces =
      const <CreatePlaceSuggestion>[];
  final Set<String> _selectedCategoryIds = <String>{};
  String? _selectedCategoryDetailCode;
  CreatePlaceSuggestion? _selectedPlace;
  String _manualPlaceName = '';
  String _manualPlaceAddress = '';
  String _title = '';
  String _description = '';
  DateTime? _eventDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int _participantCapacity = 4;
  DateTime? _deadlineDate;
  TimeOfDay? _deadlineTime;
  final Set<String> _languageCodes = <String>{};
  CreatePriceType? _priceType;
  String _priceText = '';
  final Set<String> _audienceIds = <String>{};
  List<CreateImageAsset> _images = const <CreateImageAsset>[];
  Map<String, String?> _fieldErrors = <String, String?>{};
  String? _toastMessage;
  int _toastVersion = 0;
  CreateSubmitResult? _submitResult;

  CreateStep get step => _step;
  AsyncPhase get placePhase => _placePhase;
  AsyncPhase get submitPhase => _submitPhase;
  AsyncPhase get deletePhase => _deletePhase;
  String get searchQuery => _searchQuery;
  List<CreatePlaceSuggestion> get searchResults => _searchResults;
  List<CreatePlaceSuggestion> get recommendedPlaces => _recommendedPlaces;
  Set<String> get selectedCategoryIds => _selectedCategoryIds;
  String? get selectedCategoryId => _selectedCategoryIds.firstOrNull;
  String? get selectedCategoryDetailCode => _selectedCategoryDetailCode;
  CreatePlaceSuggestion? get selectedPlace => _selectedPlace;
  String get manualPlaceName => _manualPlaceName;
  String get manualPlaceAddress => _manualPlaceAddress;
  String get title => _title;
  String get description => _description;
  DateTime? get eventDate => _eventDate;
  TimeOfDay? get startTime => _startTime;
  TimeOfDay? get endTime => _endTime;
  int get participantCapacity => _participantCapacity;
  DateTime? get deadlineDate => _deadlineDate;
  TimeOfDay? get deadlineTime => _deadlineTime;
  Set<String> get languageCodes => _languageCodes;
  CreatePriceType? get priceType => _priceType;
  String get priceText => _priceText;
  Set<String> get audienceIds => _audienceIds;
  List<CreateImageAsset> get images => _images;
  String? get toastMessage => _toastMessage;
  int get toastVersion => _toastVersion;
  CreateSubmitResult? get submitResult => _submitResult;
  List<CreateCategoryDetailOption> get availableCategoryDetails =>
      _availableCategoryDetailsFor(this);

  List<CreateStep> get steps => flowType == CreateFlowType.group
      ? const <CreateStep>[
          CreateStep.category,
          CreateStep.place,
          CreateStep.details,
        ]
      : const <CreateStep>[CreateStep.place, CreateStep.details];

  int get currentStepNumber =>
      step == CreateStep.completed ? steps.length : steps.indexOf(step) + 1;

  int get totalStepCount => steps.length;

  bool get isSubmitLoading => _submitPhase == AsyncPhase.loading;

  bool get isDeleteLoading => _deletePhase == AsyncPhase.loading;

  bool get canContinueCurrentStep {
    if (isSubmitLoading || isDeleteLoading) {
      return false;
    }
    return _validateStep(step).isEmpty;
  }

  String? errorFor(String key) => _fieldErrors[key];

  Future<void> initialize() async {
    if (_step == CreateStep.place && _placePhase == AsyncPhase.idle) {
      await loadRecommendedPlaces();
    }
  }

  void clearToast() {
    _toastMessage = null;
  }

  void toggleCategory(String categoryId) {
    _applySingleCategorySelection(categoryId);
    _selectedCategoryDetailCode = null;
    _clearErrors(<String>{'categories'});
    notifyListeners();
  }

  Future<void> chooseCategory(String categoryId) async {
    _applySingleCategorySelection(categoryId);
    _selectedCategoryDetailCode = null;
    _selectedPlace = null;
    _clearErrors(<String>{'categories', 'place'});
    notifyListeners();

    if (_searchQuery.trim().isNotEmpty) {
      await searchPlaces();
      return;
    }
    await loadRecommendedPlaces();
  }

  Future<void> chooseCategoryDetail(String? categoryDetailCode) async {
    if (_selectedCategoryDetailCode == categoryDetailCode) {
      return;
    }
    _selectedCategoryDetailCode = categoryDetailCode;
    _selectedPlace = null;
    _clearErrors(<String>{'place'});
    notifyListeners();

    if (_searchQuery.trim().isNotEmpty) {
      await searchPlaces();
      return;
    }
    await loadRecommendedPlaces();
  }

  Future<void> continueFlow() async {
    final errors = _validateStep(step);
    if (errors.isNotEmpty) {
      _fieldErrors = errors;
      notifyListeners();
      return;
    }

    if (_step == CreateStep.details) {
      await submit();
      return;
    }

    final currentIndex = steps.indexOf(_step);
    if (currentIndex < 0 || currentIndex >= steps.length - 1) {
      return;
    }

    _step = steps[currentIndex + 1];
    _fieldErrors = <String, String?>{};
    notifyListeners();

    if (_step == CreateStep.place) {
      await loadRecommendedPlaces();
    }
  }

  void previousStep() {
    if (_step == CreateStep.completed) {
      return;
    }
    final currentIndex = steps.indexOf(_step);
    if (currentIndex <= 0) {
      return;
    }
    _step = steps[currentIndex - 1];
    _fieldErrors = <String, String?>{};
    notifyListeners();
  }

  Future<void> loadRecommendedPlaces() => _loadRecommendedPlacesFor(this);

  void updateSearchQuery(String value) {
    _searchQuery = value;
    _clearErrors(<String>{'searchQuery'});
    notifyListeners();
  }

  Future<void> searchPlaces() => _searchPlacesFor(this);

  void selectPlace(CreatePlaceSuggestion place) {
    if (!place.hasCoordinates) {
      _fieldErrors = <String, String?>{
        ..._fieldErrors,
        'place': '위치 정보가 없는 장소라 선택할 수 없어요.',
      };
      _emitToast('위치 정보가 없는 장소라 지도에 표시할 수 없어요.');
      notifyListeners();
      return;
    }
    _selectedPlace = place;
    if (flowType == CreateFlowType.classRegistration) {
      final categoryId = place.categoryIds.firstOrNull;
      if (categoryId != null) {
        _applySingleCategorySelection(categoryId);
      }
      _selectedCategoryDetailCode = place.categoryDetailCode;
      _manualPlaceName = place.name;
      _manualPlaceAddress = place.address;
    }
    _clearErrors(<String>{
      'categories',
      'place',
      'manualPlaceName',
      'manualPlaceAddress',
    });
    notifyListeners();
  }

  void updateManualPlaceName(String value) {
    _manualPlaceName = value;
    _clearErrors(<String>{'place', 'manualPlaceName'});
    notifyListeners();
  }

  void updateManualPlaceAddress(String value) {
    _manualPlaceAddress = value;
    _clearErrors(<String>{'place', 'manualPlaceAddress'});
    notifyListeners();
  }

  void updateTitle(String value) {
    _title = value;
    _clearErrors(<String>{'title'});
    notifyListeners();
  }

  void updateDescription(String value) {
    _description = value;
    _clearErrors(<String>{'description'});
    notifyListeners();
  }

  void updateEventDate(DateTime? value) {
    _eventDate = value;
    _clearErrors(<String>{'eventDate', 'deadline'});
    notifyListeners();
  }

  void updateStartTime(TimeOfDay? value) {
    _startTime = value;
    _clearErrors(<String>{'time'});
    notifyListeners();
  }

  void updateEndTime(TimeOfDay? value) {
    _endTime = value;
    _clearErrors(<String>{'time'});
    notifyListeners();
  }

  void updateParticipantCapacity(int value) {
    _participantCapacity = value.clamp(2, 20);
    _clearErrors(<String>{'participantCapacity'});
    notifyListeners();
  }

  void updateDeadlineDate(DateTime? value) {
    _deadlineDate = value;
    _clearErrors(<String>{'deadline'});
    notifyListeners();
  }

  void updateDeadlineTime(TimeOfDay? value) {
    _deadlineTime = value;
    _clearErrors(<String>{'deadline'});
    notifyListeners();
  }

  void clearDeadline() {
    _deadlineDate = null;
    _deadlineTime = null;
    _clearErrors(<String>{'deadline'});
    notifyListeners();
  }

  void toggleLanguage(String code) {
    if (_languageCodes.contains(code)) {
      _languageCodes.remove(code);
    } else {
      _languageCodes.add(code);
    }
    _clearErrors(<String>{'languages'});
    notifyListeners();
  }

  void updatePriceType(CreatePriceType value) {
    _priceType = value;
    if (value == CreatePriceType.free) {
      _priceText = '';
    }
    _clearErrors(<String>{'priceType', 'price'});
    notifyListeners();
  }

  void updatePriceText(String value) {
    _priceText = value;
    _clearErrors(<String>{'price'});
    notifyListeners();
  }

  void toggleAudience(String audienceId) {
    if (_audienceIds.contains(audienceId)) {
      _audienceIds.remove(audienceId);
    } else {
      _audienceIds.add(audienceId);
    }
    notifyListeners();
  }

  Future<void> addImages(List<XFile> files) => _addImagesFor(this, files);

  void removeImage(String imageId) => _removeImageFor(this, imageId);

  void setPrimaryImage(String imageId) => _setPrimaryImageFor(this, imageId);

  Future<void> submit() async {
    final errors = _validateStep(CreateStep.details);
    if (errors.isNotEmpty) {
      _fieldErrors = errors;
      notifyListeners();
      return;
    }

    final draft = _buildDraft();
    if (draft == null) {
      return;
    }

    _submitPhase = AsyncPhase.loading;
    _fieldErrors = <String, String?>{};
    notifyListeners();

    try {
      _submitResult = await repository.submit(draft);
      _submitPhase = AsyncPhase.success;
      _step = CreateStep.completed;
      if (_submitResult?.chatStatus == ChatProvisionStatus.failed) {
        _emitToast(
          '${flowType.entityLabel}은 생성됐지만 채팅방 생성은 실패했어요. 다시 시도할 수 있게 연결할 예정입니다.',
        );
      }
    } on CreateRepositoryException catch (error) {
      _submitPhase = error.type == CreateRepositoryFailureType.network
          ? AsyncPhase.networkError
          : AsyncPhase.serverError;
      _emitToast(
        error.message ??
            (error.type == CreateRepositoryFailureType.network
                ? '${flowType.entityLabel} 등록에 실패했어요. 네트워크를 확인해 주세요.'
                : '${flowType.entityLabel} 등록에 실패했어요. 잠시 후 다시 시도해 주세요.'),
      );
    } catch (_) {
      _submitPhase = AsyncPhase.serverError;
      _emitToast('${flowType.entityLabel} 등록에 실패했어요. 잠시 후 다시 시도해 주세요.');
    }

    notifyListeners();
  }

  Future<bool> deleteDraft() async {
    if (!isEditMode || editingId == null) {
      return false;
    }

    _deletePhase = AsyncPhase.loading;
    notifyListeners();
    try {
      await repository.delete(id: editingId!, flowType: flowType);
      _deletePhase = AsyncPhase.success;
      notifyListeners();
      return true;
    } on CreateRepositoryException catch (error) {
      _deletePhase = error.type == CreateRepositoryFailureType.network
          ? AsyncPhase.networkError
          : AsyncPhase.serverError;
      _emitToast(
        error.message ??
            (error.type == CreateRepositoryFailureType.network
                ? '삭제에 실패했어요. 네트워크를 확인해 주세요.'
                : '삭제에 실패했어요. 잠시 후 다시 시도해 주세요.'),
      );
    } catch (_) {
      _deletePhase = AsyncPhase.serverError;
      _emitToast('삭제에 실패했어요. 잠시 후 다시 시도해 주세요.');
    }

    notifyListeners();
    return false;
  }

  CreateSubmissionDraft? _buildDraft() => _buildDraftFor(this);

  Map<String, String?> _validateStep(CreateStep targetStep) =>
      _validateStepFor(this, targetStep);

  void _applySingleCategorySelection(String categoryId) {
    if (_selectedCategoryIds.contains(categoryId) &&
        _selectedCategoryIds.length == 1) {
      _selectedCategoryIds.clear();
      return;
    }
    _selectedCategoryIds
      ..clear()
      ..add(categoryId);
  }

  void _clearErrors(Set<String> keys) {
    if (keys.isEmpty) {
      return;
    }
    var didChange = false;
    final next = Map<String, String?>.from(_fieldErrors);
    for (final key in keys) {
      if (next.remove(key) != null) {
        didChange = true;
      }
    }
    if (didChange) {
      _fieldErrors = next;
    }
  }

  void _emitToast(String message) {
    _toastMessage = message;
    _toastVersion += 1;
  }

  void _notifyChanged() {
    notifyListeners();
  }
}
