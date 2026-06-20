import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../app/app_config.dart';
import '../auth/auth_session.dart';
import '../localization/mateya_localizations.dart';
import '../network/http_transport.dart';
import '../network/mateya_api_client.dart';

enum ReportTargetType { user, activity, chatMessage, review }

extension ReportTargetTypeX on ReportTargetType {
  String get apiValue => switch (this) {
    ReportTargetType.user => 'USER',
    ReportTargetType.activity => 'ACTIVITY',
    ReportTargetType.chatMessage => 'CHAT_MESSAGE',
    ReportTargetType.review => 'REVIEW',
  };
}

class ReportRepositoryException implements Exception {
  const ReportRepositoryException(this.message);

  final String message;
}

class ReportRepository {
  ReportRepository({
    MateyaApiClient? apiClient,
    AuthSessionStore? sessionStore,
    HttpTransport? transport,
  }) : _apiClient =
           apiClient ??
           MateyaApiClient(
             baseUrl: AppConfig.apiBaseUrl,
             sessionStore: sessionStore ?? AuthSessionStore.instance,
           ),
       _transport = transport ?? createHttpTransport();

  final MateyaApiClient _apiClient;
  final HttpTransport _transport;

  Future<void> submitReport({
    required ReportTargetType targetType,
    required String targetId,
    required String reason,
    List<XFile> images = const <XFile>[],
  }) async {
    final trimmedReason = reason.trim();
    if (trimmedReason.isEmpty) {
      throw ReportRepositoryException(
        MateyaLocalizations.current.reportReasonRequired,
      );
    }

    try {
      final imageUrls = await _uploadReportImages(images);
      await _apiClient.postJson(
        '/api/v1/reports',
        requiresAuth: true,
        body: <String, Object?>{
          'targetType': targetType.apiValue,
          'targetId': targetId,
          'reason': trimmedReason,
          'imageUrls': imageUrls,
        },
      );
    } on MateyaApiException catch (error) {
      throw ReportRepositoryException(error.message);
    }
  }

  Future<List<String>> _uploadReportImages(List<XFile> images) async {
    if (images.isEmpty) {
      return const <String>[];
    }

    final uploaded = <String>[];
    for (final image in images) {
      uploaded.add(
        await _uploadReportImage(
          image: image,
          requestedFileCount: images.length,
        ),
      );
    }
    return uploaded;
  }

  Future<String> _uploadReportImage({
    required XFile image,
    required int requestedFileCount,
  }) async {
    final fileName = image.name.isEmpty
        ? image.path.split('/').last
        : image.name;
    final contentType = _contentTypeFor(fileName);
    if (contentType == null) {
      throw ReportRepositoryException(
        MateyaLocalizations.current.reportImageInvalidFormat,
      );
    }

    final file = File(image.path);
    final fileBytes = await file.readAsBytes();
    final fileSize = await file.length();
    final presignedData = await _apiClient.postJson(
      '/api/v1/uploads/images/presigned-url',
      requiresAuth: true,
      body: <String, Object?>{
        'purpose': 'REPORT',
        'originalFilename': fileName,
        'contentType': contentType,
        'sizeBytes': fileSize,
        'requestedFileCount': requestedFileCount,
      },
    );
    final presignedJson = _asMap(presignedData);
    final uploadUrl = presignedJson['uploadUrl'] as String?;
    final objectKey = presignedJson['objectKey'] as String?;
    if (uploadUrl == null || objectKey == null) {
      throw ReportRepositoryException(
        MateyaLocalizations.current.reportImageUploadError,
      );
    }

    final uploadResponse = await _transport.send(
      method: 'PUT',
      uri: Uri.parse(uploadUrl),
      headers: _flattenHeaders(
        presignedJson['headers'] as Map<String, dynamic>? ??
            const <String, dynamic>{},
        fallbackContentType: contentType,
      ),
      bodyBytes: fileBytes,
    );
    if (uploadResponse.statusCode < 200 || uploadResponse.statusCode >= 300) {
      throw ReportRepositoryException(
        MateyaLocalizations.current.reportImageUploadError,
      );
    }

    final confirmedData = await _apiClient.postJson(
      '/api/v1/uploads/images/confirm',
      requiresAuth: true,
      body: <String, Object?>{'objectKey': objectKey},
    );
    final confirmedJson = _asMap(confirmedData);
    final publicUrl = confirmedJson['publicUrl'] as String?;
    if (publicUrl == null || publicUrl.isEmpty) {
      throw ReportRepositoryException(
        MateyaLocalizations.current.reportImageConfirmError,
      );
    }
    return publicUrl;
  }
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  return const <String, dynamic>{};
}

Map<String, String> _flattenHeaders(
  Map<String, dynamic> rawHeaders, {
  required String fallbackContentType,
}) {
  final headers = <String, String>{};
  rawHeaders.forEach((key, value) {
    if (value is List<Object?>) {
      final joined = value.whereType<String>().join(', ');
      if (joined.isNotEmpty) {
        headers[key] = joined;
      }
      return;
    }
    if (value is String && value.isNotEmpty) {
      headers[key] = value;
    }
  });
  headers.putIfAbsent('Content-Type', () => fallbackContentType);
  return headers;
}

String? _contentTypeFor(String fileName) {
  final normalized = fileName.toLowerCase();
  if (normalized.endsWith('.jpg') || normalized.endsWith('.jpeg')) {
    return 'image/jpeg';
  }
  if (normalized.endsWith('.png')) {
    return 'image/png';
  }
  if (normalized.endsWith('.webp')) {
    return 'image/webp';
  }
  if (normalized.endsWith('.gif')) {
    return 'image/gif';
  }
  return null;
}
