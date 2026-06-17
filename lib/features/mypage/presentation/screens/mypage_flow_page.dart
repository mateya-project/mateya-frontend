import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';
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
  final TextEditingController _businessIntroductionController =
      TextEditingController();
  final TextEditingController _withdrawalSignatureController =
      TextEditingController();

  int _lastToastVersion = 0;
  bool _withdrawalAgreement = false;
  String? _selectedLanguageCode;
  String? _selectedCountryCode;

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
        onOpenRecentActivities: controller.openRecentActivities,
        onOpenPreferences: controller.openPrimaryPreferences,
        onOpenOtherProfile: controller.openOtherProfile,
        onOpenWithdrawal: _openWithdrawalDialog,
      ),
      MyPageRoute.otherProfile => OtherProfileView(
        key: const ValueKey<String>('other-profile'),
        data: controller.otherProfile!,
        isBusy: controller.isUpdatingFriendship,
        onBack: controller.openPersonalHome,
        onFriendTap: controller.toggleFriendship,
      ),
      MyPageRoute.recentActivities => RecentActivitiesView(
        key: const ValueKey<String>('recent-activities'),
        data: controller.recentActivity!,
        onBack: controller.openPersonalHome,
      ),
      MyPageRoute.primaryPreferences => PrimaryPreferencesView(
        key: const ValueKey<String>('primary-preferences'),
        currentLanguageCode: _selectedLanguageCode,
        currentCountryCode: _selectedCountryCode,
        languageOptions: controller.languageOptions,
        countryOptions: controller.countryOptions,
        isSaving: controller.isSavingPreferences,
        errorText: controller.phase == MyPageAsyncPhase.validationError
            ? controller.errorMessage
            : null,
        onBack: controller.openPersonalHome,
        onLanguageChanged: (value) => setState(() {
          _selectedLanguageCode = value;
        }),
        onCountryChanged: (value) => setState(() {
          _selectedCountryCode = value;
        }),
        onSave: () {
          controller.updatePrimaryPreferences(
            languageCode: _selectedLanguageCode ?? '',
            countryCode: _selectedCountryCode ?? '',
          );
        },
      ),
      MyPageRoute.businessHome => BusinessMyPageView(
        key: const ValueKey<String>('business-home'),
        data: controller.businessPage!,
        introductionController: _businessIntroductionController,
        isSaving: controller.isSavingBusinessIntroduction,
        errorText: controller.phase == MyPageAsyncPhase.validationError
            ? controller.errorMessage
            : null,
        onSave: () {
          controller.updateBusinessIntroduction(
            _businessIntroductionController.text,
          );
        },
      ),
      MyPageRoute.withdrawal => const SizedBox.shrink(),
    };
  }

  void _syncFormValues() {
    final personalProfile = widget.controller.personalPage?.profile;
    if (personalProfile != null) {
      _selectedLanguageCode ??= personalProfile.primaryLanguageCode;
      _selectedCountryCode ??= personalProfile.primaryCountryCode;
    }

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
}
