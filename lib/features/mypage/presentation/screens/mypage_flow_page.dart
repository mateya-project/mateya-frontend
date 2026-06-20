import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/app_config.dart';
import '../../../../shared/activity_categories/activity_category_repository.dart';
import '../../../../shared/auth/auth_session.dart';
import '../../../../shared/media/mateya_gallery_picker.dart';
import '../../../../shared/navigation/mateya_auth_flow.dart';
import '../../../../shared/permissions/mateya_permission_dialogs.dart';
import '../../../../shared/platform/external_url_launcher.dart';
import '../../../../shared/theme/app_tokens.dart';
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
  static const MateyaGalleryPickerMessages
  _profileImagePickerMessages = MateyaGalleryPickerMessages(
    noticeMessage:
        '프로필 사진을 변경하려면 사진 보관함 접근 권한이 필요합니다. 권한을 거부하면 현재 프로필 사진은 유지됩니다.',
    recoveryMessage:
        '프로필 사진을 변경하려면 사진 보관함 접근 권한이 필요합니다. 다시 시도하거나 앱 설정에서 권한을 허용할 수 있습니다.',
    failureMessage: '프로필 사진을 불러오지 못했어요. 권한과 파일 상태를 확인해 주세요.',
    restoreFallbackErrorMessage: '이전에 선택하던 프로필 이미지를 복구하지 못했어요. 다시 선택해 주세요.',
    restoredCountMessage: _profileImageRestoredCountMessage,
  );

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
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        _syncFormValues();
        return Material(
          color: AppColors.background,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: switch (widget.controller.phase) {
              MyPageAsyncPhase.idle ||
              MyPageAsyncPhase.loading => const MyPageLoadingView(),
              MyPageAsyncPhase.networkError ||
              MyPageAsyncPhase.serverError => MyPageRetryView(
                message: widget.controller.errorMessage ?? '마이페이지를 불러오지 못했어요.',
                onRetry: widget.controller.retry,
              ),
              MyPageAsyncPhase.success ||
              MyPageAsyncPhase.validationError => _buildRouteView(),
            },
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

  Future<void> _openGeneralReportSheet() {
    return showMateyaReportSheet(context, subjectLabel: 'MateYa');
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('상세 약관을 아직 준비하지 못했어요.')));
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
        );
      },
    );
  }

  Future<void> _openCustomerSupport() async {
    await _openExternalLinkWithCopyFallback(
      AppConfig.customerSupportUrl,
      failureMessage: '문의 링크를 열지 못해 주소를 복사했어요.',
    );
  }

  Future<void> _openPrivacyPolicy() async {
    await _openExternalLinkWithCopyFallback(
      AppConfig.privacyPolicyUrl,
      failureMessage: '개인정보처리방침 링크를 열지 못해 주소를 복사했어요.',
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
      messages: _profileImagePickerMessages,
      maxWidth: 2400,
    );
    if (!mounted || pickedFile == null) {
      return;
    }
    await widget.controller.updateProfileImage(pickedFile.path);
  }

  Future<void> _openActivityRegionDialog() async {
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
                  errorText = result.failure?.message ?? '현재 위치를 확인하지 못했어요.';
                });
                if (result.failure != null) {
                  await _handleActivityRegionLocationFailure(result.failure!);
                }
              }

              Future<void> resolveManual() async {
                final trimmed = manualController.text.trim();
                if (trimmed.isEmpty) {
                  setDialogState(() {
                    errorText = '동네명을 입력해 주세요.';
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
                    errorText = result.failure?.message ?? '입력한 동네를 찾지 못했어요.';
                  }
                });
              }

              Future<void> submit() async {
                if (selectedNeighborhood == null) {
                  setDialogState(() {
                    errorText = '현재 위치 인증 또는 직접 입력 확인이 필요해요.';
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
                      widget.controller.errorMessage ?? '활동 지역을 저장하지 못했어요.';
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
                              '활동 지역 변경',
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
                        '현재 위치 인증 또는 직접 입력으로 활동 지역을 변경할 수 있어요.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
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
                          isResolvingCurrent ? '현재 위치 확인 중...' : '현재 위치로 인증하기',
                        ),
                      ),
                      const SizedBox(height: 16),
                      MateyaTextField(
                        controller: manualController,
                        hintText: '우만동',
                        onSubmitted: (_) => resolveManual(),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isBusy ? null : resolveManual,
                          child: Text(
                            isResolvingManual ? '동네 확인 중...' : '직접 입력 확인',
                          ),
                        ),
                      ),
                      if (selectedNeighborhood != null) ...<Widget>[
                        const SizedBox(height: 8),
                        Text(
                          '선택된 활동 지역: ${selectedNeighborhood!.displayName}',
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
                                ? '저장 중...'
                                : '활동 지역 저장',
                          ),
                        ),
                      ),
                    ],
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
    switch (failure.type) {
      case LocationFailureType.serviceDisabled:
        await showMateyaLocationSettingsDialog(
          context,
          title: '위치 서비스가 꺼져 있어요',
          message:
              '현재 위치로 활동 지역을 변경하려면 기기 위치 서비스를 켜야 합니다. 켜지 않아도 직접 입력으로 계속 진행할 수 있습니다.',
        );
        break;
      case LocationFailureType.permissionPermanentlyDenied:
        await showMateyaAppSettingsDialog(
          context,
          title: '위치 권한이 꺼져 있어요',
          message:
              '현재 위치 자동 인증을 사용하려면 앱 설정에서 위치 권한을 허용해야 합니다. 권한을 허용하지 않아도 직접 입력은 계속할 수 있습니다.',
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

String _profileImageRestoredCountMessage(int restoredCount) {
  return '이전에 선택하던 프로필 이미지 $restoredCount장을 복구했어요.';
}
