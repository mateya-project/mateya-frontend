import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/media/mateya_gallery_picker.dart';
import '../../../../shared/theme/app_responsive.dart';
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
    _initializePage();
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

  Future<void> _initializePage() async {
    await widget.controller.initialize();
    if (!mounted) {
      return;
    }

    await _restoreLostImages(suppressErrorMessage: true);
  }

  Future<void> _restoreLostImages({bool suppressErrorMessage = false}) async {
    await restoreLostMateyaGalleryImages(
      context: context,
      readLostData: _imagePicker.retrieveLostData,
      availableSlots:
          CreateController.maxImageCount - widget.controller.images.length,
      messages: _galleryPickerMessages(context),
      suppressErrorMessage: suppressErrorMessage,
      onRestored: widget.controller.addImages,
    );
  }

  Future<void> _pickImages() async {
    final remaining =
        CreateController.maxImageCount - widget.controller.images.length;
    if (remaining <= 0) {
      return;
    }

    final picked = await pickMateyaGalleryImages(
      context,
      imagePicker: _imagePicker,
      availableSlots: remaining,
      messages: _galleryPickerMessages(context),
      maxWidth: 2400,
    );
    if (!mounted || picked.isEmpty) {
      return;
    }
    await widget.controller.addImages(picked);
  }

  Future<void> _pickEventDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      initialDate: widget.controller.eventDate ?? today,
      helpText: context.l10n.createEventDatePickerHelp(
        widget.controller.flowType.entityLabel,
      ),
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
      helpText: context.l10n.createStartTimePickerHelp,
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
      helpText: context.l10n.createEndTimePickerHelp,
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
      helpText: context.l10n.createDeadlineDatePickerHelp,
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
      helpText: context.l10n.createDeadlineTimePickerHelp,
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
        final l10n = context.l10n;
        return AlertDialog(
          title: Text(
            l10n.createDeleteDialogTitle(
              widget.controller.flowType.entityLabel,
            ),
          ),
          content: Text(
            l10n.createDeleteDialogBody(widget.controller.flowType.entityLabel),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(l10n.createDeleteButton),
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
    ).showSnackBar(SnackBar(content: Text(context.l10n.createDeleteCompleted)));
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
    final l10n = context.l10n;
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
                        l10n.createInitializationLoadError(
                          widget.controller.flowType.entityLabel,
                        ),
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.createInitializationRetryBody,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      MateyaButton(
                        label: l10n.commonRetry,
                        onPressed: widget.controller.retryInitializeEditDraft,
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.createBackToPrevious),
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
                if (widget.controller.step == CreateStep.completed)
                  CreateFlowHeader(
                    title: widget.controller.screenTitle,
                    progressLabel: l10n.createCompletedProgress,
                    onBack: _handleBack,
                  )
                else
                  CreateFlowProgressHeader(
                    flowType: widget.controller.flowType,
                    steps: widget.controller.steps,
                    currentStep: widget.controller.step,
                    onBack: _handleBack,
                  ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: AppResponsive.contentMaxWidth(
                          context,
                          phone: 600,
                          tablet: 760,
                        ),
                      ),
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
                  ),
                ),
                if (widget.controller.step != CreateStep.completed)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppResponsive.horizontalPadding(context),
                      12,
                      AppResponsive.horizontalPadding(context),
                      AppResponsive.keyboardAwareBottomPadding(
                        context,
                        minimum: 20,
                      ),
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: AppResponsive.contentMaxWidth(context),
                        ),
                        child: MateyaButton(
                          label: _submitButtonLabel(),
                          trailingIcon: _submitButtonTrailingIcon(),
                          enabled: widget.controller.canContinueCurrentStep,
                          onPressed: _handlePrimaryAction,
                        ),
                      ),
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
    final l10n = MateyaLocalizations.current;
    if (widget.controller.step == CreateStep.details) {
      if (widget.controller.submitPhase == AsyncPhase.loading) {
        return widget.controller.isEditMode
            ? l10n.createSavingEntity(widget.controller.flowType.entityLabel)
            : l10n.createSubmittingEntity(
                widget.controller.flowType.entityLabel,
              );
      }
      return widget.controller.submitActionLabel;
    }
    if (widget.controller.step == CreateStep.category) {
      return l10n.createSelectPlaceAction;
    }
    return l10n.commonNext;
  }

  IconData? _submitButtonTrailingIcon() {
    return widget.controller.step == CreateStep.category
        ? Icons.arrow_forward_rounded
        : null;
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

MateyaGalleryPickerMessages _galleryPickerMessages(BuildContext context) {
  final l10n = context.l10n;
  return MateyaGalleryPickerMessages(
    noticeMessage: l10n.createImagePickerNotice,
    recoveryMessage: l10n.createImagePickerRecovery,
    failureMessage: l10n.createImagePickerFailure,
    restoreFallbackErrorMessage: l10n.createImagePickerRestoreFallback,
    restoredCountMessage: (restoredCount) =>
        l10n.createImagePickerRestoredCount(restoredCount),
  );
}
