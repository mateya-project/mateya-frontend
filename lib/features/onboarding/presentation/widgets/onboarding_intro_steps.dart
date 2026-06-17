import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../../shared/widgets/mateya_text_field.dart';
import '../../application/onboarding_controller.dart';
import '../../domain/onboarding_flow.dart';
import 'onboarding_shared_widgets.dart';

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
                  AgreementRow(
                    label: '모두 동의',
                    selected: agreementState.isAllChecked,
                    emphasized: true,
                    helperText: '아래 필수 및 선택항목에 모두 동의합니다.',
                    onTap: () => onToggleAll(!agreementState.isAllChecked),
                  ),
                  const SizedBox(height: 28),
                  AgreementRow(
                    label: '(필수) 서비스 이용 약관',
                    selected: agreementState.service,
                    onTap: () => onToggleService(!agreementState.service),
                  ),
                  const SizedBox(height: 32),
                  AgreementRow(
                    label: '(필수) 개인정보 제3자 제공 동의',
                    selected: agreementState.privacy,
                    onTap: () => onTogglePrivacy(!agreementState.privacy),
                  ),
                  const SizedBox(height: 32),
                  AgreementRow(
                    label: '(필수) 위치기반서비스 이용약관',
                    selected: agreementState.location,
                    onTap: () => onToggleLocation(!agreementState.location),
                  ),
                  const SizedBox(height: 32),
                  AgreementRow(
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
