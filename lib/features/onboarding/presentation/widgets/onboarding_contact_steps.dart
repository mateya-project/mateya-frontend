import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/permissions/mateya_permission_dialogs.dart';
import '../../../../shared/theme/app_responsive.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../../shared/widgets/mateya_interaction.dart';
import '../../../../shared/widgets/mateya_text_field.dart';
import '../../application/onboarding_controller.dart';
import '../../domain/onboarding_flow.dart';
import 'onboarding_shared_widgets.dart';

class PhoneStepView extends StatefulWidget {
  const PhoneStepView({super.key, required this.controller});

  final OnboardingController controller;

  @override
  State<PhoneStepView> createState() => _PhoneStepViewState();
}

class _PhoneStepViewState extends State<PhoneStepView> {
  late final TextEditingController _phoneController;
  late final TextEditingController _verificationController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: widget.controller.phoneNumber,
    );
    _verificationController = TextEditingController(
      text: widget.controller.verificationCode,
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _verificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final hasSentVerificationCode = controller.hasSentVerificationCode;
    final horizontalPadding = AppResponsive.horizontalPadding(context);
    final bottomPadding = AppResponsive.keyboardAwareBottomPadding(context);

    _phoneController.value = _phoneController.value.copyWith(
      text: controller.phoneNumber,
      selection: TextSelection.collapsed(offset: controller.phoneNumber.length),
    );
    _verificationController.value = _verificationController.value.copyWith(
      text: controller.verificationCode,
      selection: TextSelection.collapsed(
        offset: controller.verificationCode.length,
      ),
    );

    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: controller.goBack),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 32),
                Text(
                  hasSentVerificationCode
                      ? l10n.onboardingEnterVerificationCode
                      : l10n.onboardingEnterPhoneNumber,
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.onboardingPhoneNumberLabel,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                MateyaTextField(
                  controller: _phoneController,
                  readOnly: hasSentVerificationCode,
                  hintText: l10n.onboardingPhoneNumberHint,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(15),
                  ],
                  errorText: controller.errorFor('phone'),
                  onChanged: controller.updatePhoneNumber,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.onboardingPhoneNumberHelper,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 46),
                Text(
                  l10n.onboardingVerificationCodeLabel,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 21),
                MateyaTextField(
                  controller: _verificationController,
                  readOnly: !hasSentVerificationCode,
                  hintText: hasSentVerificationCode
                      ? null
                      : l10n.onboardingVerificationCodeHint,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  errorText: controller.errorFor('verification'),
                  onChanged: controller.updateVerificationCode,
                ),
                if (hasSentVerificationCode) ...<Widget>[
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDuration(controller.remainingSeconds),
                        style: theme.textTheme.bodySmall,
                      ),
                      const Spacer(),
                      MateyaPressable(
                        onTap: controller.isAuthLoading
                            ? null
                            : () => controller.resendVerificationCode(),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        child: Text(
                          l10n.onboardingResendVerificationCode,
                          style: theme.textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (controller.verificationNotice != null) ...<Widget>[
                    const SizedBox(height: 8),
                    Text(
                      controller.verificationNotice!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (kDebugMode &&
                      controller.debugVerificationCode != null) ...<Widget>[
                    const SizedBox(height: 12),
                    Text(
                      l10n.onboardingDebugVerificationCode(
                        controller.debugVerificationCode!,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.brandGreen,
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 16),
                MateyaButton(
                  label: controller.isAuthLoading
                      ? l10n.commonProcessing
                      : controller.hasSentVerificationCode
                      ? l10n.onboardingVerify
                      : l10n.onboardingRequestVerificationCode,
                  tone: MateyaButtonTone.dark,
                  enabled:
                      !controller.isAuthLoading &&
                      (hasSentVerificationCode
                          ? controller.canSubmitVerificationCode
                          : controller.canSendVerificationCode),
                  onPressed: hasSentVerificationCode
                      ? () => controller.submitVerificationCode()
                      : () => controller.sendVerificationCode(),
                ),
                SizedBox(height: bottomPadding),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainder = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainder';
  }
}

class NeighborhoodAutoStepView extends StatefulWidget {
  const NeighborhoodAutoStepView({super.key, required this.controller});

  final OnboardingController controller;

  @override
  State<NeighborhoodAutoStepView> createState() =>
      _NeighborhoodAutoStepViewState();
}

class _NeighborhoodAutoStepViewState extends State<NeighborhoodAutoStepView> {
  bool _hasShownLocationPermissionNotice = false;
  LocationFailureType? _lastHandledFailureType;

  Future<void> _startLocationVerificationFlow() async {
    if (!mounted) {
      return;
    }

    if (!await _confirmLocationPermissionRequest()) {
      return;
    }

    _lastHandledFailureType = null;
    await widget.controller.startAutomaticNeighborhoodVerification();
    if (!mounted) {
      return;
    }

    await _handleLocationFailure();
  }

  Future<void> _handleLocationFailure() async {
    final l10n = context.l10n;
    final failure = widget.controller.locationFailure;
    if (failure == null || _lastHandledFailureType == failure.type) {
      return;
    }

    _lastHandledFailureType = failure.type;

    switch (failure.type) {
      case LocationFailureType.serviceDisabled:
        await showMateyaLocationSettingsDialog(
          context,
          title: l10n.locationServiceDisabledTitle,
          message: l10n.onboardingLocationServiceDisabledMessage,
        );
        break;
      case LocationFailureType.permissionPermanentlyDenied:
        await showMateyaAppSettingsDialog(
          context,
          title: l10n.locationPermissionDisabledTitle,
          message: l10n.onboardingLocationPermissionDisabledMessage,
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

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final horizontalPadding = AppResponsive.horizontalPadding(context);
    final currentLocationCtaLabel = switch (controller.locationFailure?.type) {
      LocationFailureType.permissionDenied =>
        l10n.onboardingRetryLocationPermission,
      LocationFailureType.permissionPermanentlyDenied =>
        l10n.onboardingRetryAfterSettingsChange,
      LocationFailureType.serviceDisabled =>
        l10n.onboardingRetryLocationService,
      LocationFailureType.accuracyTooLow ||
      LocationFailureType.geocodingFailed ||
      LocationFailureType.locationUnavailable ||
      LocationFailureType.unknown => l10n.onboardingRetryCurrentLocation,
      null => l10n.onboardingUseCurrentLocation,
    };

    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: controller.goBack),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 46),
                Text(
                  controller.neighborhoodHeadline,
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                NeighborhoodMapCard(
                  selection: controller.selectedNeighborhood,
                  isLoading: controller.locationPhase == AsyncPhase.loading,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.completionMode == AuthCompletionMode.login &&
                          controller.previousNeighborhoodLabel != null
                      ? l10n.onboardingPreviousNeighborhood(
                          controller.previousNeighborhoodLabel!,
                        )
                      : controller.selectedNeighborhood != null
                      ? controller.resolvedNeighborhoodMessage
                      : controller.locationFailure?.message ??
                            l10n.onboardingLocationPermissionNoticeMessage,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                MateyaButton(
                  label:
                      controller.isAuthLoading ||
                          controller.locationPhase == AsyncPhase.loading
                      ? l10n.commonProcessing
                      : controller.selectedNeighborhood != null
                      ? l10n.onboardingCompleteNeighborhood
                      : currentLocationCtaLabel,
                  enabled:
                      !controller.isAuthLoading &&
                      controller.locationPhase != AsyncPhase.loading,
                  onPressed: controller.selectedNeighborhood != null
                      ? controller.completeNeighborhood
                      : _startLocationVerificationFlow,
                ),
                const SizedBox(height: 17),
                Center(
                  child: MateyaPressable(
                    onTap: controller.openManualNeighborhood,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: Text.rich(
                      TextSpan(
                        style: theme.textTheme.bodyMedium,
                        children: <InlineSpan>[
                          TextSpan(
                            text: l10n.onboardingNeedHelp,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: l10n.onboardingManualInputCta,
                            style: const TextStyle(color: AppColors.brandGreen),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _confirmLocationPermissionRequest() async {
    if (_hasShownLocationPermissionNotice) {
      return true;
    }

    final shouldContinue = await showMateyaPermissionNoticeDialog(
      context,
      title: context.l10n.onboardingLocationPermissionNoticeTitle,
      message: context.l10n.onboardingLocationPermissionNoticeMessage,
      confirmLabel: context.l10n.onboardingUseCurrentLocation,
    );
    if (shouldContinue) {
      _hasShownLocationPermissionNotice = true;
    }
    return shouldContinue;
  }
}

class NeighborhoodManualStepView extends StatefulWidget {
  const NeighborhoodManualStepView({super.key, required this.controller});

  final OnboardingController controller;

  @override
  State<NeighborhoodManualStepView> createState() =>
      _NeighborhoodManualStepViewState();
}

class _NeighborhoodManualStepViewState
    extends State<NeighborhoodManualStepView> {
  late final TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController(
      text: widget.controller.manualNeighborhoodQuery,
    );
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final horizontalPadding = AppResponsive.horizontalPadding(context);
    final bottomPadding = AppResponsive.keyboardAwareBottomPadding(context);

    _queryController.value = _queryController.value.copyWith(
      text: controller.manualNeighborhoodQuery,
      selection: TextSelection.collapsed(
        offset: controller.manualNeighborhoodQuery.length,
      ),
    );

    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: controller.goBack),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 46),
                Text(
                  controller.neighborhoodHeadline,
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                NeighborhoodMapCard(
                  selection: controller.selectedNeighborhood,
                  isLoading: controller.locationPhase == AsyncPhase.loading,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.selectedNeighborhood != null
                      ? controller.resolvedNeighborhoodMessage
                      : l10n.onboardingManualNeighborhoodHelper,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                MateyaTextField(
                  controller: _queryController,
                  hintText: l10n.onboardingNeighborhoodHint,
                  errorText: controller.errorFor('manualNeighborhood'),
                  onChanged: controller.updateManualNeighborhoodQuery,
                  onSubmitted: (_) => controller.resolveManualNeighborhood(),
                ),
                SizedBox(height: bottomPadding),
                MateyaButton(
                  label: controller.isAuthLoading
                      ? l10n.commonProcessing
                      : l10n.onboardingCompleteNeighborhood,
                  enabled:
                      controller.canCompleteNeighborhood &&
                      !controller.isAuthLoading,
                  onPressed: controller.completeNeighborhood,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
