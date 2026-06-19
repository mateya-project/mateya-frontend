import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../../shared/widgets/mateya_text_field.dart';
import '../../../home/presentation/screens/home_flow_page.dart';
import '../../application/onboarding_controller.dart';
import '../../domain/onboarding_flow.dart';

class HostBusinessStepView extends StatefulWidget {
  const HostBusinessStepView({super.key, required this.controller});

  final OnboardingController controller;

  @override
  State<HostBusinessStepView> createState() => _HostBusinessStepViewState();
}

class _HostBusinessStepViewState extends State<HostBusinessStepView> {
  late final TextEditingController _businessNameController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _openingDateController;
  late final TextEditingController _firstController;
  late final TextEditingController _secondController;
  late final TextEditingController _thirdController;
  late final FocusNode _ownerFocusNode;
  late final FocusNode _openingDateFocusNode;
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
    _openingDateController = TextEditingController(
      text: widget.controller.businessOpeningDate,
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
    _openingDateFocusNode = FocusNode();
    _firstFocusNode = FocusNode();
    _secondFocusNode = FocusNode();
    _thirdFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _openingDateController.dispose();
    _firstController.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    _ownerFocusNode.dispose();
    _openingDateFocusNode.dispose();
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
    _openingDateController.text = controller.businessOpeningDate;
    _openingDateController.selection = TextSelection.collapsed(
      offset: controller.businessOpeningDate.length,
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
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 58),
                Text('개업일자', style: theme.textTheme.titleLarge),
                const SizedBox(height: 21),
                MateyaTextField(
                  controller: _openingDateController,
                  focusNode: _openingDateFocusNode,
                  hintText: '20240131',
                  errorText: controller.errorFor('businessOpeningDate'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                  onChanged: controller.updateBusinessOpeningDate,
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
    final isReturning = controller.completionMode == AuthCompletionMode.login;

    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: controller.goBack),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                const Spacer(flex: 3),
                if (isReturning) ...<Widget>[
                  Text(
                    '돌아오신걸 환영해요',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
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
                  isReturning
                      ? '${controller.completedName}님\n메이트야 복귀를 완료했어요'
                      : controller.completionHeadline,
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
    return HomeFlowPage(flowKind: controller.flowKind);
  }
}
