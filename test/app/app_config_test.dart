import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/app/app_config.dart';

void main() {
  test('privacy policy url defaults to Mateya notion page', () {
    expect(
      AppConfig.privacyPolicyUrl,
      'https://app.notion.com/p/Mateya-38458d06892d801185d8eca4faec6e8b?source=copy_link',
    );
  });
}
