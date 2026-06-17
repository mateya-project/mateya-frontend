import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../../shared/widgets/mateya_text_field.dart';
import '../../../onboarding/domain/onboarding_flow.dart';
import '../../application/create_controller.dart';
import '../../domain/create_models.dart';

class CreateFlowPage extends StatefulWidget {
  const CreateFlowPage({super.key, required this.controller});

  final CreateController controller;

  @override
  State<CreateFlowPage> createState() => _CreateFlowPageState();
}

class _CreateFlowPageState extends State<CreateFlowPage> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _manualPlaceNameController =
      TextEditingController();
  final TextEditingController _manualPlaceAddressController =
      TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _hasSearched = false;
  int _lastToastVersion = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
    _searchController.text = widget.controller.searchQuery;
    _manualPlaceNameController.text = widget.controller.manualPlaceName;
    _manualPlaceAddressController.text = widget.controller.manualPlaceAddress;
    _titleController.text = widget.controller.title;
    _descriptionController.text = widget.controller.description;
    _priceController.text = widget.controller.priceText;
    widget.controller.initialize();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    widget.controller.dispose();
    _searchController.dispose();
    _manualPlaceNameController.dispose();
    _manualPlaceAddressController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (!mounted) {
      return;
    }
    if (widget.controller.toastMessage != null &&
        widget.controller.toastVersion != _lastToastVersion) {
      _lastToastVersion = widget.controller.toastVersion;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(widget.controller.toastMessage!)));
      widget.controller.clearToast();
    }
    if (_manualPlaceNameController.text != widget.controller.manualPlaceName) {
      _manualPlaceNameController.value = TextEditingValue(
        text: widget.controller.manualPlaceName,
        selection: TextSelection.collapsed(
          offset: widget.controller.manualPlaceName.length,
        ),
      );
    }
    if (_manualPlaceAddressController.text !=
        widget.controller.manualPlaceAddress) {
      _manualPlaceAddressController.value = TextEditingValue(
        text: widget.controller.manualPlaceAddress,
        selection: TextSelection.collapsed(
          offset: widget.controller.manualPlaceAddress.length,
        ),
      );
    }
  }

  Future<void> _searchPlaces() async {
    setState(() {
      _hasSearched = _searchController.text.trim().isNotEmpty;
    });
    await widget.controller.searchPlaces();
  }

  Future<void> _pickImages() async {
    final remaining =
        CreateController.maxImageCount - widget.controller.images.length;
    if (remaining <= 0) {
      return;
    }
    try {
      final picked = await _imagePicker.pickMultiImage(
        imageQuality: 88,
        maxWidth: 2400,
      );
      if (!mounted || picked.isEmpty) {
        return;
      }
      await widget.controller.addImages(picked.take(remaining).toList());
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 불러오지 못했어요. 권한과 파일 상태를 확인해 주세요.')),
      );
    }
  }

  Future<void> _pickEventDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      initialDate: widget.controller.eventDate ?? today,
      helpText: '${widget.controller.flowType.entityLabel} 날짜 선택',
    );
    if (picked == null) {
      return;
    }
    widget.controller.updateEventDate(picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          widget.controller.startTime ?? const TimeOfDay(hour: 19, minute: 0),
      helpText: '시작 시간 선택',
    );
    if (picked == null) {
      return;
    }
    widget.controller.updateStartTime(picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          widget.controller.endTime ?? const TimeOfDay(hour: 21, minute: 0),
      helpText: '종료 시간 선택',
    );
    if (picked == null) {
      return;
    }
    widget.controller.updateEndTime(picked);
  }

  Future<void> _pickDeadlineDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate =
        widget.controller.eventDate ?? today.add(const Duration(days: 365));
    final initialDate = widget.controller.deadlineDate ?? today;
    final picked = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: lastDate,
      initialDate: initialDate.isAfter(lastDate) ? lastDate : initialDate,
      helpText: '모집 마감 날짜 선택',
    );
    if (picked == null) {
      return;
    }
    widget.controller.updateDeadlineDate(picked);
  }

  Future<void> _pickDeadlineTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          widget.controller.deadlineTime ??
          const TimeOfDay(hour: 18, minute: 0),
      helpText: '모집 마감 시간 선택',
    );
    if (picked == null) {
      return;
    }
    widget.controller.updateDeadlineTime(picked);
  }

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${widget.controller.flowType.entityLabel} 삭제'),
          content: Text(
            '이 ${widget.controller.flowType.entityLabel}을 삭제하면 복구할 수 없습니다. 계속할까요?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
    if (shouldDelete != true || !mounted) {
      return;
    }

    final didDelete = await widget.controller.deleteDraft();
    if (!mounted || !didDelete) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('삭제가 완료됐어요.')));
    Navigator.of(context).pop();
  }

  void _handleBack() {
    if (widget.controller.step == CreateStep.completed ||
        widget.controller.currentStepNumber == 1) {
      Navigator.of(context).pop();
      return;
    }
    widget.controller.previousStep();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                _CreateFlowHeader(
                  title: widget.controller.flowType.label,
                  progressLabel: widget.controller.step == CreateStep.completed
                      ? '완료'
                      : '${widget.controller.currentStepNumber}/${widget.controller.totalStepCount}',
                  onBack: _handleBack,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0.06, 0),
                        end: Offset.zero,
                      ).animate(animation);
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: _buildStep(context),
                  ),
                ),
                if (widget.controller.step != CreateStep.completed)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                    child: MateyaButton(
                      label: _submitButtonLabel(),
                      enabled: widget.controller.canContinueCurrentStep,
                      onPressed: widget.controller.continueFlow,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _submitButtonLabel() {
    if (widget.controller.step == CreateStep.details) {
      if (widget.controller.submitPhase == AsyncPhase.loading) {
        return '${widget.controller.flowType.entityLabel} 등록 중...';
      }
      return widget.controller.flowType.submitLabel;
    }
    return '다음';
  }

  Widget _buildStep(BuildContext context) {
    return switch (widget.controller.step) {
      CreateStep.category => _CategoryStepView(
        key: const ValueKey<String>('category-step'),
        controller: widget.controller,
      ),
      CreateStep.place => _PlaceStepView(
        key: const ValueKey<String>('place-step'),
        controller: widget.controller,
        searchController: _searchController,
        manualPlaceNameController: _manualPlaceNameController,
        manualPlaceAddressController: _manualPlaceAddressController,
        hasSearched: _hasSearched,
        onSearchChanged: (value) {
          if (value.isEmpty && _hasSearched) {
            setState(() {
              _hasSearched = false;
            });
          }
          widget.controller.updateSearchQuery(value);
        },
        onSearch: _searchPlaces,
      ),
      CreateStep.details => _DetailsStepView(
        key: const ValueKey<String>('details-step'),
        controller: widget.controller,
        titleController: _titleController,
        descriptionController: _descriptionController,
        priceController: _priceController,
        onPickEventDate: _pickEventDate,
        onPickStartTime: _pickStartTime,
        onPickEndTime: _pickEndTime,
        onPickDeadlineDate: _pickDeadlineDate,
        onPickDeadlineTime: _pickDeadlineTime,
        onPickImages: _pickImages,
        onDelete: widget.controller.isEditMode ? _confirmDelete : null,
      ),
      CreateStep.completed => _CompletedStepView(
        key: const ValueKey<String>('completed-step'),
        controller: widget.controller,
        onDone: () => Navigator.of(context).pop(true),
      ),
    };
  }
}

class _CreateFlowHeader extends StatelessWidget {
  const _CreateFlowHeader({
    required this.title,
    required this.progressLabel,
    required this.onBack,
  });

  final String title;
  final String progressLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.textPrimary,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  progressLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _CategoryStepView extends StatelessWidget {
  const _CategoryStepView({super.key, required this.controller});

  final CreateController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      children: <Widget>[
        Text('어떤 모임을 만들까요?', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 10),
        Text(
          '현재는 한국문화 체험 유형만 먼저 제공하고, 카테고리는 1개만 선택하도록 구성했습니다.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        const _PrimaryTypeCard(),
        const SizedBox(height: 28),
        Text('카테고리', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: CreateFormOptions.categories
              .map(
                (category) => _SelectableChip(
                  label: category.label,
                  selected: controller.selectedCategoryIds.contains(
                    category.id,
                  ),
                  onTap: () => controller.toggleCategory(category.id),
                ),
              )
              .toList(growable: false),
        ),
        if (controller.errorFor('categories') != null) ...<Widget>[
          const SizedBox(height: 12),
          _InlineErrorText(text: controller.errorFor('categories')!),
        ],
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.subtleBackground,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            '선택한 카테고리는 다음 단계 장소 추천과 최종 상세 입력으로 그대로 전달됩니다.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

class _PlaceStepView extends StatelessWidget {
  const _PlaceStepView({
    super.key,
    required this.controller,
    required this.searchController,
    required this.manualPlaceNameController,
    required this.manualPlaceAddressController,
    required this.hasSearched,
    required this.onSearchChanged,
    required this.onSearch,
  });

  final CreateController controller;
  final TextEditingController searchController;
  final TextEditingController manualPlaceNameController;
  final TextEditingController manualPlaceAddressController;
  final bool hasSearched;
  final ValueChanged<String> onSearchChanged;
  final Future<void> Function() onSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedPlace = controller.selectedPlace;
    final showEmptyResult =
        hasSearched &&
        controller.placePhase == AsyncPhase.success &&
        controller.searchResults.isEmpty;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      children: <Widget>[
        Text(
          controller.flowType == CreateFlowType.group
              ? '진행할 장소를 찾아주세요'
              : '클래스 장소를 선택해 주세요',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          controller.flowType == CreateFlowType.group
              ? '검색 결과 또는 추천 목록에서 1곳을 선택하면 지도에 바로 표시됩니다.'
              : '클래스는 검색으로 장소를 고르거나, 장소명과 주소를 직접 입력할 수 있습니다.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        if (controller.flowType ==
            CreateFlowType.classRegistration) ...<Widget>[
          Text('직접 장소 입력', style: theme.textTheme.titleLarge),
          const SizedBox(height: 10),
          MateyaTextField(
            controller: manualPlaceNameController,
            hintText: '예: 성수 티 스튜디오',
            errorText: controller.errorFor('manualPlaceName'),
            onChanged: controller.updateManualPlaceName,
          ),
          const SizedBox(height: 12),
          MateyaTextField(
            controller: manualPlaceAddressController,
            hintText: '예: 서울 성동구 성수일로 32',
            errorText: controller.errorFor('manualPlaceAddress'),
            onChanged: controller.updateManualPlaceAddress,
          ),
          const SizedBox(height: 20),
          Text('또는 검색으로 선택', style: theme.textTheme.titleLarge),
          const SizedBox(height: 10),
        ],
        MateyaTextField(
          controller: searchController,
          hintText: '장소명으로 검색',
          errorText: controller.errorFor('searchQuery'),
          onChanged: onSearchChanged,
          onSubmitted: (_) => onSearch(),
          textInputAction: TextInputAction.search,
          suffixIcon: IconButton(
            onPressed: onSearch,
            icon: const Icon(Icons.search_rounded),
          ),
        ),
        if (selectedPlace != null) ...<Widget>[
          const SizedBox(height: 18),
          _SelectedPlaceCard(place: selectedPlace),
        ] else if (controller.flowType == CreateFlowType.classRegistration &&
            controller.manualPlaceName.trim().isNotEmpty &&
            controller.manualPlaceAddress.trim().isNotEmpty) ...<Widget>[
          const SizedBox(height: 18),
          _SelectedPlaceCard(
            place: CreatePlaceSuggestion(
              id: 'manual-preview',
              name: controller.manualPlaceName.trim(),
              address: controller.manualPlaceAddress.trim(),
              description: '직접 입력한 클래스 장소',
              distanceKm: 0,
            ),
          ),
        ],
        if (controller.errorFor('place') != null) ...<Widget>[
          const SizedBox(height: 12),
          _InlineErrorText(text: controller.errorFor('place')!),
        ],
        const SizedBox(height: 20),
        _PlaceMapCard(
          place: selectedPlace,
          isLoading: controller.placePhase == AsyncPhase.loading,
        ),
        const SizedBox(height: 24),
        Row(
          children: <Widget>[
            Expanded(
              child: Text('내 동네 기준 추천', style: theme.textTheme.titleLarge),
            ),
            TextButton(
              onPressed: controller.loadRecommendedPlaces,
              child: const Text('새로고침'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (controller.recommendedPlaces.isEmpty &&
            controller.placePhase == AsyncPhase.loading)
          const _LoadingPlaceList()
        else if (controller.recommendedPlaces.isEmpty)
          const _EmptyStateCard(
            icon: Icons.location_off_outlined,
            title: '추천 장소가 없어요',
            body: '카테고리를 바꾸거나 직접 검색해서 장소를 선택해 주세요.',
          )
        else
          ...controller.recommendedPlaces.map(
            (place) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PlaceTile(
                place: place,
                selected: selectedPlace?.id == place.id,
                onTap: () => controller.selectPlace(place),
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text('검색 결과', style: theme.textTheme.titleLarge),
        const SizedBox(height: 10),
        if (controller.placePhase == AsyncPhase.loading && hasSearched)
          const _LoadingPlaceList()
        else if (showEmptyResult)
          const _EmptyStateCard(
            icon: Icons.search_off_rounded,
            title: '검색 결과가 없어요',
            body: '다른 키워드로 다시 검색해 주세요.',
          )
        else if (hasSearched)
          ...controller.searchResults.map(
            (place) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PlaceTile(
                place: place,
                selected: selectedPlace?.id == place.id,
                onTap: () => controller.selectPlace(place),
              ),
            ),
          )
        else
          const _EmptyStateCard(
            icon: Icons.travel_explore_rounded,
            title: '장소를 검색해 보세요',
            body: '`장소명` 기준 검색과 추천 목록 선택을 모두 지원하도록 프론트 흐름을 준비했습니다.',
          ),
      ],
    );
  }
}

class _DetailsStepView extends StatelessWidget {
  const _DetailsStepView({
    super.key,
    required this.controller,
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
    required this.onPickEventDate,
    required this.onPickStartTime,
    required this.onPickEndTime,
    required this.onPickDeadlineDate,
    required this.onPickDeadlineTime,
    required this.onPickImages,
    required this.onDelete,
  });

  final CreateController controller;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final Future<void> Function() onPickEventDate;
  final Future<void> Function() onPickStartTime;
  final Future<void> Function() onPickEndTime;
  final Future<void> Function() onPickDeadlineDate;
  final Future<void> Function() onPickDeadlineTime;
  final Future<void> Function() onPickImages;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedPlace = controller.selectedPlace;
    final manualSummary =
        controller.flowType == CreateFlowType.classRegistration &&
            controller.manualPlaceName.trim().isNotEmpty &&
            controller.manualPlaceAddress.trim().isNotEmpty
        ? '${controller.manualPlaceName.trim()}\n${controller.manualPlaceAddress.trim()}'
        : null;
    if (titleController.text != controller.title) {
      titleController.value = TextEditingValue(
        text: controller.title,
        selection: TextSelection.collapsed(offset: controller.title.length),
      );
    }
    if (descriptionController.text != controller.description) {
      descriptionController.value = TextEditingValue(
        text: controller.description,
        selection: TextSelection.collapsed(
          offset: controller.description.length,
        ),
      );
    }
    if (priceController.text != controller.priceText) {
      priceController.value = TextEditingValue(
        text: controller.priceText,
        selection: TextSelection.collapsed(offset: controller.priceText.length),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      children: <Widget>[
        Text(
          controller.flowType == CreateFlowType.group
              ? '모임 정보를 입력해 주세요'
              : '클래스 정보를 입력해 주세요',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          '필수 항목이 모두 채워져야 등록 버튼이 활성화되도록 프론트 검증을 먼저 구현했습니다.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        if (controller.flowType == CreateFlowType.group) ...<Widget>[
          _SummaryCard(
            title: '선택한 카테고리',
            body: CreateFormOptions.categories
                .where(
                  (category) =>
                      controller.selectedCategoryIds.contains(category.id),
                )
                .map((category) => category.label)
                .join(', '),
          ),
          const SizedBox(height: 12),
        ],
        if (selectedPlace != null || manualSummary != null) ...<Widget>[
          _SummaryCard(
            title: '선택한 장소',
            body: selectedPlace != null
                ? '${selectedPlace.name}\n${selectedPlace.address}'
                : manualSummary!,
          ),
          const SizedBox(height: 24),
        ],
        Text(
          controller.flowType == CreateFlowType.group ? '모임명' : '클래스 이름',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        MateyaTextField(
          controller: titleController,
          hintText: controller.flowType == CreateFlowType.group
              ? '예: 북촌 한옥 다도 체험 같이 가요'
              : '예: 초보자를 위한 전통 다도 클래스',
          errorText: controller.errorFor('title'),
          maxLength: 100,
          onChanged: controller.updateTitle,
        ),
        const SizedBox(height: 24),
        Text('소개', style: theme.textTheme.titleLarge),
        const SizedBox(height: 10),
        _MultilineField(
          controller: descriptionController,
          hintText: '활동 소개, 준비물, 분위기 등을 자유롭게 적어 주세요.',
          maxLength: 3000,
          errorText: controller.errorFor('description'),
          onChanged: controller.updateDescription,
        ),
        const SizedBox(height: 24),
        Text('날짜와 시간', style: theme.textTheme.titleLarge),
        const SizedBox(height: 10),
        _PickerField(
          label: '날짜',
          value: _formatDate(controller.eventDate),
          placeholder: '날짜 선택',
          errorText: controller.errorFor('eventDate'),
          icon: Icons.calendar_today_rounded,
          onTap: onPickEventDate,
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: _PickerField(
                label: '시작 시간',
                value: _formatTime(controller.startTime),
                placeholder: '시작 시간',
                errorText: null,
                icon: Icons.schedule_rounded,
                onTap: onPickStartTime,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PickerField(
                label: '종료 시간',
                value: _formatTime(controller.endTime),
                placeholder: '종료 시간',
                errorText: null,
                icon: Icons.schedule_rounded,
                onTap: onPickEndTime,
              ),
            ),
          ],
        ),
        if (controller.errorFor('time') != null) ...<Widget>[
          const SizedBox(height: 10),
          _InlineErrorText(text: controller.errorFor('time')!),
        ],
        const SizedBox(height: 24),
        Text('모집 인원', style: theme.textTheme.titleLarge),
        const SizedBox(height: 10),
        _CapacityStepper(
          value: controller.participantCapacity,
          onChanged: controller.updateParticipantCapacity,
        ),
        if (controller.errorFor('participantCapacity') != null) ...<Widget>[
          const SizedBox(height: 10),
          _InlineErrorText(text: controller.errorFor('participantCapacity')!),
        ],
        const SizedBox(height: 24),
        Row(
          children: <Widget>[
            Expanded(child: Text('모집 마감', style: theme.textTheme.titleLarge)),
            if (controller.deadlineDate != null ||
                controller.deadlineTime != null)
              TextButton(
                onPressed: controller.clearDeadline,
                child: const Text('초기화'),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: _PickerField(
                label: '마감 날짜',
                value: _formatDate(controller.deadlineDate),
                placeholder: '선택 안 함',
                errorText: null,
                icon: Icons.event_available_rounded,
                onTap: onPickDeadlineDate,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PickerField(
                label: '마감 시간',
                value: _formatTime(controller.deadlineTime),
                placeholder: '선택 안 함',
                errorText: null,
                icon: Icons.alarm_rounded,
                onTap: onPickDeadlineTime,
              ),
            ),
          ],
        ),
        if (controller.errorFor('deadline') != null) ...<Widget>[
          const SizedBox(height: 10),
          _InlineErrorText(text: controller.errorFor('deadline')!),
        ],
        const SizedBox(height: 24),
        Text('진행 언어', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: CreateFormOptions.languages
              .map(
                (language) => _SelectableChip(
                  label: language.label,
                  selected: controller.languageCodes.contains(language.code),
                  onTap: () => controller.toggleLanguage(language.code),
                ),
              )
              .toList(growable: false),
        ),
        if (controller.errorFor('languages') != null) ...<Widget>[
          const SizedBox(height: 12),
          _InlineErrorText(text: controller.errorFor('languages')!),
        ],
        const SizedBox(height: 24),
        Text('비용', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(
          children: CreatePriceType.values
              .map(
                (type) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: type == CreatePriceType.free ? 8 : 0,
                      left: type == CreatePriceType.paid ? 8 : 0,
                    ),
                    child: _ToggleCard(
                      label: type.label,
                      selected: controller.priceType == type,
                      onTap: () => controller.updatePriceType(type),
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        ),
        if (controller.errorFor('priceType') != null) ...<Widget>[
          const SizedBox(height: 12),
          _InlineErrorText(text: controller.errorFor('priceType')!),
        ],
        if (controller.priceType == CreatePriceType.paid) ...<Widget>[
          const SizedBox(height: 12),
          MateyaTextField(
            controller: priceController,
            hintText: '예: 15000',
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            errorText: controller.errorFor('price'),
            onChanged: controller.updatePriceText,
          ),
        ],
        const SizedBox(height: 24),
        Text('참가 대상', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: CreateFormOptions.audiences
              .map(
                (audience) => _SelectableChip(
                  label: audience.label,
                  selected: controller.audienceIds.contains(audience.id),
                  onTap: () => controller.toggleAudience(audience.id),
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: 24),
        Row(
          children: <Widget>[
            Expanded(child: Text('대표 이미지', style: theme.textTheme.titleLarge)),
            Text(
              '${controller.images.length}/${CreateController.maxImageCount}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onPickImages,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: AppColors.fieldBorderLight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: const Text('이미지 추가'),
        ),
        const SizedBox(height: 12),
        if (controller.images.isEmpty)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.subtleBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.divider),
            ),
            child: Text(
              controller.flowType == CreateFlowType.group
                  ? '모임은 대표 이미지를 최소 1장 등록하도록 구성했습니다.'
                  : '클래스 이미지는 현재 선택 입력으로 두고, 기본 이미지 정책은 백엔드 연결 전에 확정할 수 있게 열어뒀습니다.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: controller.images
                .map(
                  (image) => _ImageTile(
                    image: image,
                    onRemove: () => controller.removeImage(image.id),
                    onSetPrimary: () => controller.setPrimaryImage(image.id),
                  ),
                )
                .toList(growable: false),
          ),
        if (controller.errorFor('images') != null) ...<Widget>[
          const SizedBox(height: 12),
          _InlineErrorText(text: controller.errorFor('images')!),
        ],
        if (onDelete != null) ...<Widget>[
          const SizedBox(height: 28),
          OutlinedButton(
            onPressed: controller.isDeleteLoading ? null : onDelete,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              controller.isDeleteLoading
                  ? '삭제 중...'
                  : '${controller.flowType.entityLabel} 삭제하기',
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  static String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  static String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return '';
    }
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? '오전' : '오후';
    return '$period ${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _CompletedStepView extends StatelessWidget {
  const _CompletedStepView({
    super.key,
    required this.controller,
    required this.onDone,
  });

  final CreateController controller;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = controller.submitResult;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      child: Column(
        children: <Widget>[
          const Spacer(),
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              color: AppColors.softGreenBorder,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.brandGreen,
              size: 42,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '${controller.flowType.entityLabel} 등록이 완료됐어요',
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            '백엔드 연결 전 단계라 완료 후에는 홈으로 복귀하도록 구성했고, 생성 결과 요약은 프론트 상태로 먼저 보여줍니다.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (result != null)
            _SummaryCard(
              title: result.title,
              body:
                  '${result.placeName}\n${result.eventStartsAt.year}.${result.eventStartsAt.month.toString().padLeft(2, '0')}.${result.eventStartsAt.day.toString().padLeft(2, '0')}',
            ),
          const Spacer(),
          MateyaButton(label: '홈으로 돌아가기', onPressed: onDone),
        ],
      ),
    );
  }
}

class _PrimaryTypeCard extends StatelessWidget {
  const _PrimaryTypeCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.softGreenBorder,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.brandGreenLight),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.temple_buddhist_outlined,
              color: AppColors.brandGreen,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('한국문화 체험', style: theme.textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(
                  '현재 선택 가능한 유일한 모임 유형',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.brandGreen,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '선택됨',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectableChip extends StatelessWidget {
  const _SelectableChip({
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
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.textPrimary
                : AppColors.fieldBorderLight,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _PlaceTile extends StatelessWidget {
  const _PlaceTile({
    required this.place,
    required this.selected,
    required this.onTap,
  });

  final CreatePlaceSuggestion place;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.softGreenBorder : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.brandGreen : AppColors.divider,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.brandGreen
                    : AppColors.subtleBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.place_rounded,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(place.name, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(
                    place.address,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    place.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '${place.distanceKm}km',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? AppColors.brandGreen
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected
                      ? AppColors.brandGreen
                      : AppColors.fieldBorderLight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedPlaceCard extends StatelessWidget {
  const _SelectedPlaceCard({required this.place});

  final CreatePlaceSuggestion place;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softGreenBorder,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.check_circle_rounded, color: AppColors.brandGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(place.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  place.address,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceMapCard extends StatelessWidget {
  const _PlaceMapCard({required this.place, required this.isLoading});

  final CreatePlaceSuggestion? place;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final target = place != null && place!.hasCoordinates
        ? NLatLng(place!.latitude!, place!.longitude!)
        : const NLatLng(37.5665, 126.9780);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 280,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            NaverMap(
              key: ValueKey<String>(
                place == null
                    ? 'empty-create-map'
                    : '${place!.id}-${place!.latitude}-${place!.longitude}',
              ),
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: target,
                  zoom: 15,
                ),
              ),
              onMapReady: (mapController) async {
                if (place != null && place!.hasCoordinates) {
                  await mapController.addOverlay(
                    NMarker(id: 'selected-place', position: target),
                  );
                }
              },
            ),
            if (place == null)
              Container(
                color: Colors.white.withValues(alpha: 0.8),
                alignment: Alignment.center,
                child: const Text('장소를 선택하면 이 영역에 위치가 표시됩니다.'),
              ),
            if (isLoading)
              Container(
                color: Colors.white.withValues(alpha: 0.72),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

class _LoadingPlaceList extends StatelessWidget {
  const _LoadingPlaceList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
        3,
        (index) => Container(
          margin: EdgeInsets.only(bottom: index == 2 ? 0 : 12),
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.subtleBackground,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.subtleBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, size: 34, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.subtleBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(body, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.errorText,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final String placeholder;
  final String? errorText;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = value.isNotEmpty;
    final borderColor = errorText != null
        ? AppColors.error
        : AppColors.fieldBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    hasValue ? value : placeholder,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: hasValue
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                Icon(icon, color: AppColors.textSecondary, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MultilineField extends StatefulWidget {
  const _MultilineField({
    required this.controller,
    required this.hintText,
    required this.maxLength,
    required this.errorText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLength;
  final String? errorText;
  final ValueChanged<String> onChanged;

  @override
  State<_MultilineField> createState() => _MultilineFieldState();
}

class _MultilineFieldState extends State<_MultilineField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.errorText != null
        ? AppColors.error
        : _focusNode.hasFocus
        ? AppColors.textPrimary
        : AppColors.fieldBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                minLines: 6,
                maxLines: 10,
                maxLength: widget.maxLength,
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: widget.hintText,
                  border: InputBorder.none,
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                '${widget.controller.text.length}/${widget.maxLength}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        if (widget.errorText != null) ...<Widget>[
          const SizedBox(height: 8),
          _InlineErrorText(text: widget.errorText!),
        ],
      ],
    );
  }
}

class _CapacityStepper extends StatelessWidget {
  const _CapacityStepper({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: <Widget>[
          _CircleIconButton(
            icon: Icons.remove_rounded,
            onTap: value <= 2 ? null : () => onChanged(value - 1),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text('$value명', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  '최소 2명, 최대 20명',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          _CircleIconButton(
            icon: Icons.add_rounded,
            onTap: value >= 20 ? null : () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.disabledSurface
              : AppColors.subtleBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: disabled ? AppColors.disabledText : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
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
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.textPrimary
                : AppColors.fieldBorderLight,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.image,
    required this.onRemove,
    required this.onSetPrimary,
  });

  final CreateImageAsset image;
  final VoidCallback onRemove;
  final VoidCallback onSetPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 144,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: image.isPrimary ? AppColors.brandGreen : AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: <Widget>[
                Image.file(
                  File(image.path),
                  width: 144,
                  height: 112,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: image.isPrimary
                          ? AppColors.brandGreen
                          : Colors.black.withValues(alpha: 0.56),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      image.isPrimary ? '대표' : '이미지',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: Colors.black.withValues(alpha: 0.42),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onRemove,
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  image.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: image.isPrimary ? null : onSetPrimary,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(36),
                      side: BorderSide(
                        color: image.isPrimary
                            ? AppColors.disabledButton
                            : AppColors.fieldBorderLight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(image.isPrimary ? '대표 사진' : '대표로 지정'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineErrorText extends StatelessWidget {
  const _InlineErrorText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(
            Icons.warning_amber_rounded,
            size: 16,
            color: AppColors.error,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}
