import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_responsive.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../../shared/widgets/mateya_interaction.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../../shared/widgets/mateya_text_field.dart';
import '../../application/onboarding_controller.dart';
import '../../domain/onboarding_flow.dart';
import '../../domain/onboarding_terms.dart';
import '../screens/onboarding_terms_detail_page.dart';
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
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final horizontalPadding = AppResponsive.horizontalPadding(context);

    return Column(
      children: <Widget>[
        const MateyaHeader.noBackArrow(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const SizedBox(height: 24),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 32, bottom: 24),
                          child: Column(
                            children: <Widget>[
                              MateyaButton(
                                label: l10n.onboardingStart,
                                onPressed: onGuestTap,
                              ),
                              const SizedBox(height: 15),
                              MateyaPressable(
                                onTap: onHostTap,
                                borderRadius: BorderRadius.circular(10),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Text.rich(
                                  TextSpan(
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 12,
                                    ),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: l10n.onboardingBusinessPrompt,
                                      ),
                                      const TextSpan(text: ' '),
                                      TextSpan(
                                        text: l10n.onboardingStartAsHost,
                                        style: const TextStyle(
                                          color: AppColors.brandGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final requiredDocuments = kRequiredOnboardingTermsDocuments;
    final sheetConstraints = AppResponsive.dialogConstraints(
      context,
      maxWidth: 560,
      maxHeightFactor: 0.84,
    );

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            MateyaHeader.backArrow(onBack: onBack),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.horizontalPadding(context),
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
          child: ConstrainedBox(
            constraints: sheetConstraints,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.onboardingConsentTitle,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 34),
                      AgreementRow(
                        label: l10n.onboardingAgreeAll,
                        selected: agreementState.isAllChecked,
                        emphasized: true,
                        helperText: l10n.onboardingAgreeAllHelper,
                        onChanged: onToggleAll,
                      ),
                      const SizedBox(height: 28),
                      for (
                        int index = 0;
                        index < requiredDocuments.length;
                        index++
                      ) ...<Widget>[
                        Builder(
                          builder: (context) {
                            final document = requiredDocuments[index];
                            return Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: AgreementRow(
                                label: l10n.onboardingRequiredAgreementLabel(
                                  document.title,
                                ),
                                selected: _isAgreementSelected(
                                  agreementState,
                                  document.type,
                                ),
                                onChanged: (value) => _toggleAgreementByType(
                                  document.type,
                                  value,
                                  onToggleService: onToggleService,
                                  onTogglePrivacy: onTogglePrivacy,
                                  onToggleLocation: onToggleLocation,
                                  onToggleAge: onToggleAge,
                                ),
                                onDetailTap: () =>
                                    _openTermsDetail(context, document),
                                checkboxKey: ValueKey<String>(
                                  'agreement-checkbox-${document.type.apiType}',
                                ),
                                detailKey: ValueKey<String>(
                                  'agreement-detail-${document.type.apiType}',
                                ),
                              ),
                            );
                          },
                        ),
                        if (index != requiredDocuments.length - 1)
                          const SizedBox(height: 32),
                      ],
                      const SizedBox(height: 40),
                      MateyaButton(
                        label: l10n.commonNext,
                        tone: MateyaButtonTone.dark,
                        enabled: canProceed,
                        onPressed: onNext,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

bool _isAgreementSelected(
  AgreementState agreementState,
  OnboardingTermsType type,
) {
  return switch (type) {
    OnboardingTermsType.serviceTerms => agreementState.service,
    OnboardingTermsType.privacyThirdParty => agreementState.privacy,
    OnboardingTermsType.locationBasedService => agreementState.location,
    OnboardingTermsType.ageOver14 => agreementState.age,
  };
}

void _toggleAgreementByType(
  OnboardingTermsType type,
  bool value, {
  required ValueChanged<bool> onToggleService,
  required ValueChanged<bool> onTogglePrivacy,
  required ValueChanged<bool> onToggleLocation,
  required ValueChanged<bool> onToggleAge,
}) {
  switch (type) {
    case OnboardingTermsType.serviceTerms:
      onToggleService(value);
      break;
    case OnboardingTermsType.privacyThirdParty:
      onTogglePrivacy(value);
      break;
    case OnboardingTermsType.locationBasedService:
      onToggleLocation(value);
      break;
    case OnboardingTermsType.ageOver14:
      onToggleAge(value);
      break;
  }
}

Future<void> _openTermsDetail(
  BuildContext context,
  OnboardingTermsDocument document,
) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: AppResponsive.dialogConstraints(
            context,
            maxWidth: 520,
            maxHeightFactor: 0.92,
          ),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 8, 0),
                  child: IconButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
              ),
              Expanded(child: OnboardingTermsDetailContent(document: document)),
            ],
          ),
        ),
      );
    },
  );
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
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final horizontalPadding = AppResponsive.horizontalPadding(context);
    final bottomPadding = AppResponsive.keyboardAwareBottomPadding(context);

    _textController.value = _textController.value.copyWith(
      text: widget.controller.name,
      selection: TextSelection.collapsed(offset: widget.controller.name.length),
    );

    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: widget.controller.goBack),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 46),
                Text(
                  l10n.onboardingEnterName,
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 32),
                MateyaTextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  autofocus: true,
                  onChanged: widget.controller.updateName,
                  onSubmitted: (_) => widget.controller.submitName(),
                  errorText: widget.controller.errorFor('name'),
                ),
                SizedBox(height: bottomPadding),
                MateyaButton(
                  label: l10n.commonNext,
                  tone: MateyaButtonTone.dark,
                  enabled: widget.controller.canContinueName,
                  onPressed: widget.controller.submitName,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
