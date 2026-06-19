import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/home/presentation/widgets/home_plus_action_overlay.dart';

void main() {
  testWidgets('plus overlay renders actions and handles taps', (tester) async {
    var tappedLabel = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomePlusActionOverlay(
            createLabel: '모임 생성',
            onDismiss: () => tappedLabel = 'dismiss',
            onCreateTap: () => tappedLabel = 'create',
            onNearbyCultureTap: () => tappedLabel = 'nearby',
          ),
        ),
      ),
    );

    expect(find.text('모임 생성'), findsOneWidget);
    expect(find.text('내 주변 전통문화'), findsOneWidget);

    await tester.tap(find.text('내 주변 전통문화'));
    await tester.pump();

    expect(tappedLabel, 'nearby');
  });
}
