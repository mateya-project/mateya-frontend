import 'dart:async';
import 'dart:convert';

import '../auth/auth_session.dart';
import 'http_transport.dart';

enum ApiFailureType { network, validation, unauthorized, server }

class MateyaApiException implements Exception {
  const MateyaApiException({
    required this.type,
    required this.message,
    this.code,
    this.statusCode,
    this.fieldErrors = const <String, String>{},
  });

  final ApiFailureType type;
  final String message;
  final String? code;
  final int? statusCode;
  final Map<String, String> fieldErrors;
}

class MateyaApiClient {
  MateyaApiClient({
    required this.baseUrl,
    required this.sessionStore,
    HttpTransport? transport,
  }) : _transport = transport ?? createHttpTransport();

  final String baseUrl;
  final AuthSessionStore sessionStore;
  final HttpTransport _transport;

  Future<Object?> getJson(
    String path, {
    Map<String, String> queryParameters = const <String, String>{},
    Map<String, List<String>> queryParametersAll =
        const <String, List<String>>{},
    bool requiresAuth = false,
  }) {
    return _sendJson(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
      queryParametersAll: queryParametersAll,
      requiresAuth: requiresAuth,
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
  }) async {
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

    if (requiresAuth) {
      final accessToken = sessionStore.session?.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        throw const MateyaApiException(
          type: ApiFailureType.unauthorized,
          message: '로그인이 필요합니다.',
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
        final payload = response.body.isEmpty
            ? null
            : jsonDecode(response.body) as Object?;

        if (response.statusCode >= 200 && response.statusCode < 300) {
          if (payload is Map<String, dynamic>) {
            return payload['data'];
          }
          return payload;
        }

        throw _toApiException(response.statusCode, payload);
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
          );
        }
        rethrow;
      }
    } on MateyaApiException {
      rethrow;
    } on TimeoutException {
      throw const MateyaApiException(
        type: ApiFailureType.network,
        message: '네트워크 연결을 확인한 뒤 다시 시도해 주세요.',
      );
    } catch (_) {
      throw const MateyaApiException(
        type: ApiFailureType.network,
        message: '네트워크 연결을 확인한 뒤 다시 시도해 주세요.',
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
        final payload = response.body.isEmpty
            ? null
            : jsonDecode(response.body) as Object?;
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final data = payload is Map<String, dynamic>
              ? payload['data'] as Map<String, dynamic>? ??
                    const <String, dynamic>{}
              : const <String, dynamic>{};
          return AuthSession.fromJson(data);
        }
        throw _toApiException(response.statusCode, payload);
      });
      return refreshed != null;
    } on MateyaApiException catch (error) {
      if (error.type == ApiFailureType.validation ||
          error.type == ApiFailureType.unauthorized) {
        sessionStore.clear();
      }
      return false;
    } on TimeoutException {
      return false;
    } catch (_) {
      return false;
    }
  }

  MateyaApiException _toApiException(int statusCode, Object? payload) {
    String message = '요청 처리 중 오류가 발생했습니다.';
    String? code;
    final fieldErrors = <String, String>{};

    if (payload is Map<String, dynamic>) {
      final error = payload['error'];
      if (error is Map<String, dynamic>) {
        code = error['code'] as String?;
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
    }

    if (statusCode == 400) {
      return MateyaApiException(
        type: ApiFailureType.validation,
        message: message,
        code: code,
        statusCode: statusCode,
        fieldErrors: fieldErrors,
      );
    }
    if (statusCode == 401) {
      return MateyaApiException(
        type: ApiFailureType.unauthorized,
        message: message,
        code: code,
        statusCode: statusCode,
      );
    }
    return MateyaApiException(
      type: ApiFailureType.server,
      message: message,
      code: code,
      statusCode: statusCode,
    );
  }
}
