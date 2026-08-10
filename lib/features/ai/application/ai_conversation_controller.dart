import 'package:flutter/foundation.dart';

import '../../onboarding/domain/onboarding_flow.dart';
import '../../../shared/localization/mateya_localizations.dart';
import '../data/ai_repository.dart';
import '../domain/ai_models.dart';

class AiConversationController extends ChangeNotifier {
  AiConversationController({required this.repository});

  final AiRepository repository;

  AsyncPhase _listPhase = AsyncPhase.idle;
  AsyncPhase _roomPhase = AsyncPhase.idle;
  List<AiConversationSummary> _conversations = const <AiConversationSummary>[];
  AiConversation? _current;
  String? _errorMessage;
  bool _isSending = false;
  String? _progressMessage;

  AsyncPhase get listPhase => _listPhase;
  AsyncPhase get roomPhase => _roomPhase;
  List<AiConversationSummary> get conversations => _conversations;
  AiConversation? get current => _current;
  String? get errorMessage => _errorMessage;
  bool get isRoomOpen => _current != null;
  bool get isSending => _isSending;
  String? get progressMessage => _progressMessage;

  Future<void> initialize({AiConversationSeed? seed}) async {
    await loadConversations();
    if (seed != null) {
      await startConversation(seed);
    }
  }

  Future<void> loadConversations() async {
    _listPhase = AsyncPhase.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _conversations = await repository.fetchConversations();
      _listPhase = AsyncPhase.success;
    } catch (_) {
      _listPhase = AsyncPhase.serverError;
      _errorMessage = MateyaLocalizations.current.aiConversationListLoadFailed;
    }
    notifyListeners();
  }

  Future<void> startConversation([
    AiConversationSeed seed = const AiConversationSeed(entryPoint: 'CHAT_LIST'),
  ]) async {
    _roomPhase = AsyncPhase.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _current = await repository.createConversation(seed);
      _roomPhase = AsyncPhase.success;
    } catch (_) {
      _roomPhase = AsyncPhase.serverError;
      _errorMessage = MateyaLocalizations.current.aiConversationStartFailed;
    }
    notifyListeners();
  }

  Future<void> openConversation(String id) async {
    _roomPhase = AsyncPhase.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _current = await repository.fetchConversation(id);
      _roomPhase = AsyncPhase.success;
    } catch (_) {
      _roomPhase = AsyncPhase.serverError;
      _errorMessage = MateyaLocalizations.current.aiConversationLoadFailed;
    }
    notifyListeners();
  }

  void closeConversation() {
    _current = null;
    _roomPhase = AsyncPhase.idle;
    notifyListeners();
    loadConversations();
  }

  Future<bool> sendMessage(
    String message, {
    List<AiMessageAttachment> attachments = const <AiMessageAttachment>[],
  }) async {
    final conversation = _current;
    final normalized = message.trim().isEmpty && attachments.isNotEmpty
        ? '이 사진을 여행 참고자료로 추가할게'
        : message.trim();
    if (conversation == null || normalized.isEmpty || _isSending) {
      return false;
    }
    _isSending = true;
    _progressMessage = attachments.isEmpty
        ? MateyaLocalizations.current.commonProcessing
        : MateyaLocalizations.current.aiUploadingPhoto;
    _errorMessage = null;
    notifyListeners();
    try {
      _current = await repository.sendMessage(
        conversationId: conversation.id,
        clientMessageId:
            'flutter-${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}',
        message: normalized,
        attachments: attachments,
        onProgress: (stage) {
          _progressMessage = switch (stage) {
            'accepted' => MateyaLocalizations.current.aiCheckingData,
            'completed' => MateyaLocalizations.current.commonProcessing,
            _ => _progressMessage,
          };
          notifyListeners();
        },
      );
      _roomPhase = AsyncPhase.success;
      return true;
    } catch (_) {
      _errorMessage = MateyaLocalizations.current.aiRecommendationLoadFailed;
      _roomPhase = AsyncPhase.serverError;
      return false;
    } finally {
      _isSending = false;
      _progressMessage = null;
      notifyListeners();
    }
  }

  Future<void> archiveCurrent() async {
    final conversation = _current;
    if (conversation == null) {
      return;
    }
    await repository.archiveConversation(conversation.id);
    _current = null;
    await loadConversations();
  }
}
