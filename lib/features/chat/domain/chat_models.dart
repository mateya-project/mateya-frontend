enum ChatRoomType { group, direct }

enum ChatListFilter { all, group, direct }

enum ChatLoadFailureType { network, server }

enum ChatAttachmentSource { camera, gallery }

class ChatParticipant {
  const ChatParticipant({
    required this.id,
    required this.name,
    this.secondaryName,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String? secondaryName;
  final String? avatarUrl;

  String get displayName =>
      secondaryName == null || secondaryName!.trim().isEmpty
      ? name
      : '$name ${secondaryName!.trim()}';

  ChatParticipant copyWith({
    String? id,
    String? name,
    Object? secondaryName = _sentinel,
    Object? avatarUrl = _sentinel,
  }) {
    return ChatParticipant(
      id: id ?? this.id,
      name: name ?? this.name,
      secondaryName: secondaryName == _sentinel
          ? this.secondaryName
          : secondaryName as String?,
      avatarUrl: avatarUrl == _sentinel ? this.avatarUrl : avatarUrl as String?,
    );
  }
}

class ChatBubble {
  const ChatBubble({
    this.originalText,
    this.translatedText,
    this.attachments = const <ChatAttachment>[],
  });

  final String? originalText;
  final String? translatedText;
  final List<ChatAttachment> attachments;

  bool get hasText => originalText != null && originalText!.trim().isNotEmpty;
  bool get hasAttachments => attachments.isNotEmpty;

  String? resolvedText(bool isTranslatedVisible) {
    if (!hasText) {
      return null;
    }
    if (isTranslatedVisible && translatedText != null) {
      return translatedText;
    }
    return originalText;
  }

  String get previewSummary {
    if (hasText) {
      return originalText!.replaceAll('\n', ' ');
    }
    if (hasAttachments) {
      return '사진 ${attachments.length}장';
    }
    return '';
  }

  ChatBubble copyWith({
    Object? originalText = _sentinel,
    Object? translatedText = _sentinel,
    List<ChatAttachment>? attachments,
  }) {
    return ChatBubble(
      originalText: originalText == _sentinel
          ? this.originalText
          : originalText as String?,
      translatedText: translatedText == _sentinel
          ? this.translatedText
          : translatedText as String?,
      attachments: attachments ?? this.attachments,
    );
  }
}

class ChatAttachment {
  const ChatAttachment({
    required this.id,
    required this.path,
    required this.fileName,
    required this.fileSizeBytes,
    required this.source,
  });

  final String id;
  final String path;
  final String fileName;
  final int fileSizeBytes;
  final ChatAttachmentSource source;

  ChatAttachment copyWith({
    String? id,
    String? path,
    String? fileName,
    int? fileSizeBytes,
    ChatAttachmentSource? source,
  }) {
    return ChatAttachment(
      id: id ?? this.id,
      path: path ?? this.path,
      fileName: fileName ?? this.fileName,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      source: source ?? this.source,
    );
  }
}

class ChatMessageGroup {
  const ChatMessageGroup({
    required this.id,
    required this.sender,
    required this.sentAt,
    required this.bubbles,
    this.isMine = false,
    this.isTranslatedVisible = false,
  });

  final String id;
  final ChatParticipant sender;
  final DateTime sentAt;
  final List<ChatBubble> bubbles;
  final bool isMine;
  final bool isTranslatedVisible;

  bool get supportsTranslation =>
      !isMine && bubbles.any((bubble) => bubble.translatedText != null);

  String get translationToggleLabel => isTranslatedVisible ? '원문 보기' : '번역 보기';

  List<String> get visibleTexts {
    return bubbles
        .map((bubble) => bubble.resolvedText(isTranslatedVisible))
        .whereType<String>()
        .toList(growable: false);
  }

  String get previewText => bubbles.isEmpty ? '' : bubbles.last.previewSummary;

  ChatMessageGroup copyWith({
    String? id,
    ChatParticipant? sender,
    DateTime? sentAt,
    List<ChatBubble>? bubbles,
    bool? isMine,
    bool? isTranslatedVisible,
  }) {
    return ChatMessageGroup(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      sentAt: sentAt ?? this.sentAt,
      bubbles: bubbles ?? this.bubbles,
      isMine: isMine ?? this.isMine,
      isTranslatedVisible: isTranslatedVisible ?? this.isTranslatedVisible,
    );
  }
}

class ChatRoom {
  const ChatRoom({
    required this.id,
    required this.type,
    required this.title,
    required this.imageUrl,
    required this.participantCount,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.messageGroups,
  });

  final String id;
  final ChatRoomType type;
  final String title;
  final String? imageUrl;
  final int participantCount;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final List<ChatMessageGroup> messageGroups;

  String get subtitle => '$participantCount명 참여';

  String get lastMessagePreview =>
      messageGroups.isEmpty ? '' : messageGroups.last.previewText;

  ChatRoom copyWith({
    String? id,
    ChatRoomType? type,
    String? title,
    String? imageUrl,
    int? participantCount,
    Object? lastMessageAt = _sentinel,
    int? unreadCount,
    List<ChatMessageGroup>? messageGroups,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      participantCount: participantCount ?? this.participantCount,
      lastMessageAt: lastMessageAt == _sentinel
          ? this.lastMessageAt
          : lastMessageAt as DateTime?,
      unreadCount: unreadCount ?? this.unreadCount,
      messageGroups: messageGroups ?? this.messageGroups,
    );
  }
}

class ChatRepositoryException implements Exception {
  const ChatRepositoryException(this.type, {this.message});

  final ChatLoadFailureType type;
  final String? message;
}

extension ChatListFilterX on ChatListFilter {
  String get label => switch (this) {
    ChatListFilter.all => '전체',
    ChatListFilter.group => '단체',
    ChatListFilter.direct => '개인',
  };
}

const Object _sentinel = Object();
