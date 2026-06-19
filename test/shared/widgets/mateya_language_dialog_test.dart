import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';
import 'package:mateya_app/shared/widgets/mateya_language_dialog.dart';

void main() {
  testWidgets('language dialog matches dropdown selection flow', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showMateyaLanguageDialog(context),
                  child: const Text('open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('언어 변경'), findsOneWidget);
    expect(find.text('지원 언어'), findsOneWidget);
    expect(find.text('한국어'), findsOneWidget);
    expect(find.text('확인'), findsOneWidget);
    expect(find.text('닫기'), findsNothing);

    final confirmTopBefore = tester.getTopLeft(find.text('확인')).dy;

    await tester.tap(
      find.byKey(const ValueKey<String>('language-dropdown-toggle')),
    );
    await tester.pumpAndSettle();

    final toggleBottom = tester
        .getBottomLeft(
          find.byKey(const ValueKey<String>('language-dropdown-toggle')),
        )
        .dy;
    final toggleHeight = tester
        .getSize(find.byKey(const ValueKey<String>('language-dropdown-toggle')))
        .height;
    final panelTop = tester
        .getTopLeft(
          find.byKey(const ValueKey<String>('language-dropdown-panel')),
        )
        .dy;
    final optionHeight = tester
        .getSize(find.byKey(const ValueKey<String>('language-option-en')))
        .height;

    expect(find.text('영어'), findsOneWidget);
    expect(find.text('중국어(간체자)'), findsOneWidget);
    expect(find.text('일본어'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsOneWidget);
    expect((panelTop - toggleBottom).abs(), lessThanOrEqualTo(1));
    expect(optionHeight, toggleHeight);
    expect(tester.getTopLeft(find.text('확인')).dy, confirmTopBefore);

    await tester.tap(find.byKey(const ValueKey<String>('language-option-en')));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
    expect(find.text('영어'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('language-option-en')),
      findsNothing,
    );

    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(find.text('언어 변경'), findsNothing);
  });

  testWidgets('language dialog closes from close button tap', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showMateyaLanguageDialog(context),
                  child: const Text('open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('언어 변경'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('language-dialog-close')),
    );
    await tester.pumpAndSettle();

    expect(find.text('언어 변경'), findsNothing);
  });
}
