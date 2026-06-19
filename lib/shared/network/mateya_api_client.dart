import 'dart:async';
import 'dart:convert';

import '../auth/auth_session.dart';
import '../logging/app_logger.dart';
import 'http_transport.dart';

enum ApiFailureType { network, validation, unauthorized, server }

class MateyaApiException implements Exception {
  const MateyaApiException({
    required this.type,
    required this.message,
    this.code,
    this.title,
    this.statusCode,
    this.path,
    this.correlationId,
    this.fieldErrors = const <String, String>{},
  });

  final ApiFailureType type;
  final String message;
  final String? code;
  final String? title;
  final int? statusCode;
  final String? path;
  final String? correlationId;
  final Map<String, String> fieldErrors;
}

class MateyaApiClient {
  MateyaApiClient({
    required this.baseUrl,
    required this.sessionStore,
    HttpTransport? transport,
    AppLogger? logger,
  }) : _transport = transport ?? createHttpTransport(),
       _logger = logger ?? AppLogger.instance;

  final String baseUrl;
  final AuthSessionStore sessionStore;
  final HttpTransport _transport;
  final AppLogger _logger;

  Future<Object?> getJson(
    String path, {
    Map<String, String> queryParameters = const <String, String>{},
    Map<String, List<String>> queryParametersAll =
        const <String, List<String>>{},
    bool requiresAuth = false,
    bool logFailure = true,
  }) {
    return _sendJson(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
      queryParametersAll: queryParametersAll,
      requiresAuth: requiresAuth,
      logFailure: logFailure,
    );
  }

  Future<Object?> postJson(
    String path, {
    Object? body,
    bool requiresAuth = false,
  }) {
    return _sendJson(
      method: 'POST',
      path: path,
      requiresAuth: requiresAuth,
      body: body,
    );
  }

  Future<Object?> patchJson(
    String path, {
    Object? body,
    bool requiresAuth = false,
  }) {
    return _sendJson(
      method: 'PATCH',
      path: path,
      requiresAuth: requiresAuth,
      body: body,
    );
  }

  Future<Object?> deleteJson(String path, {bool requiresAuth = false}) {
    return _sendJson(method: 'DELETE', path: path, requiresAuth: requiresAuth);
  }

  Future<Object?> _sendJson({
    required String method,
    required String path,
    Map<String, String> queryParameters = const <String, String>{},
    Map<String, List<String>> queryParametersAll =
        const <String, List<String>>{},
    bool requiresAuth = false,
    Object? body,
    bool allowRefresh = true,
    bool logFailure = true,
  }) async {
    final stopwatch = Stopwatch()..start();
    final mergedQueryParameters = <String, List<String>>{
      for (final entry in queryParameters.entries)
        entry.key: <String>[entry.value],
    };
    for (final entry in queryParametersAll.entries) {
      if (entry.value.isEmpty) {
        continue;
      }
      mergedQueryParameters.update(
        entry.key,
        (existing) => <String>[...existing, ...entry.value],
        ifAbsent: () => List<String>.from(entry.value),
      );
    }
    final query = mergedQueryParameters.entries
        .expand(
          (entry) => entry.value.map(
            (value) =>
                '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(value)}',
          ),
        )
        .join('&');
    final uri = _buildUri(path, query.isEmpty ? null : query);
    final headers = <String, String>{
      'Accept': 'application/json',
      if (body != null) 'Content-Type': 'application/json',
    };

    _logger.debug(
      'API request started',
      context: <String, Object?>{
        'method': method,
        'path': path,
        'requiresAuth': requiresAuth,
        'queryKeys': mergedQueryParameters.keys.toList(growable: false),
        'hasBody': body != null,
      },
    );

    if (requiresAuth) {
      final accessToken = sessionStore.session?.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        throw MateyaApiException(
          type: ApiFailureType.unauthorized,
          message: '로그인이 필요합니다.',
          path: path,
        );
      }
      headers['Authorization'] = 'Bearer $accessToken';
    }

    try {
      try {
        final response = await _transport.send(
          method: method,
          uri: uri,
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        );
        final envelope = _decodeEnvelope(response);
        final correlationId =
            envelope.correlationId ?? response.headers['x-correlation-id'];

        if (response.statusCode >= 200 && response.statusCode < 300) {
          stopwatch.stop();
          final logContext = <String, Object?>{
            'method': method,
            'path': path,
            'statusCode': response.statusCode,
            'durationMs': stopwatch.elapsedMilliseconds,
          };
          if (correlationId != null) {
            logContext['correlationId'] = correlationId;
          }
          _logger.debug('API request completed', context: logContext);
          return envelope.data;
        }

        final exception = _toApiException(
          response.statusCode,
          envelope.payload,
          fallbackPath: path,
          fallbackCorrelationId: correlationId,
        );
        stopwatch.stop();
        if (logFailure) {
          _logApiFailure(
            'API request failed',
            exception: exception,
            method: method,
            durationMs: stopwatch.elapsedMilliseconds,
          );
        }
        throw exception;
      } on MateyaApiException catch (error) {
        if (requiresAuth &&
            allowRefresh &&
            error.type == ApiFailureType.unauthorized &&
            await _tryRefreshSession()) {
          return _sendJson(
            method: method,
            path: path,
            queryParameters: queryParameters,
            queryParametersAll: queryParametersAll,
            requiresAuth: requiresAuth,
            body: body,
            allowRefresh: false,
            logFailure: logFailure,
          );
        }
        rethrow;
      }
    } on MateyaApiException {
      rethrow;
    } on TimeoutException catch (error, stackTrace) {
      stopwatch.stop();
      _logger.warning(
        'API request timed out',
        error: error,
        stackTrace: stackTrace,
        context: <String, Object?>{
          'method': method,
          'path': path,
          'durationMs': stopwatch.elapsedMilliseconds,
        },
      );
      throw MateyaApiException(
        type: ApiFailureType.network,
        message: '네트워크 연결을 확인한 뒤 다시 시도해 주세요.',
        path: path,
      );
    } catch (error, stackTrace) {
      stopwatch.stop();
      _logger.error(
        'API request failed with unexpected transport error',
        error: error,
        stackTrace: stackTrace,
        context: <String, Object?>{
          'method': method,
          'path': path,
          'durationMs': stopwatch.elapsedMilliseconds,
        },
      );
      throw MateyaApiException(
        type: ApiFailureType.network,
        message: '네트워크 연결을 확인한 뒤 다시 시도해 주세요.',
        path: path,
      );
    }
  }

  Uri _buildUri(String path, String? query) {
    return Uri.parse(baseUrl).replace(path: path, query: query);
  }

  Future<bool> _tryRefreshSession() async {
    try {
      final refreshed = await sessionStore.refreshSession((refreshToken) async {
        final response = await _transport.send(
          method: 'POST',
          uri: _buildUri('/api/v1/auth/refresh', null),
          headers: const <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{'refreshToken': refreshToken}),
        );
        final envelope = _decodeEnvelope(response);
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final data = envelope.data is Map<String, dynamic>
              ? envelope.data as Map<String, dynamic>
              : const <String, dynamic>{};
          _logger.info(
            'Auth session refreshed successfully',
            context: <String, Object?>{
              if (envelope.correlationId != null)
                'correlationId': envelope.correlationId,
            },
          );
          return AuthSession.fromJson(data);
        }
        throw _toApiException(
          response.statusCode,
          envelope.payload,
          fallbackPath: '/api/v1/auth/refresh',
          fallbackCorrelationId:
              envelope.correlationId ?? response.headers['x-correlation-id'],
        );
      });
      return refreshed != null;
    } on MateyaApiException catch (error) {
      _logApiFailure(
        'Auth session refresh failed',
        exception: error,
        method: 'POST',
      );
      if (error.type == ApiFailureType.validation ||
          error.type == ApiFailureType.unauthorized) {
        sessionStore.clear();
      }
      return false;
    } on TimeoutException catch (error, stackTrace) {
      _logger.warning(
        'Auth session refresh timed out',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    } catch (error, stackTrace) {
      _logger.error(
        'Auth session refresh failed with unexpected error',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  MateyaApiException _toApiException(
    int statusCode,
    Object? payload, {
    required String fallbackPath,
    String? fallbackCorrelationId,
  }) {
    String message = '요청 처리 중 오류가 발생했습니다.';
    String? code;
    String? title;
    String? path = fallbackPath;
    String? correlationId = fallbackCorrelationId;
    final fieldErrors = <String, String>{};

    if (payload is Map<String, dynamic>) {
      final error = payload['error'];
      if (error is Map<String, dynamic>) {
        code = error['code'] as String?;
        title = error['title'] as String?;
        message = (error['message'] as String?) ?? message;
        final details = error['details'];
        if (details is List<Object?>) {
          for (final item in details) {
            if (item is Map<String, dynamic>) {
              final field = item['field'] as String?;
              final fieldMessage = item['message'] as String?;
              if (field != null && fieldMessage != null) {
                fieldErrors[field] = fieldMessage;
              }
            }
          }
        }
      }

      final meta = payload['meta'];
      if (meta is Map<String, dynamic>) {
        path = meta['path'] as String? ?? path;
        correlationId = meta['correlationId'] as String? ?? correlationId;
      }
    }

    if (statusCode == 400) {
      return MateyaApiException(
        type: ApiFailureType.validation,
        message: message,
        code: code,
        title: title,
        statusCode: statusCode,
        path: path,
        correlationId: correlationId,
        fieldErrors: fieldErrors,
      );
    }
    if (statusCode == 401) {
      return MateyaApiException(
        type: ApiFailureType.unauthorized,
        message: message,
        code: code,
        title: title,
        statusCode: statusCode,
        path: path,
        correlationId: correlationId,
      );
    }
    return MateyaApiException(
      type: ApiFailureType.server,
      message: message,
      code: code,
      title: title,
      statusCode: statusCode,
      path: path,
      correlationId: correlationId,
      fieldErrors: fieldErrors,
    );
  }

  _ApiEnvelope _decodeEnvelope(HttpTransportResponse response) {
    if (response.body.isEmpty) {
      return const _ApiEnvelope(payload: null, data: null, correlationId: null);
    }

    final payload = jsonDecode(response.body) as Object?;
    if (payload is! Map<String, dynamic>) {
      return _ApiEnvelope(payload: payload, data: payload, correlationId: null);
    }

    final meta = payload['meta'];
    final correlationId = meta is Map<String, dynamic>
        ? meta['correlationId'] as String?
        : null;

    return _ApiEnvelope(
      payload: payload,
      data: payload.containsKey('data') ? payload['data'] : payload,
      correlationId: correlationId,
    );
  }

  void _logApiFailure(
    String message, {
    required MateyaApiException exception,
    required String method,
    int? durationMs,
  }) {
    final context = <String, Object?>{
      'method': method,
      'type': exception.type.name,
    };
    if (exception.path != null) {
      context['path'] = exception.path;
    }
    if (exception.statusCode != null) {
      context['statusCode'] = exception.statusCode;
    }
    if (exception.code != null) {
      context['code'] = exception.code;
    }
    if (exception.correlationId != null) {
      context['correlationId'] = exception.correlationId;
    }
    if (durationMs != null) {
      context['durationMs'] = durationMs;
    }

    switch (exception.type) {
      case ApiFailureType.network:
      case ApiFailureType.validation:
      case ApiFailureType.unauthorized:
        _logger.warning(message, error: exception, context: context);
        return;
      case ApiFailureType.server:
        _logger.error(message, error: exception, context: context);
        return;
    }
  }
}

class _ApiEnvelope {
  const _ApiEnvelope({
    required this.payload,
    required this.data,
    required this.correlationId,
  });

  final Object? payload;
  final Object? data;
  final String? correlationId;
}
