import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/app/app.dart';
import 'package:mateya_app/shared/localization/app_locale_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MateyaApp recreates the root MaterialApp when locale changes', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'mateya.language.selected_code': 'ko',
    });
    final controller = AppLocaleController.instance;
    await controller.initialize();

    await tester.pumpWidget(const MateyaApp());
    await tester.pumpAndSettle();

    MaterialApp materialApp = tester.widget<MaterialApp>(
      find.byType(MaterialApp),
    );
    expect(materialApp.key, const ValueKey<String>('mateya-app-ko'));

    await controller.setLanguageCode('en');
    await tester.pumpAndSettle();

    materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.key, const ValueKey<String>('mateya-app-en'));
  });
}
