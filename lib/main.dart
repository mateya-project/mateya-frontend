import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'app/app.dart';
import 'app/app_config.dart';
import 'shared/auth/auth_session.dart';
import 'shared/logging/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = AppLogger.instance;
  await logger.initialize();

  FlutterError.onError = logger.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    return logger.recordZoneError(
      error,
      stackTrace,
      message: 'Unhandled platform dispatcher error',
    );
  };

  await runZonedGuarded(
    () async {
      await AuthSessionStore.instance.initialize();
      logger.info(
        'App bootstrap started',
        context: <String, Object?>{
          'hasSession': AuthSessionStore.instance.hasSession,
        },
      );

      await FlutterNaverMap().init(
        clientId: AppConfig.naverMapClientId,
        onAuthFailed: (error) {
          logger.warning(
            'Naver Map authentication failed',
            context: <String, Object?>{'error': '$error'},
          );
        },
      );

      runApp(const MateyaApp());
    },
    (error, stackTrace) {
      logger.recordZoneError(
        error,
        stackTrace,
        message: 'Unhandled zoned bootstrap error',
      );
    },
  );
}
