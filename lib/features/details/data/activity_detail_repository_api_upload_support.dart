part of 'activity_detail_repository.dart';

Future<List<String>> _resolveReviewImageUrls({
  required List<String> imageUrls,
  required MateyaApiClient apiClient,
  required HttpTransport transport,
}) async {
  if (imageUrls.isEmpty) {
    return const <String>[];
  }

  final resolved = <String>[];
  for (final imageUrl in imageUrls) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      resolved.add(imageUrl);
      continue;
    }
    resolved.add(
      await _uploadReviewImage(
        apiClient: apiClient,
        transport: transport,
        imagePath: imageUrl,
        requestedFileCount: imageUrls.length,
      ),
    );
  }
  return resolved;
}

Future<String> _uploadReviewImage({
  required MateyaApiClient apiClient,
  required HttpTransport transport,
  required String imagePath,
  required int requestedFileCount,
}) async {
  final file = File(imagePath);
  final fileName = imagePath.split('/').last;
  final contentType = _contentTypeFor(fileName);
  if (contentType == null) {
    throw ActivityDetailRepositoryException(
      ActivityDetailLoadFailureType.validation,
      message: MateyaLocalizations.current.detailsReviewImageInvalidFormat,
    );
  }

  final fileSize = await file.length();
  final fileBytes = await file.readAsBytes();
  final presignedData = await apiClient.postJson(
    '/api/v1/uploads/images/presigned-url',
    requiresAuth: true,
    body: <String, Object?>{
      'purpose': 'REVIEW',
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
    throw const ActivityDetailRepositoryException(
      ActivityDetailLoadFailureType.server,
    );
  }

  final uploadResponse = await transport.send(
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
    throw ActivityDetailRepositoryException(
      ActivityDetailLoadFailureType.server,
      message: MateyaLocalizations.current.detailsReviewImageUploadError,
    );
  }

  final confirmedData = await apiClient.postJson(
    '/api/v1/uploads/images/confirm',
    requiresAuth: true,
    body: <String, Object?>{'objectKey': objectKey},
  );
  final confirmedJson = _asMap(confirmedData);
  final publicUrl = confirmedJson['publicUrl'] as String?;
  if (publicUrl == null || publicUrl.isEmpty) {
    throw const ActivityDetailRepositoryException(
      ActivityDetailLoadFailureType.server,
    );
  }
  return publicUrl;
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
