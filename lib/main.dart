import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'app/app.dart';
import 'app/app_config.dart';
import 'firebase_options.dart';
import 'shared/auth/auth_session.dart';
import 'shared/localization/app_locale_controller.dart';
import 'shared/logging/app_logger.dart';
import 'shared/logging/naver_map_diagnostics.dart';

Future<void> main() async {
  final logger = AppLogger.instance;

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await logger.initialize();

      FlutterError.onError = logger.recordFlutterError;
      PlatformDispatcher.instance.onError = (error, stackTrace) {
        return logger.recordZoneError(
          error,
          stackTrace,
          message: 'Unhandled platform dispatcher error',
        );
      };

      await AuthSessionStore.instance.initialize();
      await AppLocaleController.instance.initialize();
      logger.info(
        'App bootstrap started',
        context: <String, Object?>{
          'hasSession': AuthSessionStore.instance.hasSession,
        },
      );
      final naverMapSdkContext = <String, Object?>{
        ...NaverMapDiagnostics.sdkInitializationContext(),
        if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
          'bundleIdentifier':
              DefaultFirebaseOptions.currentPlatform.iosBundleId,
      };

      if (kIsWeb) {
        logger.info(
          'Skipping native Naver Map SDK initialization on web',
          context: naverMapSdkContext,
        );
      } else {
        logger.info('Initializing Naver Map SDK', context: naverMapSdkContext);
        await FlutterNaverMap().init(
          clientId: AppConfig.naverMapClientId,
          onAuthFailed: (error) {
            NaverMapDiagnostics(
              scope: 'app-bootstrap',
              logger: logger,
              context: naverMapSdkContext,
            ).authFailed(error);
          },
        );
        logger.info('Naver Map SDK initialized', context: naverMapSdkContext);
      }

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
