import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../onboarding/domain/onboarding_flow.dart';
import '../data/create_repository.dart';
import '../domain/create_models.dart';

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
    'heic',
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
  CreatePlaceSuggestion? _selectedPlace;
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
  CreatePlaceSuggestion? get selectedPlace => _selectedPlace;
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
    if (_selectedCategoryIds.contains(categoryId)) {
      _selectedCategoryIds.remove(categoryId);
    } else {
      _selectedCategoryIds.add(categoryId);
    }
    _clearErrors(<String>{'categories'});
    notifyListeners();
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

  Future<void> loadRecommendedPlaces() async {
    _placePhase = AsyncPhase.loading;
    _fieldErrors.remove('place');
    notifyListeners();

    try {
      _recommendedPlaces = await repository.fetchRecommendedPlaces(
        flowType: flowType,
        categoryIds: _selectedCategoryIds,
      );
      _placePhase = AsyncPhase.success;
    } on CreateRepositoryException catch (error) {
      _recommendedPlaces = const <CreatePlaceSuggestion>[];
      _placePhase = error.type == CreateRepositoryFailureType.network
          ? AsyncPhase.networkError
          : AsyncPhase.serverError;
      _emitToast(
        error.type == CreateRepositoryFailureType.network
            ? '추천 장소를 불러오지 못했어요. 네트워크 상태를 확인해 주세요.'
            : '추천 장소를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.',
      );
    } catch (_) {
      _recommendedPlaces = const <CreatePlaceSuggestion>[];
      _placePhase = AsyncPhase.serverError;
      _emitToast('추천 장소를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.');
    }

    notifyListeners();
  }

  void updateSearchQuery(String value) {
    _searchQuery = value;
    _clearErrors(<String>{'searchQuery'});
    notifyListeners();
  }

  Future<void> searchPlaces() async {
    final query = _searchQuery.trim();
    if (query.isEmpty) {
      _fieldErrors = <String, String?>{
        ..._fieldErrors,
        'searchQuery': '장소명을 입력해 주세요.',
      };
      notifyListeners();
      return;
    }

    _placePhase = AsyncPhase.loading;
    _clearErrors(<String>{'searchQuery'});
    notifyListeners();

    try {
      _searchResults = await repository.searchPlaces(
        query: query,
        flowType: flowType,
        categoryIds: _selectedCategoryIds,
      );
      _placePhase = AsyncPhase.success;
    } on CreateRepositoryException catch (error) {
      _searchResults = const <CreatePlaceSuggestion>[];
      _placePhase = error.type == CreateRepositoryFailureType.network
          ? AsyncPhase.networkError
          : AsyncPhase.serverError;
      _emitToast(
        error.type == CreateRepositoryFailureType.network
            ? '장소 검색에 실패했어요. 연결 상태를 확인한 뒤 다시 시도해 주세요.'
            : '장소 검색에 실패했어요. 잠시 후 다시 시도해 주세요.',
      );
    } catch (_) {
      _searchResults = const <CreatePlaceSuggestion>[];
      _placePhase = AsyncPhase.serverError;
      _emitToast('장소 검색에 실패했어요. 잠시 후 다시 시도해 주세요.');
    }

    notifyListeners();
  }

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
    _clearErrors(<String>{'place'});
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

  Future<void> addImages(List<XFile> files) async {
    if (files.isEmpty) {
      return;
    }

    final availableSlots = maxImageCount - _images.length;
    if (availableSlots <= 0) {
      _emitToast('이미지는 최대 $maxImageCount장까지 등록할 수 있어요.');
      notifyListeners();
      return;
    }

    final accepted = <CreateImageAsset>[];
    for (final file in files.take(availableSlots)) {
      final extension = file.name.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        _emitToast('JPG, PNG, HEIC 형식의 이미지만 등록할 수 있어요.');
        continue;
      }

      final sizeBytes = await File(file.path).length();
      if (sizeBytes > maxImageBytes) {
        _emitToast('이미지 한 장당 최대 10MB까지 등록할 수 있어요.');
        continue;
      }

      accepted.add(
        CreateImageAsset(
          id: 'image-${DateTime.now().microsecondsSinceEpoch}-${accepted.length}',
          path: file.path,
          name: file.name,
          sizeBytes: sizeBytes,
          isPrimary: _images.isEmpty && accepted.isEmpty,
        ),
      );
    }

    if (accepted.isEmpty) {
      notifyListeners();
      return;
    }

    _images = <CreateImageAsset>[..._images, ...accepted];
    if (!_images.any((image) => image.isPrimary)) {
      _images = _images.indexed
          .map((entry) => entry.$2.copyWith(isPrimary: entry.$1 == 0))
          .toList(growable: false);
    }
    _clearErrors(<String>{'images'});
    notifyListeners();
  }

  void removeImage(String imageId) {
    final next = _images.where((image) => image.id != imageId).toList();
    if (next.length == _images.length) {
      return;
    }
    if (next.isNotEmpty && !next.any((image) => image.isPrimary)) {
      next[0] = next[0].copyWith(isPrimary: true);
    }
    _images = next;
    _clearErrors(<String>{'images'});
    notifyListeners();
  }

  void setPrimaryImage(String imageId) {
    _images = _images
        .map((image) => image.copyWith(isPrimary: image.id == imageId))
        .toList(growable: false);
    _clearErrors(<String>{'images'});
    notifyListeners();
  }

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
        error.type == CreateRepositoryFailureType.network
            ? '${flowType.entityLabel} 등록에 실패했어요. 네트워크를 확인해 주세요.'
            : '${flowType.entityLabel} 등록에 실패했어요. 잠시 후 다시 시도해 주세요.',
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
        error.type == CreateRepositoryFailureType.network
            ? '삭제에 실패했어요. 네트워크를 확인해 주세요.'
            : '삭제에 실패했어요. 잠시 후 다시 시도해 주세요.',
      );
    } catch (_) {
      _deletePhase = AsyncPhase.serverError;
      _emitToast('삭제에 실패했어요. 잠시 후 다시 시도해 주세요.');
    }

    notifyListeners();
    return false;
  }

  CreateSubmissionDraft? _buildDraft() {
    final eventDate = _eventDate;
    final startTime = _startTime;
    final endTime = _endTime;
    final selectedPlace = _selectedPlace;
    if (eventDate == null ||
        startTime == null ||
        endTime == null ||
        selectedPlace == null) {
      return null;
    }

    return CreateSubmissionDraft(
      flowType: flowType,
      categoryIds: Set<String>.from(_selectedCategoryIds),
      place: selectedPlace,
      title: _title.trim(),
      description: _description.trim(),
      eventDate: eventDate,
      startTime: startTime,
      endTime: endTime,
      participantCapacity: _participantCapacity,
      registrationDeadlineDate: _deadlineDate,
      registrationDeadlineTime: _deadlineTime,
      languageCodes: Set<String>.from(_languageCodes),
      priceType: _priceType,
      price: _parsedPrice,
      audienceIds: Set<String>.from(_audienceIds),
      images: _images,
    );
  }

  Map<String, String?> _validateStep(CreateStep targetStep) {
    return switch (targetStep) {
      CreateStep.category => _validateCategoryStep(),
      CreateStep.place => _validatePlaceStep(),
      CreateStep.details => _validateDetailStep(),
      CreateStep.completed => <String, String?>{},
    };
  }

  Map<String, String?> _validateCategoryStep() {
    if (flowType == CreateFlowType.classRegistration) {
      return <String, String?>{};
    }
    if (_selectedCategoryIds.isNotEmpty) {
      return <String, String?>{};
    }
    return <String, String?>{'categories': '카테고리를 1개 이상 선택해 주세요.'};
  }

  Map<String, String?> _validatePlaceStep() {
    if (_selectedPlace != null) {
      return <String, String?>{};
    }
    return <String, String?>{'place': '장소를 1개 선택해 주세요.'};
  }

  Map<String, String?> _validateDetailStep() {
    final errors = <String, String?>{};
    final now = _now();
    final normalizedToday = DateTime(now.year, now.month, now.day);
    final title = _title.trim();
    final description = _description.trim();

    if (title.isEmpty) {
      errors['title'] = '${flowType.entityLabel} 이름을 입력해 주세요.';
    } else if (title.length > 100) {
      errors['title'] = '제목은 100자 이하여야 해요.';
    }

    if (description.length > 3000) {
      errors['description'] = '소개는 3000자 이하여야 해요.';
    }

    if (_eventDate == null) {
      errors['eventDate'] = '날짜를 선택해 주세요.';
    } else if (_eventDate!.isBefore(normalizedToday)) {
      errors['eventDate'] = '과거 날짜는 선택할 수 없어요.';
    }

    if (_startTime == null || _endTime == null) {
      errors['time'] = '시작 시간과 종료 시간을 모두 선택해 주세요.';
    } else if (_eventDate != null) {
      final startAt = _combine(_eventDate!, _startTime!);
      final endAt = _combine(_eventDate!, _endTime!);
      if (!endAt.isAfter(startAt)) {
        errors['time'] = '종료 시간은 시작 시간보다 늦어야 해요.';
      }
    }

    if (_participantCapacity < 2 || _participantCapacity > 20) {
      errors['participantCapacity'] = '모집 인원은 2명에서 20명 사이여야 해요.';
    }

    final hasDeadlineDate = _deadlineDate != null;
    final hasDeadlineTime = _deadlineTime != null;
    if (hasDeadlineDate != hasDeadlineTime) {
      errors['deadline'] = '모집 마감 날짜와 시간을 함께 선택해 주세요.';
    } else if (hasDeadlineDate && hasDeadlineTime && _eventDate != null) {
      final deadlineAt = _combine(_deadlineDate!, _deadlineTime!);
      if (deadlineAt.isBefore(now)) {
        errors['deadline'] = '모집 마감 일시는 현재 시각 이후여야 해요.';
      } else {
        final startAt = _startTime == null
            ? null
            : _combine(_eventDate!, _startTime!);
        if (startAt != null && !deadlineAt.isBefore(startAt)) {
          errors['deadline'] = '모집 마감 일시는 시작 시간보다 앞서야 해요.';
        }
      }
    }

    if (_languageCodes.isEmpty) {
      errors['languages'] = '진행 언어를 1개 이상 선택해 주세요.';
    }

    if (_priceType == null) {
      errors['priceType'] = '비용 유형을 선택해 주세요.';
    } else if (_priceType == CreatePriceType.paid) {
      final price = _parsedPrice;
      if (price == null) {
        errors['price'] = '유료 금액을 입력해 주세요.';
      } else if (price < 0 || price > 200000) {
        errors['price'] = '유료 금액은 0원 이상 200,000원 이하로 입력해 주세요.';
      }
    }

    if (flowType == CreateFlowType.group && _images.isEmpty) {
      errors['images'] = '대표 이미지를 1장 이상 등록해 주세요.';
    }

    return errors;
  }

  int? get _parsedPrice {
    final digits = _priceText.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return null;
    }
    return int.tryParse(digits);
  }

  DateTime _combine(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
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
}
