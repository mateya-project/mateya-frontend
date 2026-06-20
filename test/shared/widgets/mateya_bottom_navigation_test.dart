import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/shared/widgets/mateya_bottom_navigation.dart';

void main() {
  testWidgets(
    'bottom navigation renders without a Scaffold material ancestor',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: <Widget>[
              Expanded(child: Container()),
              MateyaBottomNavigation(
                currentTab: MateyaBottomTab.home,
                onHomeTap: () {},
                onExploreTap: () {},
                onPlusTap: () {},
                onChatTap: () {},
                onProfileTap: () {},
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('홈'), findsOneWidget);
      expect(find.text('프로필'), findsOneWidget);
    },
  );
}
