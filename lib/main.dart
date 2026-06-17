import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'app/app.dart';
import 'app/app_config.dart';
import 'shared/auth/auth_session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthSessionStore.instance.initialize();

  await FlutterNaverMap().init(
    clientId: AppConfig.naverMapClientId,
    onAuthFailed: (error) {
      debugPrint('Naver Map auth failed: $error');
    },
  );

  runApp(const MateyaApp());
}
