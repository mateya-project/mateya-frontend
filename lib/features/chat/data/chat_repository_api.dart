part of 'chat_repository.dart';

class ApiChatRepository implements ChatRepository {
  ApiChatRepository({
    MateyaApiClient? apiClient,
    AuthSessionStore? sessionStore,
    HttpTransport? transport,
    ChatRealtimeClient? realtimeClient,
  }) : _sessionStore = sessionStore ?? AuthSessionStore.instance,
       _realtimeClient =
           realtimeClient ??
           ChatRealtimeClient(
             sessionStore: sessionStore ?? AuthSessionStore.instance,
           ),
       _apiClient =
           apiClient ??
           MateyaApiClient(
             baseUrl: AppConfig.apiBaseUrl,
             sessionStore: sessionStore ?? AuthSessionStore.instance,
           ),
       _transport = transport ?? createHttpTransport() {
    _chatRepositorySessionStore = _sessionStore;
  }

  final AuthSessionStore _sessionStore;
  final ChatRealtimeClient _realtimeClient;
  final MateyaApiClient _apiClient;
  final HttpTransport _transport;
  final Map<String, ChatRoom> _cachedRooms = <String, ChatRoom>{};

  @override
  Future<List<ChatRoom>> fetchRooms() async {
    final result = await fetchRoomsPage(page: 0);
    return result.rooms;
  }

  @override
  Future<ChatRoomPageResult> fetchRoomsPage({required int page}) async {
    try {
      final data = await _apiClient.getJson(
        '/api/v1/chats',
        requiresAuth: true,
        queryParameters: <String, String>{'page': '$page'},
      );
      final json = _asMap(data);
      final items = json['items'] as List<Object?>? ?? const <Object?>[];
      final rooms = items.map(_parseRoomSummary).toList(growable: false);
      if (page == 0) {
        _cachedRooms.clear();
      }
      _cachedRooms.addEntries(
        rooms.map((room) => MapEntry<String, ChatRoom>(room.id, room)),
      );
      return ChatRoomPageResult(
        rooms: rooms,
        hasNext: json['hasNext'] as bool? ?? false,
        nextPage: json['nextPage'] as int?,
      );
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<ChatRoom> fetchRoom(String roomId) async {
    final pageResult = await fetchRoomMessagesPage(roomId: roomId, page: 0);
    final summary = _cachedRooms[roomId] ?? await _fetchRoomSummary(roomId);
    final room = summary.copyWith(messageGroups: pageResult.groups);
    _cachedRooms[roomId] = room;
    return room;
  }

  @override
  Future<ChatMessagePageResult> fetchRoomMessagesPage({
    required String roomId,
    required int page,
  }) async {
    try {
      final data = await _apiClient.getJson(
        '/api/v1/chats/$roomId/messages',
        requiresAuth: true,
        queryParameters: <String, String>{'page': '$page'},
      );
      final json = _asMap(data);
      final items = json['items'] as List<Object?>? ?? const <Object?>[];
      final messageGroups = items
          .map(_parseMessageGroup)
          .toList(growable: false);
      return ChatMessagePageResult(
        groups: messageGroups,
        hasNext: json['hasNext'] as bool? ?? false,
        nextPage: json['nextPage'] as int?,
      );
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<ChatMessageGroup> fetchMessage({
    required String roomId,
    required String messageId,
    required bool original,
  }) async {
    try {
      final data = await _apiClient.getJson(
        '/api/v1/chats/$roomId/messages/$messageId',
        requiresAuth: true,
        queryParameters: <String, String>{'original': '$original'},
      );
      return _parseMessageGroup(data);
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

  @override
  void subscribeToRoomMessages({
    required String roomId,
    required void Function(ChatMessageGroup message) onMessage,
    required void Function(String message) onError,
  }) {
    _realtimeClient.subscribeToRoom(
      roomId: roomId,
      onMessage: onMessage,
      onError: onError,
      parseMessage: _parseMessageGroup,
    );
  }

  @override
  void unsubscribeFromRoomMessages() {
    _realtimeClient.disconnect();
  }

  @override
  bool isRealtimeConnectedForRoom(String roomId) {
    return _realtimeClient.isConnectedForRoom(roomId);
  }

  @override
  void dispose() {
    _realtimeClient.disconnect();
  }

  Future<ChatRoom> _fetchRoomSummary(String roomId) async {
    var page = 0;
    while (true) {
      final pageResult = await fetchRoomsPage(page: page);
      final room = pageResult.rooms
          .where((item) => item.id == roomId)
          .firstOrNull;
      if (room != null) {
        return room;
      }
      if (!pageResult.hasNext || pageResult.nextPage == null) {
        break;
      }
      page = pageResult.nextPage!;
    }
    throw const ChatRepositoryException(ChatLoadFailureType.server);
  }

  Future<String> _uploadChatImage(ChatAttachment attachment) async {
    final contentType = _contentTypeFor(attachment.fileName);
    if (contentType == null) {
      throw ChatRepositoryException(
        ChatLoadFailureType.server,
        message: MateyaLocalizations.current.chatAttachmentInvalidFormat,
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
      throw ChatRepositoryException(
        ChatLoadFailureType.server,
        message: MateyaLocalizations.current.chatAttachmentUploadFailed,
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
}
