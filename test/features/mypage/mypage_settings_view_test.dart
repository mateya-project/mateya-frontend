import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/mypage/domain/mypage_models.dart';
import 'package:mateya_app/features/mypage/presentation/widgets/mypage_route_views.dart';

void main() {
  testWidgets(
    'settings view exposes privacy policy action and remains scrollable on short screens',
    (tester) async {
      var openedPrivacyPolicy = false;
      var openedPrimaryPreferences = false;
      var backed = false;
      tester.view.physicalSize = const Size(375, 640);
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
              onBack: () {
                backed = true;
              },
              onReport: () {},
              onEditPrimaryPreferences: () {
                openedPrimaryPreferences = true;
              },
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
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      expect(find.text('개인정보처리방침 보기'), findsOneWidget);
      expect(find.text('내 언어 · 국가 변경하기'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pump();
      expect(backed, isTrue);

      await tester.tap(find.text('내 언어 · 국가 변경하기'));
      await tester.pump();
      expect(openedPrimaryPreferences, isTrue);

      await tester.tap(find.text('개인정보처리방침 보기'));
      await tester.pump();

      expect(openedPrivacyPolicy, isTrue);

      await tester.scrollUntilVisible(
        find.text('회원 탈퇴하기'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('회원 탈퇴하기'), findsOneWidget);
    },
  );
}
