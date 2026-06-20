import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/shared/localization/app_locale_controller.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';
import 'package:mateya_app/shared/widgets/mateya_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('header renders without a Scaffold material ancestor', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Column(children: <Widget>[MateyaHeader.noBackArrow()]),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(MateyaHeader), findsOneWidget);
    expect(find.byIcon(Icons.language_rounded), findsOneWidget);
  });

  testWidgets('header language action updates app locale immediately', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'mateya.language.selected_code': 'ko',
    });
    final controller = AppLocaleController.instance;
    await controller.setLanguageCode('ko');

    await tester.pumpWidget(
      AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return MaterialApp(
            locale: controller.locale,
            supportedLocales: MateyaLocalizations.supportedLocales,
            localizationsDelegates: MateyaLocalizations.delegates,
            home: Scaffold(
              body: Column(
                children: <Widget>[
                  const MateyaHeader.noBackArrow(),
                  Builder(
                    builder: (context) {
                      return Text(context.l10n.bottomNavigationHome);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    expect(find.text('홈'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.language_rounded));
    await tester.pumpAndSettle();

    expect(find.text('언어 변경'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('language-dropdown-toggle')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('language-option-en')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('mateya.language.selected_code'), 'en');
  });

  testWidgets('chat detail header does not overflow with localized subtitle', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('zh'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: const Scaffold(
          body: Column(
            children: <Widget>[
              MateyaHeader.chatDetail(title: '최성현', subtitle: '2人参与'),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(MateyaHeader), findsOneWidget);
  });
}
