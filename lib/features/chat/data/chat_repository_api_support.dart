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
    imageUrl: _resolveRoomImageUrl(json, roomType: roomType),
    participantCount: json['participantCount'] as int? ?? 0,
    lastMessageAt: lastMessageAt,
    unreadCount: json['unreadCount'] as int? ?? 0,
    messageGroups: messageGroups,
  );
}

String? _resolveRoomImageUrl(
  Map<String, dynamic> json, {
  required ChatRoomType roomType,
}) {
  final roomImageUrl = _nonEmptyString(json['roomImageUrl']);
  if (roomImageUrl != null) {
    return roomImageUrl;
  }

  final legacyImageUrl = _nonEmptyString(json['imageUrl']);
  if (legacyImageUrl != null) {
    return legacyImageUrl;
  }

  if (roomType == ChatRoomType.direct) {
    return _nonEmptyString(json['counterpartProfileImageUrl']);
  }
  return null;
}

String _resolveRoomTitle(String? rawTitle, {required ChatRoomType type}) {
  final l10n = MateyaLocalizations.current;
  final trimmed = rawTitle?.trim() ?? '';
  if (trimmed.isEmpty) {
    return type == ChatRoomType.direct
        ? l10n.chatDefaultDirectRoomTitle
        : l10n.chatDefaultGroupRoomTitle;
  }
  if (type == ChatRoomType.direct &&
      RegExp(r'^direct:\d+:\d+$').hasMatch(trimmed)) {
    return l10n.chatDefaultDirectRoomTitle;
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
    sentAt: _parseDateTime(json['sentAt']) ?? mateyaNowInKst(),
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
  return tryParseServerDateTime(value);
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
  if (normalized.endsWith('.heic')) {
    return 'image/heic';
  }
  if (normalized.endsWith('.heif')) {
    return 'image/heif';
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

String? _nonEmptyString(Object? value) {
  if (value is! String) {
    return null;
  }
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
