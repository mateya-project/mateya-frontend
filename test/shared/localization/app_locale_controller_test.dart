import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/shared/localization/app_locale_controller.dart';
import 'package:mateya_app/shared/preferences/mateya_language_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'language preferences default to Korean and normalize zh to zh-Hans',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final preferences = MateyaLanguagePreferences.instance;

      expect(await preferences.currentCode(), 'ko');
      expect(await preferences.currentLocale(), const Locale('ko'));

      await preferences.setCurrentCode('zh');

      expect(preferences.currentCodeOrDefault, 'zh-Hans');
      expect(
        preferences.currentLocaleOrDefault,
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      );
    },
  );

  test(
    'locale controller restores saved locale and persists immediate updates',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'mateya.language.selected_code': 'zh-Hans',
      });
      final controller = AppLocaleController.instance;

      await controller.initialize();

      expect(
        controller.locale,
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      );
      expect(controller.languageCode, 'zh-Hans');

      await controller.setLanguageCode('en');

      expect(controller.locale, const Locale('en'));
      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getString('mateya.language.selected_code'), 'en');
    },
  );
}
