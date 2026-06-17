import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../application/onboarding_controller.dart';
import '../../domain/onboarding_flow.dart';
import '../widgets/onboarding_business_steps.dart';
import '../widgets/onboarding_contact_steps.dart';
import '../widgets/onboarding_intro_steps.dart';
import '../widgets/onboarding_shared_widgets.dart';

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
        previewChild: const SinglePreviewField(
          hintText: '',
          hasFocusStyle: true,
        ),
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
            SinglePreviewField(hintText: 'NICE 평가 정보'),
            SizedBox(height: 58),
            BusinessNumberPreview(),
            SizedBox(height: 58),
            SinglePreviewField(hintText: '홍길동'),
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
