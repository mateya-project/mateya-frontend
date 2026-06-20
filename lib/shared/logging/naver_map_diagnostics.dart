import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../../app/app_config.dart';
import 'app_logger.dart';

final class NaverMapDiagnostics {
  NaverMapDiagnostics({
    required String scope,
    AppLogger? logger,
    Map<String, Object?> context = const <String, Object?>{},
    this._loadTimeout = const Duration(seconds: 10),
  }) : _logger = logger ?? AppLogger.instance,
       _baseContext = <String, Object?>{
         'scope': scope,
         'platform': defaultTargetPlatform.name,
         ...context,
       };

  final AppLogger _logger;
  final Duration _loadTimeout;
  final Map<String, Object?> _baseContext;

  Timer? _loadTimeoutTimer;
  Stopwatch? _loadStopwatch;
  bool _mapLoaded = false;

  static Map<String, Object?> sdkInitializationContext() {
    final clientId = AppConfig.naverMapClientId.trim();
    return <String, Object?>{
      'platform': defaultTargetPlatform.name,
      'clientIdLength': clientId.length,
      'clientIdPreview': maskClientId(clientId),
    };
  }

  static String maskClientId(String clientId) {
    if (clientId.isEmpty) {
      return '(empty)';
    }
    if (clientId.length <= 4) {
      return '${clientId[0]}***';
    }
    return '${clientId.substring(0, 2)}***${clientId.substring(clientId.length - 2)}';
  }

  void mounted({Map<String, Object?> context = const <String, Object?>{}}) {
    _logger.info('Naver map widget mounted', context: _context(context));
  }

  void inputUpdated({
    Map<String, Object?> context = const <String, Object?>{},
  }) {
    _logger.debug('Naver map input updated', context: _context(context));
  }

  void mapReady({Map<String, Object?> context = const <String, Object?>{}}) {
    _mapLoaded = false;
    _loadStopwatch = Stopwatch()..start();
    _loadTimeoutTimer?.cancel();
    _loadTimeoutTimer = Timer(_loadTimeout, () {
      if (_mapLoaded) {
        return;
      }
      _logger.warning(
        'Naver map did not finish loading within timeout',
        context: _context(<String, Object?>{
          'timeoutMs': _loadTimeout.inMilliseconds,
        }),
      );
    });
    _logger.info('Naver map ready', context: _context(context));
  }

  void mapLoaded({Map<String, Object?> context = const <String, Object?>{}}) {
    _mapLoaded = true;
    final elapsed = _loadStopwatch?.elapsed;
    _loadTimeoutTimer?.cancel();
    _logger.info(
      'Naver map loaded',
      context: _context(<String, Object?>{
        if (elapsed != null) 'elapsedMs': elapsed.inMilliseconds,
        ...context,
      }),
    );
  }

  void syncSucceeded(
    String stage, {
    Map<String, Object?> context = const <String, Object?>{},
  }) {
    _logger.debug(
      'Naver map sync completed',
      context: _context(<String, Object?>{'stage': stage, ...context}),
    );
  }

  void syncSkipped(
    String stage, {
    Map<String, Object?> context = const <String, Object?>{},
  }) {
    _logger.debug(
      'Naver map sync skipped',
      context: _context(<String, Object?>{'stage': stage, ...context}),
    );
  }

  void syncFailed(
    String stage, {
    required Object error,
    required StackTrace stackTrace,
    Map<String, Object?> context = const <String, Object?>{},
  }) {
    _logger.error(
      'Naver map sync failed',
      error: error,
      stackTrace: stackTrace,
      context: _context(<String, Object?>{'stage': stage, ...context}),
    );
  }

  void authFailed(NAuthFailedException error) {
    _logger.warning(
      'Naver map authentication failed',
      error: error,
      context: _context(<String, Object?>{
        'authCode': error.code,
        'authMessage': error.message,
      }),
    );
  }

  void dispose() {
    _loadTimeoutTimer?.cancel();
  }

  Map<String, Object?> _context(Map<String, Object?> extra) {
    return <String, Object?>{..._baseContext, ...extra};
  }
}
