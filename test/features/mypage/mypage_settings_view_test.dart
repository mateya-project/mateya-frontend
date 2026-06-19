import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/mypage/domain/mypage_models.dart';
import 'package:mateya_app/features/mypage/presentation/widgets/mypage_route_views.dart';

void main() {
  testWidgets('settings view exposes privacy policy action', (tester) async {
    var openedPrivacyPolicy = false;
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettingsView(
            profile: const ProfileSummary(
              id: '1',
              name: '메이트야',
              residence: '서울 마포구',
              primaryLanguageCode: 'ko',
              primaryLanguageLabel: '한국어',
              primaryCountryCode: 'KR',
              primaryCountryLabel: '대한민국',
            ),
            onEditActivityRegion: () {},
            onOpenConsentHistory: () {},
            onOpenPrivacyPolicy: () {
              openedPrivacyPolicy = true;
            },
            onOpenCustomerSupport: () {},
            onOpenBlockedUsers: () {},
            onLogout: () {},
            onWithdrawal: () {},
          ),
        ),
      ),
    );

    expect(find.text('개인정보처리방침 보기'), findsOneWidget);

    await tester.tap(find.text('개인정보처리방침 보기'));
    await tester.pump();

    expect(openedPrivacyPolicy, isTrue);
  });
}
