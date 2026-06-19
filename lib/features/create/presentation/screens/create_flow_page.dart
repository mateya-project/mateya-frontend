import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/media/image_picker_lost_data.dart';
import '../../../../shared/permissions/mateya_permission_dialogs.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../onboarding/domain/onboarding_flow.dart';
import '../../application/create_controller.dart';
import '../../domain/create_models.dart';
import '../widgets/create_details_step.dart';
import '../widgets/create_overview_steps.dart';
import '../widgets/create_place_step.dart';

class CreateFlowPage extends StatefulWidget {
  const CreateFlowPage({super.key, required this.controller});

  final CreateController controller;

  @override
  State<CreateFlowPage> createState() => _CreateFlowPageState();
}

class _CreateFlowPageState extends State<CreateFlowPage> {
  final ImagePicker _imagePicker = ImagePicker();
  final ScrollController _detailsScrollController = ScrollController();
  final Map<String, GlobalKey> _detailSectionKeys = <String, GlobalKey>{
    'title': GlobalKey(),
    'description': GlobalKey(),
    'eventDate': GlobalKey(),
    'time': GlobalKey(),
    'participantCapacity': GlobalKey(),
    'deadline': GlobalKey(),
    'languages': GlobalKey(),
    'priceType': GlobalKey(),
    'price': GlobalKey(),
    'images': GlobalKey(),
  };
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
    _restoreLostImages();
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
    _detailsScrollController.dispose();
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

  Future<void> _restoreLostImages() async {
    final recovery = await recoverLostImagePickerData(
      _imagePicker.retrieveLostData,
      fallbackErrorMessage: '이전에 선택하던 이미지를 복구하지 못했어요. 다시 선택해 주세요.',
    );
    if (!mounted || recovery.isEmpty) {
      return;
    }
    if (recovery.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(recovery.errorMessage!)));
      return;
    }

    final available =
        CreateController.maxImageCount - widget.controller.images.length;
    if (available <= 0) {
      return;
    }

    final beforeCount = widget.controller.images.length;
    await widget.controller.addImages(recovery.files.take(available).toList());
    if (!mounted) {
      return;
    }

    final restoredCount = widget.controller.images.length - beforeCount;
    if (restoredCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이전에 선택하던 이미지 $restoredCount장을 복구했어요.')),
      );
    }
  }

  Future<void> _pickImages() async {
    final remaining =
        CreateController.maxImageCount - widget.controller.images.length;
    if (remaining <= 0) {
      return;
    }

    final shouldContinue = await showMateyaPermissionNoticeDialog(
      context,
      title: '사진 권한 안내',
      message:
          '활동 대표 이미지를 등록하기 위해 사진 보관함 접근 권한이 필요합니다. 권한을 거부하셔도 활동 정보 입력은 계속 진행할 수 있습니다.',
      confirmLabel: '사진 선택하기',
      cancelLabel: '나중에',
    );

    if (!mounted || !shouldContinue) {
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
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }
      if (error.code == 'photo_access_denied') {
        final action = await showMateyaPermissionRecoveryDialog(
          context,
          title: '사진 권한이 필요해요',
          message:
              '대표 이미지를 추가하려면 사진 보관함 접근 권한이 필요합니다. 권한이 없어도 활동 정보 입력은 계속할 수 있고, 다시 시도하거나 앱 설정에서 권한을 허용할 수 있습니다.',
          retryLabel: '다시 시도',
        );
        if (!mounted) {
          return;
        }
        if (action == MateyaPermissionRecoveryAction.retry) {
          await _pickImages();
          return;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 불러오지 못했어요. 권한과 파일 상태를 확인해 주세요.')),
      );
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
    final defaultLastDate = today.add(const Duration(days: 365));
    final eventDate = widget.controller.eventDate;
    final lastDate = eventDate != null && eventDate.isAfter(defaultLastDate)
        ? eventDate
        : defaultLastDate;
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

  Future<void> _handlePrimaryAction() async {
    final wasDetailsStep = widget.controller.step == CreateStep.details;
    await widget.controller.continueFlow();
    if (!mounted ||
        !wasDetailsStep ||
        widget.controller.step != CreateStep.details) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _scrollToFirstDetailError();
    });
  }

  void _scrollToFirstDetailError() {
    const errorOrder = <String>[
      'title',
      'description',
      'eventDate',
      'time',
      'participantCapacity',
      'deadline',
      'languages',
      'priceType',
      'price',
      'images',
    ];

    for (final field in errorOrder) {
      if (widget.controller.errorFor(field) == null) {
        continue;
      }
      final context = _detailSectionKeys[field]?.currentContext;
      if (context == null) {
        continue;
      }
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        alignment: 0.08,
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        if (widget.controller.isEditMode &&
            widget.controller.isInitializingEditDraft) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (widget.controller.isEditMode &&
            widget.controller.didFailInitializingEditDraft) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 52,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${widget.controller.flowType.entityLabel} 정보를 불러오지 못했어요.',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '잠시 후 다시 시도하거나 이전 화면으로 돌아가 주세요.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      MateyaButton(
                        label: '다시 시도',
                        onPressed: widget.controller.retryInitializeEditDraft,
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('뒤로 가기'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                CreateFlowHeader(
                  title: widget.controller.screenTitle,
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
                      onPressed: _handlePrimaryAction,
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
        return widget.controller.isEditMode
            ? '${widget.controller.flowType.entityLabel} 저장 중...'
            : '${widget.controller.flowType.entityLabel} 등록 중...';
      }
      return widget.controller.submitActionLabel;
    }
    return '다음';
  }

  Widget _buildStep(BuildContext context) {
    return switch (widget.controller.step) {
      CreateStep.category => CategoryStepView(
        key: const ValueKey<String>('category-step'),
        controller: widget.controller,
      ),
      CreateStep.place => PlaceStepView(
        key: const ValueKey<String>('place-step'),
        controller: widget.controller,
        searchController: _searchController,
        manualPlaceNameController: _manualPlaceNameController,
        manualPlaceAddressController: _manualPlaceAddressController,
        hasSearched: _hasSearched,
        onCategorySelected: widget.controller.chooseCategory,
        onCategoryDetailSelected: widget.controller.chooseCategoryDetail,
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
      CreateStep.details => DetailsStepView(
        key: const ValueKey<String>('details-step'),
        controller: widget.controller,
        scrollController: _detailsScrollController,
        sectionKeys: _detailSectionKeys,
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
      CreateStep.completed => CompletedStepView(
        key: const ValueKey<String>('completed-step'),
        controller: widget.controller,
        onDone: () => Navigator.of(context).pop(true),
      ),
    };
  }
}
