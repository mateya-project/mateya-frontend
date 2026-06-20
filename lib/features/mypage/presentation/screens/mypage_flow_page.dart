import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/app_config.dart';
import '../../../../shared/activity_categories/activity_category_repository.dart';
import '../../../../shared/auth/auth_session.dart';
import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/media/mateya_gallery_picker.dart';
import '../../../../shared/navigation/mateya_auth_flow.dart';
import '../../../../shared/permissions/mateya_permission_dialogs.dart';
import '../../../../shared/platform/external_url_launcher.dart';
import '../../../../shared/theme/app_responsive.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_motion.dart';
import '../../../../shared/widgets/mateya_text_field.dart';
import '../../../../shared/widgets/mateya_report_sheet.dart';
import '../../../create/application/create_controller.dart';
import '../../../create/data/create_repository.dart';
import '../../../create/domain/create_models.dart';
import '../../../create/presentation/screens/create_flow_page.dart';
import '../../../onboarding/data/location_repository.dart';
import '../../../onboarding/domain/onboarding_flow.dart';
import '../../../onboarding/domain/onboarding_terms.dart';
import '../../../onboarding/presentation/screens/onboarding_terms_detail_page.dart';
import '../../../onboarding/presentation/widgets/onboarding_shared_widgets.dart';
import '../../application/mypage_controller.dart';
import '../../domain/mypage_models.dart';
import '../widgets/mypage_badge_celebration_dialog.dart';
import '../widgets/mypage_route_views.dart';
import '../widgets/mypage_status_widgets.dart';

class MyPageFlowPage extends StatefulWidget {
  const MyPageFlowPage({super.key, required this.controller, this.onRootBack});

  final MyPageController controller;
  final VoidCallback? onRootBack;

  @override
  State<MyPageFlowPage> createState() => _MyPageFlowPageState();
}

class _MyPageFlowPageState extends State<MyPageFlowPage> {
  final ImagePicker _imagePicker = ImagePicker();
  final NeighborhoodLocationRepository _locationRepository =
      DeviceNeighborhoodLocationRepository();
  final TextEditingController _businessIntroductionController =
      TextEditingController();
  final TextEditingController _englishNameController = TextEditingController();
  final TextEditingController _withdrawalSignatureController =
      TextEditingController();

  String? _selectedPrimaryLanguageCode;
  String? _selectedPrimaryCountryCode;
  int _lastToastVersion = 0;
  int _lastBadgeCelebrationVersion = 0;
  bool _withdrawalAgreement = false;

  @override
  void initState() {
    super.initState();
    _businessIntroductionController.addListener(_handleLocalFieldChanged);
    widget.controller.addListener(_handleControllerChanged);
    widget.controller.initialize();
  }

  @override
  void didUpdateWidget(covariant MyPageFlowPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) {
      return;
    }
    oldWidget.controller.removeListener(_handleControllerChanged);
    widget.controller.addListener(_handleControllerChanged);
    widget.controller.initialize();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    _businessIntroductionController.removeListener(_handleLocalFieldChanged);
    _businessIntroductionController.dispose();
    _englishNameController.dispose();
    _withdrawalSignatureController.dispose();
    super.dispose();
  }

  void _handleLocalFieldChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleControllerChanged() {
    if (!mounted) {
      return;
    }
    final controller = widget.controller;
    if (controller.toastMessage != null &&
        controller.toastVersion != _lastToastVersion) {
      _lastToastVersion = controller.toastVersion;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(controller.toastMessage!)));
      controller.clearToast();
    }
    if (controller.activeBadgeCelebration != null &&
        controller.badgeCelebrationVersion != _lastBadgeCelebrationVersion) {
      _lastBadgeCelebrationVersion = controller.badgeCelebrationVersion;
      unawaited(
        _showBadgeCelebrationDialog(controller.activeBadgeCelebration!),
      );
    }
  }

  Future<void> _showBadgeCelebrationDialog(ActivityBadge badge) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return MyPageBadgeCelebrationDialog(
          badge: badge,
          onClose: () => Navigator.of(dialogContext).pop(),
        );
      },
    );
    if (!mounted) {
      return;
    }
    widget.controller.dismissBadgeCelebration();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        _syncFormValues();
        return Material(
          color: AppColors.background,
          child: SafeArea(
            child: MateyaFadeSlideSwitcher(
              duration: const Duration(milliseconds: 240),
              child: switch (widget.controller.phase) {
                MyPageAsyncPhase.idle ||
                MyPageAsyncPhase.loading => const MyPageLoadingView(),
                MyPageAsyncPhase.networkError ||
                MyPageAsyncPhase.serverError => MyPageRetryView(
                  message:
                      widget.controller.errorMessage ?? l10n.mypageLoadError,
                  onRetry: _handleRetry,
                  onBack: _buildRetryBackAction(),
                ),
                MyPageAsyncPhase.success ||
                MyPageAsyncPhase.validationError => _buildRouteView(),
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildRouteView() {
    final controller = widget.controller;

    return switch (controller.route) {
      MyPageRoute.personalHome => PersonalMyPageView(
        key: const ValueKey<String>('personal-home'),
        data: controller.personalPage!,
        isUpdatingProfileImage: controller.isUpdatingProfileImage,
        onBack: widget.onRootBack,
        onOpenRecentActivities: controller.openRecentActivities,
        onEditHostedActivity: (activity) {
          _openActivityEditFlow(activity, CreateFlowType.group);
        },
        onEditProfileImage: _pickProfileImage,
        onOpenSettings: controller.openSettings,
      ),
      MyPageRoute.otherProfile => OtherProfileView(
        key: const ValueKey<String>('other-profile'),
        data: controller.otherProfile!,
        isBusy:
            controller.isUpdatingFriendship ||
            controller.isUpdatingBlockedUsers,
        onBack:
            widget.onRootBack != null &&
                controller.initialOtherProfileUserId != null &&
                controller.initialOtherProfileUserId!.isNotEmpty
            ? widget.onRootBack!
            : controller.openPersonalHome,
        onFriendTap: () {
          controller.toggleFriendship();
        },
        onBlockTap: () {
          controller.blockCurrentOtherProfile();
        },
      ),
      MyPageRoute.recentActivities => RecentActivitiesView(
        key: const ValueKey<String>('recent-activities'),
        data: controller.recentActivity!,
        onBack: controller.openPersonalHome,
        onEditHostedActivity: (activity) {
          _openActivityEditFlow(activity, CreateFlowType.group);
        },
      ),
      MyPageRoute.settings => SettingsView(
        key: const ValueKey<String>('settings'),
        profile: controller.personalPage!.profile,
        onBack: controller.openPersonalHome,
        onReport: _openGeneralReportSheet,
        onEditPrimaryPreferences: _openPrimaryPreferences,
        onEditActivityRegion: _openActivityRegionDialog,
        onOpenConsentHistory: controller.openConsentHistory,
        onOpenPrivacyPolicy: _openPrivacyPolicy,
        onOpenCustomerSupport: _openCustomerSupport,
        onOpenBlockedUsers: controller.openBlockedUsers,
        onLogout: _logout,
        onWithdrawal: _openWithdrawalDialog,
      ),
      MyPageRoute.primaryPreferences => PrimaryPreferencesView(
        key: const ValueKey<String>('primary-preferences'),
        currentLanguageCode: _selectedPrimaryLanguageCode,
        currentCountryCode: _selectedPrimaryCountryCode,
        languageOptions: controller.languageOptions,
        countryOptions: controller.countryOptions,
        englishNameController: _englishNameController,
        isSaving: controller.isSavingPreferences,
        errorText: controller.phase == MyPageAsyncPhase.validationError
            ? controller.errorMessage
            : null,
        onBack: controller.openSettings,
        onLanguageChanged: (value) {
          setState(() {
            _selectedPrimaryLanguageCode = value;
          });
        },
        onCountryChanged: (value) {
          setState(() {
            _selectedPrimaryCountryCode = value;
          });
        },
        onSave: () {
          controller.updatePrimaryPreferences(
            englishName: _englishNameController.text,
            languageCode: _selectedPrimaryLanguageCode ?? '',
            countryCode: _selectedPrimaryCountryCode ?? '',
          );
        },
      ),
      MyPageRoute.consentHistory => ConsentHistoryView(
        key: const ValueKey<String>('consent-history'),
        entries: controller.consentHistory,
        onBack: controller.openSettings,
        onOpenDetail: _openConsentHistoryDetail,
      ),
      MyPageRoute.blockedUsers => BlockedUsersView(
        key: const ValueKey<String>('blocked-users'),
        users: controller.blockedUsers,
        onBack: controller.openSettings,
        onUnblock: (userId) {
          controller.unblockUser(userId);
        },
      ),
      MyPageRoute.businessHome => BusinessMyPageView(
        key: const ValueKey<String>('business-home'),
        data: controller.businessPage!,
        introductionController: _businessIntroductionController,
        isSaving: controller.isSavingBusinessIntroduction,
        isUpdatingProfileImage: controller.isUpdatingProfileImage,
        isUpdatingActivityRegion: controller.isUpdatingActivityRegion,
        errorText: controller.phase == MyPageAsyncPhase.validationError
            ? controller.errorMessage
            : null,
        onEditActivity: (activity) {
          _openActivityEditFlow(activity, CreateFlowType.classRegistration);
        },
        onEditProfileImage: _pickProfileImage,
        onEditActivityRegion: _openActivityRegionDialog,
        onSave: () {
          controller.updateBusinessIntroduction(
            _businessIntroductionController.text,
          );
        },
      ),
    };
  }

  VoidCallback? _buildRetryBackAction() {
    final controller = widget.controller;

    return switch (controller.route) {
      MyPageRoute.otherProfile =>
        widget.onRootBack != null &&
                controller.initialOtherProfileUserId != null &&
                controller.initialOtherProfileUserId!.isNotEmpty
            ? widget.onRootBack!
            : controller.openPersonalHome,
      MyPageRoute.recentActivities => controller.openPersonalHome,
      MyPageRoute.settings => controller.openPersonalHome,
      MyPageRoute.primaryPreferences => controller.openSettings,
      MyPageRoute.consentHistory => controller.openSettings,
      MyPageRoute.blockedUsers => controller.openSettings,
      MyPageRoute.personalHome || MyPageRoute.businessHome => widget.onRootBack,
    };
  }

  void _handleRetry() {
    switch (widget.controller.route) {
      case MyPageRoute.otherProfile:
        unawaited(widget.controller.openOtherProfile());
        return;
      case MyPageRoute.personalHome:
      case MyPageRoute.recentActivities:
      case MyPageRoute.settings:
      case MyPageRoute.primaryPreferences:
      case MyPageRoute.consentHistory:
      case MyPageRoute.blockedUsers:
      case MyPageRoute.businessHome:
        unawaited(widget.controller.retry());
        return;
    }
  }

  Future<void> _openGeneralReportSheet() {
    return showMateyaReportSheet(context, subjectLabel: context.l10n.appTitle);
  }

  void _openPrimaryPreferences() {
    final profile = widget.controller.personalPage?.profile;
    setState(() {
      _selectedPrimaryLanguageCode = profile?.primaryLanguageCode;
      _selectedPrimaryCountryCode = profile?.primaryCountryCode;
      _englishNameController.value = TextEditingValue(
        text: profile?.englishName ?? '',
        selection: TextSelection.collapsed(
          offset: (profile?.englishName ?? '').length,
        ),
      );
    });
    widget.controller.openPrimaryPreferences();
  }

  void _syncFormValues() {
    final businessIntroduction =
        widget.controller.businessPage?.profile.oneLineIntroduction ?? '';
    if (_businessIntroductionController.text != businessIntroduction) {
      _businessIntroductionController.value = TextEditingValue(
        text: businessIntroduction,
        selection: TextSelection.collapsed(offset: businessIntroduction.length),
      );
    }
  }

  Future<void> _openConsentHistoryDetail(ConsentHistoryEntry entry) async {
    final document = onboardingTermsDocumentForConsent(
      consentId: entry.id,
      title: entry.title,
    );
    if (document == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.mypageTermsDetailUnavailable)),
      );
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => OnboardingTermsDetailPage(document: document),
      ),
    );
  }

  Future<void> _openWithdrawalDialog() async {
    widget.controller.clearError();
    _withdrawalAgreement = false;
    _withdrawalSignatureController.clear();

    await showDialog<void>(
      context: context,
      barrierDismissible: !widget.controller.isSubmittingWithdrawal,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.primaryRadius),
          ),
          child: ConstrainedBox(
            constraints: AppResponsive.dialogConstraints(
              context,
              maxWidth: 440,
              maxHeightFactor: 0.9,
            ),
            child: SingleChildScrollView(
              child: AnimatedBuilder(
                animation: widget.controller,
                builder: (context, _) {
                  return MyPageWithdrawalDialog(
                    controller: widget.controller,
                    signatureController: _withdrawalSignatureController,
                    withdrawalAgreement: _withdrawalAgreement,
                    onAgreementChanged: (value) {
                      setState(() {
                        _withdrawalAgreement = value;
                      });
                    },
                    onClose: () => Navigator.of(dialogContext).pop(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openCustomerSupport() async {
    await _openExternalLinkWithCopyFallback(
      AppConfig.customerSupportUrl,
      failureMessage: context.l10n.mypageSupportLinkCopied,
    );
  }

  Future<void> _openPrivacyPolicy() async {
    await _openExternalLinkWithCopyFallback(
      AppConfig.privacyPolicyUrl,
      failureMessage: context.l10n.mypagePrivacyLinkCopied,
    );
  }

  Future<void> _openExternalLinkWithCopyFallback(
    String url, {
    required String failureMessage,
  }) async {
    final opened = await openExternalUrl(url);
    if (opened || !mounted) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failureMessage)));
  }

  Future<void> _openActivityEditFlow(
    ActivityHistoryEntry activity,
    CreateFlowType flowType,
  ) async {
    final hasSession = AuthSessionStore.instance.hasSession;
    if (!hasSession) {
      if (!mounted) {
        return;
      }
      await replaceWithMateyaOnboardingFlow(context);
      return;
    }
    final didChange = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CreateFlowPage(
          controller: CreateController(
            repository: ApiCreateRepository(),
            categoryRepository: ApiActivityCategoryRepository(),
            flowType: flowType,
            isEditMode: true,
            editingId: activity.id,
          ),
        ),
      ),
    );
    if (!mounted || didChange != true) {
      return;
    }
    await widget.controller.retry();
  }

  Future<void> _pickProfileImage() async {
    if (widget.controller.isUpdatingProfileImage) {
      return;
    }

    final pickedFile = await pickMateyaGalleryImage(
      context,
      imagePicker: _imagePicker,
      messages: _buildProfileImagePickerMessages(context),
      maxWidth: 2400,
    );
    if (!mounted || pickedFile == null) {
      return;
    }
    await widget.controller.updateProfileImage(pickedFile.path);
  }

  Future<void> _openActivityRegionDialog() async {
    final l10n = context.l10n;
    final manualController = TextEditingController();
    var selectedNeighborhood = _sessionNeighborhoodSelection();
    var isResolvingCurrent = false;
    var isResolvingManual = false;
    var errorText = '';

    widget.controller.clearError();

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              Future<void> resolveCurrent() async {
                setDialogState(() {
                  isResolvingCurrent = true;
                  errorText = '';
                });
                final result = await _locationRepository
                    .resolveCurrentNeighborhood();
                if (!mounted) {
                  return;
                }
                if (result.isSuccess && result.selection != null) {
                  setDialogState(() {
                    selectedNeighborhood = result.selection;
                    isResolvingCurrent = false;
                    errorText = '';
                    manualController.text = result.selection!.displayName;
                  });
                  return;
                }

                setDialogState(() {
                  isResolvingCurrent = false;
                  errorText =
                      result.failure?.message ??
                      l10n.mypageCurrentLocationResolveError;
                });
                if (result.failure != null) {
                  await _handleActivityRegionLocationFailure(result.failure!);
                }
              }

              Future<void> resolveManual() async {
                final trimmed = manualController.text.trim();
                if (trimmed.isEmpty) {
                  setDialogState(() {
                    errorText = l10n.mypageNeighborhoodRequired;
                  });
                  return;
                }
                setDialogState(() {
                  isResolvingManual = true;
                  errorText = '';
                });
                final result = await _locationRepository
                    .resolveNeighborhoodQuery(trimmed);
                if (!mounted) {
                  return;
                }
                setDialogState(() {
                  isResolvingManual = false;
                  if (result.isSuccess && result.selection != null) {
                    selectedNeighborhood = result.selection;
                    errorText = '';
                  } else {
                    selectedNeighborhood = null;
                    errorText =
                        result.failure?.message ??
                        l10n.mypageNeighborhoodLookupError;
                  }
                });
              }

              Future<void> submit() async {
                if (selectedNeighborhood == null) {
                  setDialogState(() {
                    errorText = l10n.mypageNeighborhoodVerificationRequired;
                  });
                  return;
                }
                final didUpdate = await widget.controller.updateActivityRegion(
                  selectedNeighborhood!,
                );
                if (!mounted) {
                  return;
                }
                if (didUpdate) {
                  if (!dialogContext.mounted) {
                    return;
                  }
                  Navigator.of(dialogContext).pop();
                  return;
                }
                setDialogState(() {
                  errorText =
                      widget.controller.errorMessage ??
                      l10n.mypageActivityRegionSaveError;
                });
              }

              final isBusy =
                  isResolvingCurrent ||
                  isResolvingManual ||
                  widget.controller.isUpdatingActivityRegion;

              return Dialog(
                backgroundColor: Colors.white,
                insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.primaryRadius),
                ),
                child: ConstrainedBox(
                  constraints: AppResponsive.dialogConstraints(
                    context,
                    maxWidth: 520,
                    maxHeightFactor: 0.9,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                l10n.mypageEditActivityRegion,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            IconButton(
                              onPressed: isBusy
                                  ? null
                                  : () => Navigator.of(dialogContext).pop(),
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ],
                        ),
                        Text(
                          l10n.mypageActivityRegionDialogDescription,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        NeighborhoodMapCard(
                          selection: selectedNeighborhood,
                          isLoading: isResolvingCurrent || isResolvingManual,
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: isBusy ? null : resolveCurrent,
                          icon: const Icon(Icons.my_location_rounded),
                          label: Text(
                            isResolvingCurrent
                                ? l10n.mypageResolvingCurrentLocation
                                : l10n.onboardingUseCurrentLocation,
                          ),
                        ),
                        const SizedBox(height: 16),
                        MateyaTextField(
                          controller: manualController,
                          hintText: l10n.onboardingNeighborhoodHint,
                          onSubmitted: (_) => resolveManual(),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: isBusy ? null : resolveManual,
                            child: Text(
                              isResolvingManual
                                  ? l10n.mypageResolvingNeighborhood
                                  : l10n.mypageConfirmManualNeighborhood,
                            ),
                          ),
                        ),
                        if (selectedNeighborhood != null) ...<Widget>[
                          const SizedBox(height: 8),
                          Text(
                            l10n.mypageSelectedActivityRegion(
                              selectedNeighborhood!.displayName,
                            ),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.brandGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                        if (errorText.isNotEmpty) ...<Widget>[
                          const SizedBox(height: 12),
                          Text(
                            errorText,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.error),
                          ),
                        ],
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: isBusy ? null : submit,
                            child: Text(
                              widget.controller.isUpdatingActivityRegion
                                  ? l10n.mypageSaving
                                  : l10n.mypageSaveActivityRegion,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    } finally {
      manualController.dispose();
    }
  }

  NeighborhoodSelection? _sessionNeighborhoodSelection() {
    final user = AuthSessionStore.instance.session?.user;
    if (user?.activityRegionName == null ||
        user?.activityLatitude == null ||
        user?.activityLongitude == null) {
      return null;
    }
    return NeighborhoodSelection(
      displayName: user!.activityRegionName!,
      latitude: user.activityLatitude!,
      longitude: user.activityLongitude!,
    );
  }

  Future<void> _handleActivityRegionLocationFailure(
    LocationFailure failure,
  ) async {
    final l10n = context.l10n;
    switch (failure.type) {
      case LocationFailureType.serviceDisabled:
        await showMateyaLocationSettingsDialog(
          context,
          title: l10n.locationServiceDisabledTitle,
          message: l10n.mypageLocationServiceDisabledMessage,
        );
        break;
      case LocationFailureType.permissionPermanentlyDenied:
        await showMateyaAppSettingsDialog(
          context,
          title: l10n.locationPermissionDisabledTitle,
          message: l10n.mypageLocationPermissionDisabledMessage,
        );
        break;
      case LocationFailureType.permissionDenied ||
          LocationFailureType.accuracyTooLow ||
          LocationFailureType.geocodingFailed ||
          LocationFailureType.locationUnavailable ||
          LocationFailureType.unknown:
        break;
    }
  }

  Future<void> _logout() async {
    final didLogout = await widget.controller.logout();
    if (!didLogout) {
      return;
    }

    await AuthSessionStore.instance.flush();
    if (!mounted) {
      return;
    }
    await replaceWithMateyaOnboardingFlow(context);
  }
}

MateyaGalleryPickerMessages _buildProfileImagePickerMessages(
  BuildContext context,
) {
  final l10n = context.l10n;
  return MateyaGalleryPickerMessages(
    noticeMessage: l10n.mypageProfileImageNotice,
    recoveryMessage: l10n.mypageProfileImageRecovery,
    failureMessage: l10n.mypageProfileImageFailure,
    restoreFallbackErrorMessage: l10n.mypageProfileImageRestoreFallback,
    restoredCountMessage: (restoredCount) =>
        l10n.mypageProfileImageRestoredCount(restoredCount),
  );
}
