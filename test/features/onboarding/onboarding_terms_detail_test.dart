import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';
import 'package:mateya_app/features/onboarding/presentation/widgets/onboarding_intro_steps.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'consent screen opens terms detail and keeps checkbox state after back',
    (tester) async {
      AgreementState agreementState = const AgreementState();

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: ConsentOverlayStepView(
                  title: '이름을 입력해 주세요',
                  previewChild: const SizedBox.shrink(),
                  onBack: () {},
                  agreementState: agreementState,
                  onToggleAll: (value) {
                    setState(() {
                      agreementState = agreementState.toggleAll(value);
                    });
                  },
                  onToggleService: (value) {
                    setState(() {
                      agreementState = agreementState.copyWith(service: value);
                    });
                  },
                  onTogglePrivacy: (value) {
                    setState(() {
                      agreementState = agreementState.copyWith(privacy: value);
                    });
                  },
                  onToggleLocation: (value) {
                    setState(() {
                      agreementState = agreementState.copyWith(location: value);
                    });
                  },
                  onToggleAge: (value) {
                    setState(() {
                      agreementState = agreementState.copyWith(age: value);
                    });
                  },
                  onNext: () {},
                  canProceed: agreementState.isAllChecked,
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('agreement-checkbox-SERVICE_TERMS')),
      );
      await tester.pumpAndSettle();

      expect(agreementState.service, isTrue);

      await tester.tap(
        find.byKey(const ValueKey<String>('agreement-detail-SERVICE_TERMS')),
      );
      await tester.pumpAndSettle();

      expect(find.text('서비스 이용 약관'), findsOneWidget);
      expect(find.text('회원가입 및 계정 관리'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      expect(agreementState.service, isTrue);
      expect(find.text('(필수) 서비스 이용 약관'), findsOneWidget);
      expect(find.text('회원가입 및 계정 관리'), findsNothing);
    },
  );
}
