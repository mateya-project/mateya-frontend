import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/permissions/mateya_permission_dialogs.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../../shared/widgets/mateya_header.dart';
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
    final theme = Theme.of(context);
    final hasSentVerificationCode = controller.hasSentVerificationCode;

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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 46),
                Text(
                  hasSentVerificationCode ? '인증번호를 입력해주세요' : '휴대폰 번호를 입력해주세요',
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 46),
                Text('전화번호', style: theme.textTheme.titleLarge),
                const SizedBox(height: 24),
                MateyaTextField(
                  controller: _phoneController,
                  readOnly: hasSentVerificationCode,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(15),
                  ],
                  errorText: controller.errorFor('phone'),
                  onChanged: controller.updatePhoneNumber,
                ),
                if (hasSentVerificationCode) ...<Widget>[
                  const SizedBox(height: 46),
                  Text('인증번호', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 21),
                  MateyaTextField(
                    controller: _verificationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    errorText: controller.errorFor('verification'),
                    onChanged: controller.updateVerificationCode,
                  ),
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
                      GestureDetector(
                        onTap: controller.isAuthLoading
                            ? null
                            : () => controller.resendVerificationCode(),
                        child: Text(
                          '인증번호 다시받기',
                          style: theme.textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (controller.debugVerificationCode != null) ...<Widget>[
                    const SizedBox(height: 12),
                    Text(
                      '테스트용 인증번호: ${controller.debugVerificationCode}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.brandGreen,
                      ),
                    ),
                  ],
                ],
                SizedBox(height: hasSentVerificationCode ? 120 : 220),
                if (!hasSentVerificationCode)
                  Text(
                    '휴대폰 번호를 입력하면 인증번호를 받을 수 있어요.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 26),
          child: MateyaButton(
            label: controller.isAuthLoading
                ? '처리 중...'
                : controller.hasSentVerificationCode
                ? '인증하기'
                : '인증번호 받기',
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
  bool _didStartPermissionFlow = false;
  LocationFailureType? _lastHandledFailureType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLocationVerificationFlow(showNotice: true);
    });
  }

  Future<void> _startLocationVerificationFlow({
    required bool showNotice,
  }) async {
    if (!mounted) {
      return;
    }

    if (showNotice && !_didStartPermissionFlow) {
      _didStartPermissionFlow = true;
      final shouldContinue = await showMateyaPermissionNoticeDialog(
        context,
        title: '위치 권한 안내',
        message:
            '회원가입 중 동네 인증과 내 주변 활동 추천을 위해 현재 위치 권한이 필요합니다. 권한을 거부하셔도 동네를 직접 입력해 가입을 계속할 수 있습니다.',
        confirmLabel: '현재 위치로 인증하기',
        cancelLabel: '직접 입력하기',
      );

      if (!mounted) {
        return;
      }

      if (!shouldContinue) {
        widget.controller.openManualNeighborhood();
        return;
      }
    }

    _lastHandledFailureType = null;
    await widget.controller.startAutomaticNeighborhoodVerification();
    if (!mounted) {
      return;
    }

    await _handleLocationFailure();
  }

  Future<void> _handleLocationFailure() async {
    final failure = widget.controller.locationFailure;
    if (failure == null || _lastHandledFailureType == failure.type) {
      return;
    }

    _lastHandledFailureType = failure.type;

    switch (failure.type) {
      case LocationFailureType.serviceDisabled:
        await showMateyaLocationSettingsDialog(
          context,
          title: '위치 서비스가 꺼져 있어요',
          message:
              '현재 위치로 동네 인증을 진행하려면 기기 위치 서비스를 켜야 합니다. 켜지 않아도 동네를 직접 입력해 가입을 계속할 수 있습니다.',
        );
        break;
      case LocationFailureType.permissionPermanentlyDenied:
        await showMateyaAppSettingsDialog(
          context,
          title: '위치 권한이 꺼져 있어요',
          message:
              '현재 위치 자동 인증을 사용하려면 앱 설정에서 위치 권한을 허용해야 합니다. 권한을 허용하지 않아도 직접 입력으로 가입을 계속할 수 있습니다.',
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
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: controller.goBack),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 46),
                Text(
                  controller.neighborhoodHeadline,
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      NeighborhoodMapCard(
                        selection: controller.selectedNeighborhood,
                        isLoading:
                            controller.locationPhase == AsyncPhase.loading,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.completionMode == AuthCompletionMode.login &&
                                controller.previousNeighborhoodLabel != null
                            ? '이전에 "${controller.previousNeighborhoodLabel}"으로 등록했어요.'
                            : controller.selectedNeighborhood != null
                            ? controller.resolvedNeighborhoodMessage
                            : controller.locationFailure?.message ??
                                  '현재 위치를 확인하고 있어요.',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                MateyaButton(
                  label: controller.isAuthLoading ? '처리 중...' : '동네인증 완료하기',
                  enabled:
                      controller.canCompleteNeighborhood &&
                      !controller.isAuthLoading,
                  onPressed: controller.completeNeighborhood,
                ),
                if (controller.selectedNeighborhood == null &&
                    controller.locationPhase != AsyncPhase.loading) ...<Widget>[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () =>
                          _startLocationVerificationFlow(showNotice: false),
                      child: Text(switch (controller.locationFailure?.type) {
                        LocationFailureType.permissionDenied =>
                          '현재 위치 권한 다시 요청',
                        LocationFailureType.permissionPermanentlyDenied =>
                          '설정 변경 후 다시 확인',
                        LocationFailureType.serviceDisabled => '위치 서비스 다시 확인',
                        _ => '현재 위치 다시 확인',
                      }),
                    ),
                  ),
                ],
                const SizedBox(height: 17),
                Center(
                  child: GestureDetector(
                    onTap: controller.openManualNeighborhood,
                    child: Text.rich(
                      TextSpan(
                        style: theme.textTheme.bodyMedium,
                        children: const <InlineSpan>[
                          TextSpan(
                            text: '인증이 어려워요.  ',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          TextSpan(
                            text: '직접 입력하기 >',
                            style: TextStyle(color: AppColors.brandGreen),
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
    final theme = Theme.of(context);

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19),
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
                      : '00시 00동 또는 00동 형식으로 입력해 주세요.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                MateyaTextField(
                  controller: _queryController,
                  hintText: '우만동',
                  errorText: controller.errorFor('manualNeighborhood'),
                  onChanged: controller.updateManualNeighborhoodQuery,
                  onSubmitted: (_) => controller.resolveManualNeighborhood(),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: MateyaButton(
                    label: controller.isAuthLoading ? '처리 중...' : '동네인증 완료하기',
                    enabled:
                        controller.canCompleteNeighborhood &&
                        !controller.isAuthLoading,
                    onPressed: controller.completeNeighborhood,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
