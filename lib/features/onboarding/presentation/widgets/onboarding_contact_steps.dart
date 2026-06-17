import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                Text('휴대폰 정보를 입력해주세요', style: theme.textTheme.headlineLarge),
                const SizedBox(height: 46),
                Text('통신사', style: theme.textTheme.titleLarge),
                const SizedBox(height: 24),
                SelectableField(
                  value: controller.carrier,
                  placeholder: '통신사를 선택해 주세요',
                  errorText: controller.errorFor('carrier'),
                  onTap: () => _showOptionSheet(
                    context: context,
                    title: '통신사 선택',
                    options: controller.carriers,
                    onSelected: controller.selectCarrier,
                  ),
                ),
                const SizedBox(height: 46),
                Text('전화번호', style: theme.textTheme.titleLarge),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 78,
                      child: SelectableField(
                        value: controller.countryCode,
                        placeholder: '+82',
                        onTap: () => _showOptionSheet(
                          context: context,
                          title: '국가번호 선택',
                          options: controller.countryCodes,
                          onSelected: controller.selectCountryCode,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: MateyaTextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        errorText: controller.errorFor('phone'),
                        onChanged: controller.updatePhoneNumber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 46),
                Text('인증번호를 입력해주세요', style: theme.textTheme.titleLarge),
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
                const SizedBox(height: 120),
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
                (controller.hasSentVerificationCode
                    ? controller.canSubmitVerificationCode
                    : controller.canSendVerificationCode),
            onPressed: controller.hasSentVerificationCode
                ? () => controller.submitVerificationCode()
                : () => controller.sendVerificationCode(),
          ),
        ),
      ],
    );
  }

  Future<void> _showOptionSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              for (final option in options)
                ListTile(
                  title: Text(option),
                  onTap: () {
                    onSelected(option);
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainder = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes : $remainder';
  }
}

class NeighborhoodAutoStepView extends StatelessWidget {
  const NeighborhoodAutoStepView({super.key, required this.controller});

  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
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
                Text('동네 정보를 인증해주세요', style: theme.textTheme.headlineLarge),
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
                        controller.selectedNeighborhood != null
                            ? controller.resolvedNeighborhoodMessage
                            : controller.locationFailure?.message ??
                                  '현재 위치를 확인하고 있어요.',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                MateyaButton(
                  label: controller.isAuthLoading ? '가입 처리 중...' : '동네인증 완료하기',
                  enabled:
                      controller.canCompleteNeighborhood &&
                      !controller.isAuthLoading,
                  onPressed: controller.completeNeighborhood,
                ),
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
                Text('동네 정보를 인증해주세요', style: theme.textTheme.headlineLarge),
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
                    label: controller.isAuthLoading
                        ? '가입 처리 중...'
                        : '동네인증 완료하기',
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
