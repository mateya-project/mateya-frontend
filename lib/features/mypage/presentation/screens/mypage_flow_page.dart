import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/app_config.dart';
import '../../../../shared/auth/auth_session.dart';
import '../../../../shared/network/mateya_api_client.dart';
import '../../../../shared/permissions/mateya_permission_dialogs.dart';
import '../../../../shared/platform/external_url_launcher.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../onboarding/application/onboarding_controller.dart';
import '../../../onboarding/data/auth_repository.dart';
import '../../../onboarding/data/location_repository.dart';
import '../../../onboarding/presentation/screens/onboarding_flow_page.dart';
import '../../application/mypage_controller.dart';
import '../../domain/mypage_models.dart';
import '../widgets/mypage_route_views.dart';
import '../widgets/mypage_status_widgets.dart';

class MyPageFlowPage extends StatefulWidget {
  const MyPageFlowPage({super.key, required this.controller});

  final MyPageController controller;

  @override
  State<MyPageFlowPage> createState() => _MyPageFlowPageState();
}

class _MyPageFlowPageState extends State<MyPageFlowPage> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _businessIntroductionController =
      TextEditingController();
  final TextEditingController _withdrawalSignatureController =
      TextEditingController();

  int _lastToastVersion = 0;
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
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        _syncFormValues();
        return AnimatedSwitcher(
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
        onOpenRecentActivities: controller.openRecentActivities,
        onEditProfileImage: _pickProfileImage,
        onOpenSettings: controller.openSettings,
      ),
      MyPageRoute.otherProfile => OtherProfileView(
        key: const ValueKey<String>('other-profile'),
        data: controller.otherProfile!,
        isBusy: controller.isUpdatingFriendship,
        onBack: controller.openPersonalHome,
        onFriendTap: controller.toggleFriendship,
        onBlockTap: controller.blockCurrentOtherProfile,
      ),
      MyPageRoute.recentActivities => RecentActivitiesView(
        key: const ValueKey<String>('recent-activities'),
        data: controller.recentActivity!,
        onBack: controller.openPersonalHome,
      ),
      MyPageRoute.settings => SettingsView(
        key: const ValueKey<String>('settings'),
        profile: controller.personalPage!.profile,
        onOpenConsentHistory: controller.openConsentHistory,
        onOpenCustomerSupport: _openCustomerSupport,
        onOpenBlockedUsers: controller.openBlockedUsers,
        onLogout: _logout,
        onWithdrawal: _openWithdrawalDialog,
      ),
      MyPageRoute.consentHistory => ConsentHistoryView(
        key: const ValueKey<String>('consent-history'),
        entries: controller.consentHistory,
        onBack: controller.openSettings,
      ),
      MyPageRoute.blockedUsers => BlockedUsersView(
        key: const ValueKey<String>('blocked-users'),
        users: controller.blockedUsers,
        onBack: controller.openSettings,
        onUnblock: controller.unblockUser,
      ),
      MyPageRoute.businessHome => BusinessMyPageView(
        key: const ValueKey<String>('business-home'),
        data: controller.businessPage!,
        introductionController: _businessIntroductionController,
        isSaving: controller.isSavingBusinessIntroduction,
        isUpdatingProfileImage: controller.isUpdatingProfileImage,
        errorText: controller.phase == MyPageAsyncPhase.validationError
            ? controller.errorMessage
            : null,
        onEditProfileImage: _pickProfileImage,
        onSave: () {
          controller.updateBusinessIntroduction(
            _businessIntroductionController.text,
          );
        },
      ),
    };
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
    const url = 'https://pf.kakao.com/_EPxmXX/friend';
    final opened = await openExternalUrl(url);
    if (opened || !mounted) {
      return;
    }

    await Clipboard.setData(const ClipboardData(text: url));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('문의 링크를 열지 못해 주소를 복사했어요.')));
  }

  Future<void> _pickProfileImage() async {
    if (widget.controller.isUpdatingProfileImage) {
      return;
    }

    final shouldContinue = await showMateyaPermissionNoticeDialog(
      context,
      title: '사진 권한 안내',
      message: '프로필 사진을 변경하려면 사진 보관함 접근 권한이 필요합니다. 권한을 거부하면 현재 프로필 사진은 유지됩니다.',
      confirmLabel: '사진 선택하기',
      cancelLabel: '나중에',
    );
    if (!mounted || !shouldContinue) {
      return;
    }

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 88,
        maxWidth: 2400,
      );
      if (!mounted || pickedFile == null) {
        return;
      }
      await widget.controller.updateProfileImage(pickedFile.path);
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }
      if (error.code == 'photo_access_denied') {
        final action = await showMateyaPermissionRecoveryDialog(
          context,
          title: '사진 권한이 필요해요',
          message:
              '프로필 사진을 변경하려면 사진 보관함 접근 권한이 필요합니다. 다시 시도하거나 앱 설정에서 권한을 허용할 수 있습니다.',
          retryLabel: '다시 시도',
        );
        if (!mounted) {
          return;
        }
        if (action == MateyaPermissionRecoveryAction.retry) {
          await _pickProfileImage();
          return;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필 사진을 불러오지 못했어요. 권한과 파일 상태를 확인해 주세요.')),
      );
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

    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => OnboardingFlowPage(
          controller: OnboardingController(
            locationRepository: DeviceNeighborhoodLocationRepository(),
            authRepository: ApiOnboardingAuthRepository(
              apiClient: MateyaApiClient(
                baseUrl: AppConfig.apiBaseUrl,
                sessionStore: AuthSessionStore.instance,
              ),
            ),
            authSessionStore: AuthSessionStore.instance,
          ),
        ),
      ),
      (_) => false,
    );
  }
}
