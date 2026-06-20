import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';
import 'package:mateya_app/features/onboarding/presentation/widgets/onboarding_intro_steps.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';

void main() {
  testWidgets('welcome step stays stable on iPhone SE height', (tester) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: Scaffold(
          body: WelcomeStepView(onGuestTap: () {}, onHostTap: () {}),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(WelcomeStepView), findsOneWidget);
  });

  testWidgets('consent overlay stays scrollable on iPhone SE height', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: Scaffold(
          body: ConsentOverlayStepView(
            title: 'Business name',
            previewChild: const SizedBox(height: 180),
            onBack: () {},
            agreementState: const AgreementState(),
            onToggleAll: (_) {},
            onToggleService: (_) {},
            onTogglePrivacy: (_) {},
            onToggleLocation: (_) {},
            onToggleAge: (_) {},
            onNext: () {},
            canProceed: false,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(ConsentOverlayStepView), findsOneWidget);
  });
}
