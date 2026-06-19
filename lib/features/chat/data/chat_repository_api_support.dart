part of 'chat_repository.dart';

ChatRoom _parseRoomSummary(Object? value) {
  final json = _asMap(value);
  final roomType = (json['type'] as String?) == 'DIRECT'
      ? ChatRoomType.direct
      : ChatRoomType.group;
  final roomTitle = _resolveRoomTitle(json['title'] as String?, type: roomType);
  final preview = json['lastMessagePreview'] as String?;
  final lastMessageAt = _parseDateTime(json['lastMessageAt']);
  final messageGroups =
      preview == null || preview.isEmpty || lastMessageAt == null
      ? const <ChatMessageGroup>[]
      : <ChatMessageGroup>[
          ChatMessageGroup(
            id: 'summary-${json['id']}',
            sender: ChatParticipant(
              id: 'summary-${json['id']}',
              name: roomTitle,
            ),
            sentAt: lastMessageAt,
            bubbles: <ChatBubble>[ChatBubble(originalText: preview)],
          ),
        ];

  return ChatRoom(
    id: '${json['id']}',
    type: roomType,
    title: roomTitle,
    imageUrl: json['counterpartProfileImageUrl'] as String? ?? '',
    participantCount: json['participantCount'] as int? ?? 0,
    lastMessageAt: lastMessageAt,
    unreadCount: json['unreadCount'] as int? ?? 0,
    messageGroups: messageGroups,
  );
}

String _resolveRoomTitle(String? rawTitle, {required ChatRoomType type}) {
  final trimmed = rawTitle?.trim() ?? '';
  if (trimmed.isEmpty) {
    return type == ChatRoomType.direct ? '1:1 채팅' : '채팅방';
  }
  if (type == ChatRoomType.direct &&
      RegExp(r'^direct:\d+:\d+$').hasMatch(trimmed)) {
    return '1:1 채팅';
  }
  return trimmed;
}

ChatMessageGroup _parseMessageGroup(Object? value) {
  final json = _asMap(value);
  final senderId = '${json['senderUserId']}';
  final isMine = senderId == '${_chatRepositorySessionStore?.session?.user.id}';

  return ChatMessageGroup(
    id: '${json['id']}',
    sender: ChatParticipant(
      id: senderId,
      name: json['senderDisplayName'] as String? ?? '',
      avatarUrl: json['senderProfileImageUrl'] as String?,
    ),
    sentAt: _parseDateTime(json['sentAt']) ?? DateTime.now(),
    isMine: isMine,
    bubbles: <ChatBubble>[_parseMessageBubble(json)],
  );
}

AuthSessionStore? _chatRepositorySessionStore;

ChatBubble _parseMessageBubble(Object? value) {
  final json = _asMap(value);
  final translatedText = json['text'] as String?;
  final originalText = json['originalText'] as String?;
  final imageUrl = json['imageUrl'] as String?;
  return ChatBubble(
    originalText: originalText ?? translatedText,
    translatedText:
        translatedText != null &&
            originalText != null &&
            translatedText != originalText
        ? translatedText
        : null,
    attachments: imageUrl == null
        ? const <ChatAttachment>[]
        : <ChatAttachment>[
            ChatAttachment(
              id: 'remote-${json['id']}',
              path: imageUrl,
              fileName: imageUrl.split('/').last,
              fileSizeBytes: 0,
              source: ChatAttachmentSource.gallery,
            ),
          ],
  );
}

DateTime? _parseDateTime(Object? value) {
  final normalized = switch (value) {
    null => null,
    String stringValue =>
      stringValue.trim().isEmpty ? null : stringValue.trim(),
    _ => '$value',
  };
  if (normalized == null) {
    return null;
  }
  return DateTime.tryParse(normalized);
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

ChatRepositoryException _mapApiException(MateyaApiException error) {
  if (error.type == ApiFailureType.network) {
    return ChatRepositoryException(
      ChatLoadFailureType.network,
      message: error.message,
    );
  }
  return ChatRepositoryException(
    ChatLoadFailureType.server,
    message: error.message,
  );
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  return const <String, dynamic>{};
}
