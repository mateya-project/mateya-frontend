part of 'mypage_repository.dart';

Future<String> _uploadProfileImage({
  required MateyaApiClient apiClient,
  required HttpTransport transport,
  required String imagePath,
}) async {
  final file = File(imagePath);
  final fileName = imagePath.split('/').last;
  final contentType = _profileImageContentTypeFor(fileName);
  if (contentType == null) {
    throw const MyPageRepositoryException(
      MyPageLoadFailureType.server,
      message: 'JPG, PNG, WEBP, GIF 형식의 이미지만 업로드할 수 있어요.',
    );
  }

  final fileSize = await file.length();
  final fileBytes = await file.readAsBytes();
  final presignedData = await apiClient.postJson(
    '/api/v1/uploads/images/presigned-url',
    requiresAuth: true,
    body: <String, Object?>{
      'purpose': 'PROFILE',
      'originalFilename': fileName,
      'contentType': contentType,
      'sizeBytes': fileSize,
      'requestedFileCount': 1,
    },
  );
  final presignedJson = _asMap(presignedData);
  final uploadUrl = presignedJson['uploadUrl'] as String?;
  final objectKey = presignedJson['objectKey'] as String?;
  if (uploadUrl == null || objectKey == null) {
    throw const MyPageRepositoryException(MyPageLoadFailureType.server);
  }

  final uploadResponse = await transport.send(
    method: 'PUT',
    uri: Uri.parse(uploadUrl),
    headers: _flattenProfileUploadHeaders(
      presignedJson['headers'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      fallbackContentType: contentType,
    ),
    bodyBytes: fileBytes,
  );
  if (uploadResponse.statusCode < 200 || uploadResponse.statusCode >= 300) {
    throw const MyPageRepositoryException(
      MyPageLoadFailureType.server,
      message: '프로필 이미지를 업로드하지 못했어요. 잠시 후 다시 시도해 주세요.',
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
    throw const MyPageRepositoryException(
      MyPageLoadFailureType.server,
      message: '프로필 이미지 업로드 확인에 실패했어요. 잠시 후 다시 시도해 주세요.',
    );
  }
  return publicUrl;
}

Map<String, String> _flattenProfileUploadHeaders(
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

String? _profileImageContentTypeFor(String fileName) {
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
