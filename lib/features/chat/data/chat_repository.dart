import 'dart:io';

import '../../../app/app_config.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/network/http_transport.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../domain/chat_models.dart';

abstract interface class ChatRepository {
  Future<List<ChatRoom>> fetchRooms();
  Future<ChatRoom> fetchRoom(String roomId);
  Future<List<ChatBubble>> sendMessage({
    required String roomId,
    required String text,
    required List<ChatAttachment> attachments,
  });
  Future<void> markRoomAsRead(String roomId);
}

class ApiChatRepository implements ChatRepository {
  ApiChatRepository({
    MateyaApiClient? apiClient,
    AuthSessionStore? sessionStore,
    HttpTransport? transport,
  }) : _sessionStore = sessionStore ?? AuthSessionStore.instance,
       _apiClient =
           apiClient ??
           MateyaApiClient(
             baseUrl: AppConfig.apiBaseUrl,
             sessionStore: sessionStore ?? AuthSessionStore.instance,
           ),
       _transport = transport ?? createHttpTransport();

  final AuthSessionStore _sessionStore;
  final MateyaApiClient _apiClient;
  final HttpTransport _transport;
  final Map<String, ChatRoom> _cachedRooms = <String, ChatRoom>{};

  @override
  Future<List<ChatRoom>> fetchRooms() async {
    try {
      final data = await _apiClient.getJson(
        '/api/v1/chats',
        requiresAuth: true,
        queryParameters: const <String, String>{'page': '0'},
      );
      final json = _asMap(data);
      final items = json['items'] as List<Object?>? ?? const <Object?>[];
      final rooms = items.map(_parseRoomSummary).toList(growable: false);
      _cachedRooms
        ..clear()
        ..addEntries(
          rooms.map((room) => MapEntry<String, ChatRoom>(room.id, room)),
        );
      return rooms;
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<ChatRoom> fetchRoom(String roomId) async {
    try {
      final summary = _cachedRooms[roomId] ?? await _fetchRoomSummary(roomId);
      final data = await _apiClient.getJson(
        '/api/v1/chats/$roomId/messages',
        requiresAuth: true,
        queryParameters: const <String, String>{'page': '0'},
      );
      final json = _asMap(data);
      final items = json['items'] as List<Object?>? ?? const <Object?>[];
      final messageGroups = items
          .map(_parseMessageGroup)
          .toList(growable: false);
      final room = summary.copyWith(messageGroups: messageGroups);
      _cachedRooms[roomId] = room;
      return room;
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<List<ChatBubble>> sendMessage({
    required String roomId,
    required String text,
    required List<ChatAttachment> attachments,
  }) async {
    final bubbles = <ChatBubble>[];
    final trimmedText = text.trim();

    try {
      if (trimmedText.isNotEmpty) {
        final textData = await _apiClient.postJson(
          '/api/v1/chats/$roomId/messages',
          requiresAuth: true,
          body: <String, Object?>{'type': 'TEXT', 'text': trimmedText},
        );
        bubbles.add(_parseMessageBubble(textData));
      }

      for (final attachment in attachments) {
        final imageUrl = await _uploadChatImage(attachment);
        final imageData = await _apiClient.postJson(
          '/api/v1/chats/$roomId/messages',
          requiresAuth: true,
          body: <String, Object?>{'type': 'IMAGE', 'imageUrl': imageUrl},
        );
        bubbles.add(_parseMessageBubble(imageData));
      }
      return bubbles;
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<void> markRoomAsRead(String roomId) async {
    try {
      await _apiClient.postJson(
        '/api/v1/chats/$roomId/read',
        requiresAuth: true,
      );
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  Future<ChatRoom> _fetchRoomSummary(String roomId) async {
    final rooms = await fetchRooms();
    final room = rooms.where((item) => item.id == roomId).firstOrNull;
    if (room == null) {
      throw const ChatRepositoryException(ChatLoadFailureType.server);
    }
    return room;
  }

  Future<String> _uploadChatImage(ChatAttachment attachment) async {
    final contentType = _contentTypeFor(attachment.fileName);
    if (contentType == null) {
      throw const ChatRepositoryException(
        ChatLoadFailureType.server,
        message: 'JPG, PNG, WEBP, GIF 형식의 이미지만 전송할 수 있어요.',
      );
    }

    final fileBytes = await File(attachment.path).readAsBytes();
    final presignedData = await _apiClient.postJson(
      '/api/v1/uploads/images/presigned-url',
      requiresAuth: true,
      body: <String, Object?>{
        'purpose': 'CHAT',
        'originalFilename': attachment.fileName,
        'contentType': contentType,
        'sizeBytes': attachment.fileSizeBytes,
        'requestedFileCount': 1,
      },
    );
    final presignedJson = _asMap(presignedData);
    final uploadUrl = presignedJson['uploadUrl'] as String?;
    final objectKey = presignedJson['objectKey'] as String?;
    if (uploadUrl == null || objectKey == null) {
      throw const ChatRepositoryException(ChatLoadFailureType.server);
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
      throw const ChatRepositoryException(
        ChatLoadFailureType.server,
        message: '채팅 이미지를 업로드하지 못했어요. 잠시 후 다시 시도해 주세요.',
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
      throw const ChatRepositoryException(ChatLoadFailureType.server);
    }
    return publicUrl;
  }

  ChatRoom _parseRoomSummary(Object? value) {
    final json = _asMap(value);
    final preview = json['lastMessagePreview'] as String?;
    final lastMessageAt = json['lastMessageAt'] as String?;
    final messageGroups = preview == null || preview.isEmpty
        ? const <ChatMessageGroup>[]
        : <ChatMessageGroup>[
            ChatMessageGroup(
              id: 'summary-${json['id']}',
              sender: ChatParticipant(
                id: 'summary-${json['id']}',
                name: json['title'] as String? ?? '',
              ),
              sentAt: _parseDateTime(lastMessageAt),
              bubbles: <ChatBubble>[ChatBubble(originalText: preview)],
            ),
          ];

    return ChatRoom(
      id: '${json['id']}',
      type: (json['type'] as String?) == 'DIRECT'
          ? ChatRoomType.direct
          : ChatRoomType.group,
      title: json['title'] as String? ?? '',
      imageUrl: '',
      participantCount: json['participantCount'] as int? ?? 0,
      lastMessageAt: _parseDateTime(lastMessageAt),
      unreadCount: json['unreadCount'] as int? ?? 0,
      messageGroups: messageGroups,
    );
  }

  ChatMessageGroup _parseMessageGroup(Object? value) {
    final json = _asMap(value);
    final senderId = '${json['senderUserId']}';
    final isMine = senderId == '${_sessionStore.session?.user.id}';

    return ChatMessageGroup(
      id: '${json['id']}',
      sender: ChatParticipant(
        id: senderId,
        name: json['senderDisplayName'] as String? ?? '',
        avatarUrl: json['senderProfileImageUrl'] as String?,
      ),
      sentAt: _parseDateTime(json['sentAt'] as String?),
      isMine: isMine,
      bubbles: <ChatBubble>[_parseMessageBubble(json)],
    );
  }

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

  DateTime _parseDateTime(String? value) {
    return DateTime.tryParse(value ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
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
}

class MockChatRepository implements ChatRepository {
  @override
  Future<List<ChatRoom>> fetchRooms() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _mockRooms.map(_cloneRoom).toList(growable: false);
  }

  @override
  Future<ChatRoom> fetchRoom(String roomId) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final room = _mockRooms.where((item) => item.id == roomId).firstOrNull;
    if (room == null) {
      throw const ChatRepositoryException(ChatLoadFailureType.server);
    }
    return _cloneRoom(room);
  }

  @override
  Future<List<ChatBubble>> sendMessage({
    required String roomId,
    required String text,
    required List<ChatAttachment> attachments,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return <ChatBubble>[
      ChatBubble(
        originalText: text.trim().isEmpty ? null : text.trim(),
        attachments: attachments,
      ),
    ];
  }

  @override
  Future<void> markRoomAsRead(String roomId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
  }
}

final ChatParticipant _me = ChatParticipant(id: 'me', name: '나');

final DateTime _now = DateTime.now();

final ChatParticipant _jiwon = ChatParticipant(
  id: 'jiwon',
  name: 'Ji-Won',
  secondaryName: '김지원',
  avatarUrl:
      'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?auto=format&fit=crop&w=240&q=80',
);

final ChatParticipant _nicolas = ChatParticipant(
  id: 'nicolas',
  name: 'Nicolas',
  secondaryName: '니콜라스',
  avatarUrl:
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=240&q=80',
);

final ChatParticipant _soyeon = ChatParticipant(
  id: 'soyeon',
  name: '서연',
  avatarUrl:
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=240&q=80',
);

final ChatParticipant _minho = ChatParticipant(
  id: 'minho',
  name: '민호',
  avatarUrl:
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=240&q=80',
);

final List<ChatRoom> _mockRooms = <ChatRoom>[
  ChatRoom(
    id: 'gyeongbokgung-walk',
    type: ChatRoomType.group,
    title: '경복궁 산책 모임',
    imageUrl:
        'https://images.unsplash.com/photo-1565967511849-76a60a516170?auto=format&fit=crop&w=240&q=80',
    participantCount: 18,
    lastMessageAt: _now.subtract(const Duration(minutes: 15)),
    unreadCount: 1,
    messageGroups: <ChatMessageGroup>[
      ChatMessageGroup(
        id: 'g-1',
        sender: _me,
        sentAt: _now.subtract(const Duration(minutes: 38)),
        isMine: true,
        bubbles: const <ChatBubble>[
          ChatBubble(originalText: '다들 뭐하고 지내요!'),
          ChatBubble(originalText: '우리 내일 보는건가요?'),
        ],
      ),
      ChatMessageGroup(
        id: 'g-2',
        sender: _jiwon,
        sentAt: _now.subtract(const Duration(minutes: 20)),
        bubbles: const <ChatBubble>[
          ChatBubble(
            originalText: '가나다라마바사',
            translatedText: 'See you all at the palace gate.',
          ),
          ChatBubble(
            originalText: '가나다라마바사',
            translatedText: 'I will arrive around 1:40 PM.',
          ),
          ChatBubble(
            originalText: '가나다라마바사가나다라마바사 가나다라마바사\n가나다라마바사?',
            translatedText:
                'Should we meet in front of the ticket booth\nbefore we start walking?',
          ),
        ],
      ),
      ChatMessageGroup(
        id: 'g-3',
        sender: _nicolas,
        sentAt: _now.subtract(const Duration(minutes: 15)),
        isTranslatedVisible: true,
        bubbles: const <ChatBubble>[
          ChatBubble(
            originalText: 'ASDFASdfsadf',
            translatedText: '좋아요, 저도 그쪽으로 갈게요.',
          ),
          ChatBubble(
            originalText: 'asdf1234asDFA',
            translatedText: '혹시 늦으면 채팅으로 남길게요.',
          ),
          ChatBubble(
            originalText: 'asdfasdf!@#\$!@#ADSFSADfasd\nasdfasdfasdf!@#\$@#',
            translatedText: '경복궁역 4번 출구 쪽에서 먼저 기다리고 있을게요.',
          ),
        ],
      ),
    ],
  ),
  ChatRoom(
    id: 'hongdae-language',
    type: ChatRoomType.direct,
    title: 'Nicolas 니콜라스',
    imageUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=240&q=80',
    participantCount: 2,
    lastMessageAt: _now.subtract(const Duration(hours: 2, minutes: 10)),
    unreadCount: 3,
    messageGroups: <ChatMessageGroup>[
      ChatMessageGroup(
        id: 'd-1',
        sender: _nicolas,
        sentAt: _now.subtract(const Duration(hours: 2, minutes: 10)),
        isTranslatedVisible: true,
        bubbles: const <ChatBubble>[
          ChatBubble(
            originalText: 'Can we switch to Korean after 8 PM?',
            translatedText: '오늘 8시 이후에는 한국어로 바꿔도 될까요?',
          ),
        ],
      ),
    ],
  ),
  ChatRoom(
    id: 'itaewon-dinner',
    type: ChatRoomType.direct,
    title: '서연',
    imageUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=240&q=80',
    participantCount: 2,
    lastMessageAt: _now.subtract(const Duration(days: 1, hours: 3)),
    unreadCount: 0,
    messageGroups: <ChatMessageGroup>[
      ChatMessageGroup(
        id: 'd-2',
        sender: _soyeon,
        sentAt: _now.subtract(const Duration(days: 1, hours: 3)),
        bubbles: const <ChatBubble>[ChatBubble(originalText: '여기서 만나요!')],
      ),
    ],
  ),
  ChatRoom(
    id: 'han-river-group',
    type: ChatRoomType.group,
    title: '한강 밤 산책 번개',
    imageUrl:
        'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=240&q=80',
    participantCount: 9,
    lastMessageAt: _now.subtract(const Duration(days: 10)),
    unreadCount: 12,
    messageGroups: <ChatMessageGroup>[
      ChatMessageGroup(
        id: 'g-4',
        sender: _minho,
        sentAt: _now.subtract(const Duration(days: 10)),
        bubbles: const <ChatBubble>[
          ChatBubble(originalText: '오늘 코스는 잠수교부터 시작해요.'),
        ],
      ),
    ],
  ),
  ChatRoom(
    id: 'pottery-class',
    type: ChatRoomType.group,
    title: '이천 도자기 체험 클래스',
    imageUrl:
        'https://images.unsplash.com/photo-1517048676732-d65bc937f952?auto=format&fit=crop&w=240&q=80',
    participantCount: 14,
    lastMessageAt: _now.subtract(const Duration(days: 380)),
    unreadCount: 20,
    messageGroups: <ChatMessageGroup>[
      ChatMessageGroup(
        id: 'g-5',
        sender: _soyeon,
        sentAt: _now.subtract(const Duration(days: 380)),
        bubbles: const <ChatBubble>[
          ChatBubble(originalText: '준비물은 앞치마만 챙겨주세요.'),
        ],
      ),
    ],
  ),
];

ChatRoom _cloneRoom(ChatRoom room) {
  return room.copyWith(
    messageGroups: room.messageGroups
        .map(
          (group) => group.copyWith(
            sender: group.sender.copyWith(),
            bubbles: group.bubbles
                .map(
                  (bubble) => bubble.copyWith(
                    attachments: bubble.attachments
                        .map((attachment) => attachment.copyWith())
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList(),
  );
}
