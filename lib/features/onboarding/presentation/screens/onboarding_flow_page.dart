import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../../shared/widgets/mateya_text_field.dart';
import '../../../home/presentation/screens/home_flow_page.dart';
import '../../application/onboarding_controller.dart';
import '../../domain/onboarding_flow.dart';

class OnboardingFlowPage extends StatefulWidget {
  const OnboardingFlowPage({super.key, required this.controller});

  final OnboardingController controller;

  @override
  State<OnboardingFlowPage> createState() => _OnboardingFlowPageState();
}

class _OnboardingFlowPageState extends State<OnboardingFlowPage> {
  int _lastToastVersion = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    widget.controller.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    final controller = widget.controller;
    if (!mounted) {
      return;
    }
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
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              transitionBuilder: (child, animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: const Offset(0.08, 0),
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
              child: _buildStep(context, widget.controller),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep(BuildContext context, OnboardingController controller) {
    return switch (controller.step) {
      OnboardingStep.welcome => WelcomeStepView(
        key: const ValueKey<String>('welcome'),
        onGuestTap: controller.startGuestFlow,
        onHostTap: controller.startHostFlow,
      ),
      OnboardingStep.guestConsent => ConsentOverlayStepView(
        key: const ValueKey<String>('guest-consent'),
        title: '이름을 입력해 주세요',
        onBack: controller.goBack,
        agreementState: controller.agreementState,
        onToggleAll: controller.toggleAllAgreements,
        onToggleService: (value) => controller.toggleAgreement(service: value),
        onTogglePrivacy: (value) => controller.toggleAgreement(privacy: value),
        onToggleLocation: (value) =>
            controller.toggleAgreement(location: value),
        onToggleAge: (value) => controller.toggleAgreement(age: value),
        onNext: controller.confirmConsent,
        canProceed: controller.isConsentComplete,
        previewChild: _SinglePreviewField(hintText: '', hasFocusStyle: true),
      ),
      OnboardingStep.guestName => NameStepView(
        key: const ValueKey<String>('guest-name'),
        controller: controller,
      ),
      OnboardingStep.guestPhone => PhoneStepView(
        key: const ValueKey<String>('guest-phone'),
        controller: controller,
      ),
      OnboardingStep.neighborhoodAuto => NeighborhoodAutoStepView(
        key: const ValueKey<String>('neighborhood-auto'),
        controller: controller,
      ),
      OnboardingStep.neighborhoodManual => NeighborhoodManualStepView(
        key: const ValueKey<String>('neighborhood-manual'),
        controller: controller,
      ),
      OnboardingStep.hostConsent => ConsentOverlayStepView(
        key: const ValueKey<String>('host-consent'),
        title: '상호명을 입력해 주세요',
        onBack: controller.goBack,
        agreementState: controller.agreementState,
        onToggleAll: controller.toggleAllAgreements,
        onToggleService: (value) => controller.toggleAgreement(service: value),
        onTogglePrivacy: (value) => controller.toggleAgreement(privacy: value),
        onToggleLocation: (value) =>
            controller.toggleAgreement(location: value),
        onToggleAge: (value) => controller.toggleAgreement(age: value),
        onNext: controller.confirmConsent,
        canProceed: controller.isConsentComplete,
        previewChild: Column(
          children: const <Widget>[
            _SinglePreviewField(hintText: 'NICE 평가 정보'),
            SizedBox(height: 58),
            _BusinessNumberPreview(),
            SizedBox(height: 58),
            _SinglePreviewField(hintText: '홍길동'),
          ],
        ),
      ),
      OnboardingStep.hostBusiness => HostBusinessStepView(
        key: const ValueKey<String>('host-business'),
        controller: controller,
      ),
      OnboardingStep.completed => CompletedStepView(
        key: const ValueKey<String>('completed'),
        controller: controller,
      ),
      OnboardingStep.homePlaceholder => HomePlaceholderStepView(
        key: const ValueKey<String>('home-placeholder'),
        controller: controller,
      ),
    };
  }
}

class WelcomeStepView extends StatelessWidget {
  const WelcomeStepView({
    super.key,
    required this.onGuestTap,
    required this.onHostTap,
  });

  final VoidCallback onGuestTap;
  final VoidCallback onHostTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        const MateyaHeader.noBackArrow(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
            ),
            child: Column(
              children: <Widget>[
                const Spacer(flex: 2),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 16 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: const MateyaBrandLockup(),
                ),
                const Spacer(flex: 3),
                MateyaButton(label: '시작하기', onPressed: onGuestTap),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: onHostTap,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Text.rich(
                      TextSpan(
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                        ),
                        children: const <InlineSpan>[
                          TextSpan(text: '사업자 이신가요? '),
                          TextSpan(
                            text: '호스트로 시작하기',
                            style: TextStyle(color: AppColors.brandGreen),
                          ),
                        ],
                      ),
                    ),
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

class ConsentOverlayStepView extends StatelessWidget {
  const ConsentOverlayStepView({
    super.key,
    required this.title,
    required this.previewChild,
    required this.onBack,
    required this.agreementState,
    required this.onToggleAll,
    required this.onToggleService,
    required this.onTogglePrivacy,
    required this.onToggleLocation,
    required this.onToggleAge,
    required this.onNext,
    required this.canProceed,
  });

  final String title;
  final Widget previewChild;
  final VoidCallback onBack;
  final AgreementState agreementState;
  final ValueChanged<bool> onToggleAll;
  final ValueChanged<bool> onToggleService;
  final ValueChanged<bool> onTogglePrivacy;
  final ValueChanged<bool> onToggleLocation;
  final ValueChanged<bool> onToggleAge;
  final VoidCallback onNext;
  final bool canProceed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            MateyaHeader.backArrow(onBack: onBack),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 46),
                    Text(title, style: theme.textTheme.headlineLarge),
                    const SizedBox(height: 32),
                    previewChild,
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned.fill(child: Container(color: AppColors.overlay)),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '메이트야 이용시 동의가 필요합니다.',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 34),
                  _AgreementRow(
                    label: '모두 동의',
                    selected: agreementState.isAllChecked,
                    emphasized: true,
                    helperText: '아래 필수 및 선택항목에 모두 동의합니다.',
                    onTap: () => onToggleAll(!agreementState.isAllChecked),
                  ),
                  const SizedBox(height: 28),
                  _AgreementRow(
                    label: '(필수) 서비스 이용 약관',
                    selected: agreementState.service,
                    onTap: () => onToggleService(!agreementState.service),
                  ),
                  const SizedBox(height: 32),
                  _AgreementRow(
                    label: '(필수) 개인정보 제3자 제공 동의',
                    selected: agreementState.privacy,
                    onTap: () => onTogglePrivacy(!agreementState.privacy),
                  ),
                  const SizedBox(height: 32),
                  _AgreementRow(
                    label: '(필수) 위치기반서비스 이용약관',
                    selected: agreementState.location,
                    onTap: () => onToggleLocation(!agreementState.location),
                  ),
                  const SizedBox(height: 32),
                  _AgreementRow(
                    label: '(필수) 만 14세 이상',
                    selected: agreementState.age,
                    onTap: () => onToggleAge(!agreementState.age),
                  ),
                  const SizedBox(height: 40),
                  MateyaButton(
                    label: '다음',
                    tone: MateyaButtonTone.dark,
                    enabled: canProceed,
                    onPressed: onNext,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NameStepView extends StatefulWidget {
  const NameStepView({super.key, required this.controller});

  final OnboardingController controller;

  @override
  State<NameStepView> createState() => _NameStepViewState();
}

class _NameStepViewState extends State<NameStepView> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.controller.name);
    _focusNode = FocusNode()
      ..addListener(() {
        if (!_focusNode.hasFocus) {
          widget.controller.validateNameField();
        }
      });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    _textController.value = _textController.value.copyWith(
      text: widget.controller.name,
      selection: TextSelection.collapsed(offset: widget.controller.name.length),
    );

    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: widget.controller.goBack),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 46),
                Text('이름을 입력해 주세요', style: theme.textTheme.headlineLarge),
                const SizedBox(height: 32),
                MateyaTextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  autofocus: true,
                  onChanged: widget.controller.updateName,
                  onSubmitted: (_) => widget.controller.submitName(),
                  errorText: widget.controller.errorFor('name'),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: MateyaButton(
                    label: '다음',
                    tone: MateyaButtonTone.dark,
                    enabled: widget.controller.canContinueName,
                    onPressed: widget.controller.submitName,
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
                _SelectableField(
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
                      child: _SelectableField(
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

class HostBusinessStepView extends StatefulWidget {
  const HostBusinessStepView({super.key, required this.controller});

  final OnboardingController controller;

  @override
  State<HostBusinessStepView> createState() => _HostBusinessStepViewState();
}

class _HostBusinessStepViewState extends State<HostBusinessStepView> {
  late final TextEditingController _businessNameController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _firstController;
  late final TextEditingController _secondController;
  late final TextEditingController _thirdController;
  late final FocusNode _ownerFocusNode;
  late final FocusNode _firstFocusNode;
  late final FocusNode _secondFocusNode;
  late final FocusNode _thirdFocusNode;

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController(
      text: widget.controller.businessName,
    );
    _ownerNameController = TextEditingController(
      text: widget.controller.businessOwner,
    );
    _firstController = TextEditingController(
      text: widget.controller.businessNumberFirst,
    );
    _secondController = TextEditingController(
      text: widget.controller.businessNumberSecond,
    );
    _thirdController = TextEditingController(
      text: widget.controller.businessNumberThird,
    );
    _ownerFocusNode = FocusNode();
    _firstFocusNode = FocusNode();
    _secondFocusNode = FocusNode();
    _thirdFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _firstController.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    _ownerFocusNode.dispose();
    _firstFocusNode.dispose();
    _secondFocusNode.dispose();
    _thirdFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final theme = Theme.of(context);

    _businessNameController.text = controller.businessName;
    _businessNameController.selection = TextSelection.collapsed(
      offset: controller.businessName.length,
    );
    _ownerNameController.text = controller.businessOwner;
    _ownerNameController.selection = TextSelection.collapsed(
      offset: controller.businessOwner.length,
    );
    _firstController.text = controller.businessNumberFirst;
    _firstController.selection = TextSelection.collapsed(
      offset: controller.businessNumberFirst.length,
    );
    _secondController.text = controller.businessNumberSecond;
    _secondController.selection = TextSelection.collapsed(
      offset: controller.businessNumberSecond.length,
    );
    _thirdController.text = controller.businessNumberThird;
    _thirdController.selection = TextSelection.collapsed(
      offset: controller.businessNumberThird.length,
    );

    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: controller.goBack),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 46),
                Text('상호명을 입력해 주세요', style: theme.textTheme.headlineLarge),
                const SizedBox(height: 32),
                MateyaTextField(
                  controller: _businessNameController,
                  hintText: 'NICE 평가 정보',
                  errorText: controller.errorFor('businessName'),
                  onChanged: controller.updateBusinessName,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 58),
                Text('사업자 번호', style: theme.textTheme.titleLarge),
                const SizedBox(height: 21),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: MateyaTextField(
                        controller: _firstController,
                        focusNode: _firstFocusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        onChanged: (value) {
                          controller.updateBusinessNumberPart(0, value);
                          if (value.length >= 3) {
                            _secondFocusNode.requestFocus();
                          }
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 14,
                      ),
                      child: Text('-'),
                    ),
                    Expanded(
                      flex: 2,
                      child: MateyaTextField(
                        controller: _secondController,
                        focusNode: _secondFocusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          controller.updateBusinessNumberPart(1, value);
                          if (value.length >= 2) {
                            _thirdFocusNode.requestFocus();
                          }
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 14,
                      ),
                      child: Text('-'),
                    ),
                    Expanded(
                      flex: 5,
                      child: MateyaTextField(
                        controller: _thirdController,
                        focusNode: _thirdFocusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                        ],
                        onChanged: (value) {
                          controller.updateBusinessNumberPart(2, value);
                        },
                      ),
                    ),
                  ],
                ),
                if (controller.errorFor('businessNumber') != null) ...<Widget>[
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          controller.errorFor('businessNumber')!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 58),
                Text('대표자명', style: theme.textTheme.titleLarge),
                const SizedBox(height: 21),
                MateyaTextField(
                  controller: _ownerNameController,
                  focusNode: _ownerFocusNode,
                  hintText: '홍길동',
                  errorText: controller.errorFor('businessOwner'),
                  onChanged: controller.updateBusinessOwner,
                ),
                const SizedBox(height: 140),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(19, 0, 19, 28),
          child: MateyaButton(
            label: '사업자인증 완료하기',
            enabled: controller.canCompleteBusiness,
            onPressed: controller.submitBusinessVerification,
          ),
        ),
      ],
    );
  }
}

class CompletedStepView extends StatelessWidget {
  const CompletedStepView({super.key, required this.controller});

  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: controller.goBack),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                const Spacer(flex: 3),
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: AppColors.brandGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  controller.completionHeadline,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.38,
                  ),
                ),
                const Spacer(flex: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: MateyaButton(
                    label: '메이트야 시작하기',
                    onPressed: controller.openHomePlaceholder,
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

class HomePlaceholderStepView extends StatelessWidget {
  const HomePlaceholderStepView({super.key, required this.controller});

  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return HomeFlowPage(
      flowKind: controller.flowKind,
      onBack: controller.goBack,
    );
  }
}

class NeighborhoodMapCard extends StatelessWidget {
  const NeighborhoodMapCard({
    super.key,
    required this.selection,
    required this.isLoading,
  });

  final NeighborhoodSelection? selection;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final target = selection != null
        ? NLatLng(selection!.latitude, selection!.longitude)
        : const NLatLng(37.5666, 126.9790);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: 280,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            NaverMap(
              key: ValueKey<String>(
                selection == null
                    ? 'default-map'
                    : '${selection!.latitude}-${selection!.longitude}',
              ),
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: target,
                  zoom: 15,
                ),
              ),
              onMapReady: (mapController) async {
                if (selection != null) {
                  await mapController.addOverlay(
                    NMarker(id: 'selected-neighborhood', position: target),
                  );
                }
              },
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

class _AgreementRow extends StatelessWidget {
  const _AgreementRow({
    required this.label,
    required this.selected,
    required this.onTap,
    this.emphasized = false,
    this.helperText,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool emphasized;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: selected ? AppColors.brandGreen : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: selected
                    ? AppColors.brandGreen
                    : const Color(0xFF58616A),
              ),
            ),
            child: selected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style:
                      (emphasized
                              ? theme.textTheme.titleLarge
                              : theme.textTheme.bodyMedium)
                          ?.copyWith(
                            fontSize: emphasized ? 20 : 14,
                            fontWeight: emphasized
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                ),
                if (helperText != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(helperText!, style: theme.textTheme.bodySmall),
                ],
              ],
            ),
          ),
          if (!emphasized)
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFF5A5F66),
              ),
            ),
        ],
      ),
    );
  }
}

class _SelectableField extends StatelessWidget {
  const _SelectableField({
    required this.value,
    required this.onTap,
    this.placeholder,
    this.errorText,
  });

  final String value;
  final String? placeholder;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = value.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
          child: Container(
            height: AppSpacing.inputHeight,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
              border: Border.all(
                color: errorText == null
                    ? AppColors.fieldBorder
                    : AppColors.error,
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    hasValue ? value : (placeholder ?? ''),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: hasValue
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
        if (errorText != null) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}

class _SinglePreviewField extends StatelessWidget {
  const _SinglePreviewField({
    required this.hintText,
    this.hasFocusStyle = false,
  });

  final String hintText;
  final bool hasFocusStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasFocusStyle ? AppColors.textPrimary : AppColors.fieldBorder,
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      alignment: Alignment.centerLeft,
      child: Text(
        hintText,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: hintText.isEmpty
              ? AppColors.textPrimary
              : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _BusinessNumberPreview extends StatelessWidget {
  const _BusinessNumberPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('사업자 번호', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 21),
        Row(
          children: const <Widget>[
            Expanded(child: _SinglePreviewField(hintText: '111')),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('-'),
            ),
            Expanded(child: _SinglePreviewField(hintText: '11')),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('-'),
            ),
            Expanded(flex: 2, child: _SinglePreviewField(hintText: '11111')),
          ],
        ),
      ],
    );
  }
}
