import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

enum AppLogLevel {
  debug('DEBUG'),
  info('INFO'),
  warning('WARN'),
  error('ERROR'),
  fatal('FATAL');

  const AppLogLevel(this.label);

  final String label;
}

class AppLogger {
  AppLogger._();

  static final AppLogger instance = AppLogger._();

  bool _initialized = false;
  bool _firebaseAvailable = false;

  bool get isFirebaseAvailable => _firebaseAvailable;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _initialized = true;

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        kReleaseMode,
      );
      _firebaseAvailable = true;
      info(
        'Firebase Crashlytics initialized',
        context: <String, Object?>{'collectionEnabled': kReleaseMode},
      );
    } catch (error, stackTrace) {
      _firebaseAvailable = false;
      _logLocally(
        AppLogLevel.warning,
        'Firebase logging initialization failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void debug(String message, {Map<String, Object?> context = const {}}) {
    _log(AppLogLevel.debug, message, context: context);
  }

  void info(String message, {Map<String, Object?> context = const {}}) {
    _log(AppLogLevel.info, message, context: context);
  }

  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    _log(
      AppLogLevel.warning,
      message,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    _log(
      AppLogLevel.error,
      message,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    _log(
      AppLogLevel.fatal,
      message,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  Future<void> updateUserContext({
    required String? userId,
    Map<String, Object?> context = const {},
  }) async {
    if (!_firebaseAvailable) {
      return;
    }

    try {
      await FirebaseCrashlytics.instance.setUserIdentifier(userId ?? '');
      for (final entry in context.entries) {
        await FirebaseCrashlytics.instance.setCustomKey(
          entry.key,
          _stringify(entry.value),
        );
      }
    } catch (error, stackTrace) {
      _logLocally(
        AppLogLevel.warning,
        'Failed to update Crashlytics user context',
        error: error,
        stackTrace: stackTrace,
        context: <String, Object?>{'userId': userId},
      );
    }
  }

  void recordFlutterError(FlutterErrorDetails details, {bool fatal = false}) {
    FlutterError.presentError(details);
    final description = details.context?.toDescription();
    final context = <String, Object?>{};
    if (details.library != null) {
      context['library'] = details.library;
    }
    if (description != null) {
      context['context'] = description;
    }
    _log(
      fatal ? AppLogLevel.fatal : AppLogLevel.error,
      'Unhandled Flutter framework error',
      error: details.exception,
      stackTrace: details.stack,
      context: context,
    );
  }

  bool recordZoneError(
    Object error,
    StackTrace stackTrace, {
    String message = 'Unhandled application error',
    bool fatal = true,
  }) {
    _log(
      fatal ? AppLogLevel.fatal : AppLogLevel.error,
      message,
      error: error,
      stackTrace: stackTrace,
    );
    return true;
  }

  void _log(
    AppLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    _logLocally(
      level,
      message,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );

    if (!_firebaseAvailable) {
      return;
    }

    final payload = _formatMessage(level, message, context);
    if (level != AppLogLevel.debug) {
      unawaited(FirebaseCrashlytics.instance.log(payload));
    }

    if (error == null) {
      return;
    }

    unawaited(
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: payload,
        fatal: level == AppLogLevel.fatal,
      ),
    );
  }

  void _logLocally(
    AppLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    developer.log(
      _formatMessage(level, message, context),
      name: 'mateya.app',
      level: _developerLevel(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  String _formatMessage(
    AppLogLevel level,
    String message,
    Map<String, Object?> context,
  ) {
    if (context.isEmpty) {
      return '[${level.label}] $message';
    }

    final normalizedContext = <String, Object?>{
      for (final entry in context.entries)
        entry.key: _normalizeContextValue(entry.value),
    };
    return '[${level.label}] $message ${jsonEncode(normalizedContext)}';
  }

  int _developerLevel(AppLogLevel level) {
    return switch (level) {
      AppLogLevel.debug => 500,
      AppLogLevel.info => 800,
      AppLogLevel.warning => 900,
      AppLogLevel.error => 1000,
      AppLogLevel.fatal => 1200,
    };
  }

  Object? _normalizeContextValue(Object? value) {
    if (value == null || value is num || value is bool || value is String) {
      return value;
    }
    if (value is Enum) {
      return value.name;
    }
    if (value is DateTime) {
      return value.toIso8601String();
    }
    if (value is Duration) {
      return value.inMilliseconds;
    }
    if (value is Uri) {
      return value.toString();
    }
    if (value is Iterable<Object?>) {
      return value.map(_normalizeContextValue).toList(growable: false);
    }
    if (value is Map<Object?, Object?>) {
      return <String, Object?>{
        for (final entry in value.entries)
          '${entry.key}': _normalizeContextValue(entry.value),
      };
    }
    return value.toString();
  }

  String _stringify(Object? value) {
    final normalized = _normalizeContextValue(value);
    if (normalized == null) {
      return '';
    }
    if (normalized is String) {
      return normalized;
    }
    return jsonEncode(normalized);
  }
}
