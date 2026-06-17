import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_bottom_navigation.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../onboarding/domain/onboarding_flow.dart';
import '../../application/chat_controller.dart';
import '../../domain/chat_models.dart';
import '../widgets/chat_composer_widgets.dart';
import '../widgets/chat_formatters.dart';
import '../widgets/chat_list_widgets.dart';
import '../widgets/chat_message_widgets.dart';
import '../widgets/chat_status_widgets.dart';

class ChatFlowPage extends StatefulWidget {
  const ChatFlowPage({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onHomeTap,
    required this.onExploreTap,
    required this.onPlusTap,
    required this.onProfileTap,
  });

  final ChatController controller;
  final VoidCallback onBack;
  final VoidCallback onHomeTap;
  final VoidCallback onExploreTap;
  final VoidCallback onPlusTap;
  final VoidCallback onProfileTap;

  @override
  State<ChatFlowPage> createState() => _ChatFlowPageState();
}

class _ChatFlowPageState extends State<ChatFlowPage> {
  static const List<String> _allowedPhotoExtensions = <String>[
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
  ];
  static const int _maxAttachmentCount = 10;
  static const int _maxAttachmentBytes = 10 * 1024 * 1024;

  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _draftController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();

  String? _lastRoomId;
  int _lastGroupCount = 0;
  int _lastToastVersion = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
    _listScrollController.addListener(_handleListScroll);
    _scrollController.addListener(_handleDetailScroll);
    _syncDraft();
  }

  @override
  void didUpdateWidget(covariant ChatFlowPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) {
      return;
    }
    oldWidget.controller.removeListener(_handleControllerChanged);
    widget.controller.addListener(_handleControllerChanged);
    _syncDraft();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    _listScrollController
      ..removeListener(_handleListScroll)
      ..dispose();
    _scrollController.removeListener(_handleDetailScroll);
    _draftController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleListScroll() {
    if (!_listScrollController.hasClients) {
      return;
    }
    if (_listScrollController.position.extentAfter < 280) {
      widget.controller.loadMoreRooms();
    }
  }

  void _handleDetailScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    if (_scrollController.position.extentBefore < 120) {
      widget.controller.loadOlderMessages();
    }
  }

  void _handleControllerChanged() {
    _syncDraft();
    if (widget.controller.toastMessage != null &&
        widget.controller.toastVersion != _lastToastVersion) {
      _lastToastVersion = widget.controller.toastVersion;
      _showPendingMessage(widget.controller.toastMessage!);
      widget.controller.clearToast();
    }
    final room = widget.controller.currentRoom;
    final roomId = widget.controller.selectedRoomId;
    final groupCount = room?.messageGroups.length ?? 0;
    final shouldScroll =
        widget.controller.isDetailOpen &&
        widget.controller.roomPhase == AsyncPhase.success &&
        (roomId != _lastRoomId || groupCount != _lastGroupCount);

    _lastRoomId = roomId;
    _lastGroupCount = groupCount;

    if (!shouldScroll) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _syncDraft() {
    if (_draftController.text == widget.controller.draft) {
      return;
    }
    _draftController.value = TextEditingValue(
      text: widget.controller.draft,
      selection: TextSelection.collapsed(
        offset: widget.controller.draft.length,
      ),
    );
  }

  void _showPendingMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openAttachmentPicker() async {
    final action = await showModalBottomSheet<_AttachmentAction>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('사진 첨부 기준', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(
                  '실무 기준으로 JPG, PNG, WEBP, GIF 형식과 10MB 이하 이미지를 허용하도록 설계했습니다.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.fieldBorder,
                  ),
                ),
                const SizedBox(height: 16),
                AttachmentActionTile(
                  icon: Icons.photo_library_outlined,
                  title: '앨범에서 선택',
                  subtitle: '여러 장을 한 번에 고를 수 있습니다.',
                  onTap: () =>
                      Navigator.of(context).pop(_AttachmentAction.gallery),
                ),
                const SizedBox(height: 10),
                AttachmentActionTile(
                  icon: Icons.photo_camera_outlined,
                  title: '카메라로 촬영',
                  subtitle: '사진 1장을 바로 찍어 첨부합니다.',
                  onTap: () =>
                      Navigator.of(context).pop(_AttachmentAction.camera),
                ),
                const SizedBox(height: 18),
                const GuideRow(text: '허용 형식: JPG, PNG, WEBP, GIF'),
                const GuideRow(text: '최대 크기: 10MB'),
                const GuideRow(text: '메시지당 최대 10장'),
                const GuideRow(text: '저해상도 이미지는 업로드 전 압축 권장'),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || action == null) {
      return;
    }

    try {
      switch (action) {
        case _AttachmentAction.gallery:
          final pickedFiles = await _imagePicker.pickMultiImage(
            imageQuality: 88,
            maxWidth: 2400,
          );
          if (!mounted || pickedFiles.isEmpty) {
            return;
          }
          await _consumePickedFiles(
            pickedFiles,
            source: ChatAttachmentSource.gallery,
          );
          return;
        case _AttachmentAction.camera:
          final pickedFile = await _imagePicker.pickImage(
            source: ImageSource.camera,
            imageQuality: 88,
            maxWidth: 2400,
          );
          if (!mounted || pickedFile == null) {
            return;
          }
          await _consumePickedFiles(<XFile>[
            pickedFile,
          ], source: ChatAttachmentSource.camera);
          return;
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showPendingMessage('사진을 불러오지 못했어요. 권한과 파일 상태를 확인해 주세요.');
    }
  }

  Future<void> _consumePickedFiles(
    List<XFile> pickedFiles, {
    required ChatAttachmentSource source,
  }) async {
    final attachments = <ChatAttachment>[];
    var rejectedTypeCount = 0;
    var rejectedSizeCount = 0;

    for (var index = 0; index < pickedFiles.length; index += 1) {
      final file = pickedFiles[index];
      final fileName = file.name.isEmpty ? 'image_$index' : file.name;
      final extension = _extractExtension(fileName);
      if (!_allowedPhotoExtensions.contains(extension)) {
        rejectedTypeCount += 1;
        continue;
      }

      final fileSize = await file.length();
      if (fileSize > _maxAttachmentBytes) {
        rejectedSizeCount += 1;
        continue;
      }

      attachments.add(
        ChatAttachment(
          id: 'draft-${DateTime.now().microsecondsSinceEpoch}-$index',
          path: file.path,
          fileName: fileName,
          fileSizeBytes: fileSize,
          source: source,
        ),
      );
    }

    final overflowCount = widget.controller.addDraftAttachments(attachments);

    if (!mounted) {
      return;
    }

    if (attachments.isNotEmpty &&
        rejectedTypeCount == 0 &&
        rejectedSizeCount == 0) {
      _showPendingMessage('사진 ${attachments.length - overflowCount}장을 첨부했어요.');
    }
    if (rejectedTypeCount > 0) {
      _showPendingMessage('지원하지 않는 형식의 사진 $rejectedTypeCount장은 제외했어요.');
    }
    if (rejectedSizeCount > 0) {
      _showPendingMessage('10MB를 초과한 사진 $rejectedSizeCount장은 제외했어요.');
    }
    if (overflowCount > 0) {
      _showPendingMessage('사진은 최대 $_maxAttachmentCount장까지 첨부할 수 있어요.');
    }
  }

  String _extractExtension(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == fileName.length - 1) {
      return '';
    }
    return fileName.substring(dotIndex + 1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return ColoredBox(
          color: widget.controller.isDetailOpen
              ? AppColors.appSurface
              : AppColors.background,
          child: widget.controller.isDetailOpen
              ? _buildDetailScreen(context)
              : _buildListScreen(context),
        );
      },
    );
  }

  Widget _buildListScreen(BuildContext context) {
    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: widget.onBack),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ChatFilterBar(
            currentFilter: widget.controller.filter,
            onChanged: widget.controller.updateFilter,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(child: _buildListBody(context)),
        MateyaBottomNavigation(
          currentTab: MateyaBottomTab.chat,
          onHomeTap: widget.onHomeTap,
          onExploreTap: widget.onExploreTap,
          onPlusTap: widget.onPlusTap,
          onChatTap: () {},
          onProfileTap: widget.onProfileTap,
        ),
      ],
    );
  }

  Widget _buildListBody(BuildContext context) {
    return switch (widget.controller.listPhase) {
      AsyncPhase.idle || AsyncPhase.loading => const ChatListSkeleton(),
      AsyncPhase.networkError || AsyncPhase.serverError => ChatRetryState(
        message: widget.controller.listErrorMessage ?? '채팅 목록을 불러오지 못했어요.',
        onRetry: widget.controller.retryRooms,
      ),
      AsyncPhase.success ||
      AsyncPhase.validationError => _buildRoomList(context),
    };
  }

  Widget _buildRoomList(BuildContext context) {
    final rooms = widget.controller.visibleRooms;
    if (rooms.isEmpty) {
      return const ChatEmptyState(
        title: '표시할 채팅방이 없어요.',
        message: '필터를 바꾸거나 새로운 대화를 시작해 보세요.',
      );
    }

    return ListView.separated(
      controller: _listScrollController,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      itemCount: rooms.length + (widget.controller.hasMoreRooms ? 1 : 0),
      separatorBuilder: (context, _) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        if (index >= rooms.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: widget.controller.isLoadingMoreRooms
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      '스크롤하면 채팅방을 더 불러옵니다.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
            ),
          );
        }
        final room = rooms[index];
        return ChatRoomTile(
          room: room,
          onTap: () => widget.controller.openRoom(room.id),
        );
      },
    );
  }

  Widget _buildDetailScreen(BuildContext context) {
    final room = widget.controller.currentRoom;
    if (room == null) {
      return ChatRetryState(
        message: '채팅방 정보를 찾을 수 없어요.',
        onRetry: widget.controller.closeRoom,
        retryLabel: '목록으로',
      );
    }

    return Column(
      children: <Widget>[
        MateyaHeader.chatDetail(
          title: room.title,
          subtitle: room.subtitle,
          onBack: widget.controller.closeRoom,
        ),
        Expanded(child: _buildDetailBody(context, room)),
        ChatComposer(
          draftController: _draftController,
          selectedAttachments: widget.controller.draftAttachments,
          canSend: widget.controller.canSendMessage,
          onChanged: widget.controller.updateDraft,
          onAttachTap: _openAttachmentPicker,
          onRemoveAttachment: widget.controller.removeDraftAttachment,
          onSendTap: () {
            widget.controller.sendMessage();
          },
        ),
      ],
    );
  }

  Widget _buildDetailBody(BuildContext context, ChatRoom room) {
    return switch (widget.controller.roomPhase) {
      AsyncPhase.loading || AsyncPhase.idle => const ChatDetailSkeleton(),
      AsyncPhase.networkError || AsyncPhase.serverError => ChatRetryState(
        message: widget.controller.roomErrorMessage ?? '채팅방을 불러오지 못했어요.',
        onRetry: widget.controller.retryRoom,
      ),
      AsyncPhase.success || AsyncPhase.validationError => ListView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
        children: <Widget>[
          if (widget.controller.hasOlderMessages ||
              widget.controller.isLoadingOlderMessages)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Center(
                child: widget.controller.isLoadingOlderMessages
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        '위로 스크롤하면 이전 메시지를 더 불러옵니다.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
              ),
            ),
          Center(child: DateChip(label: formatConversationDate(room))),
          const SizedBox(height: 18),
          for (final group in room.messageGroups) ...<Widget>[
            group.isMine
                ? OutgoingGroup(group: group)
                : IncomingGroup(
                    group: group,
                    onToggleTranslation: group.supportsTranslation
                        ? () => widget.controller.toggleTranslation(group.id)
                        : null,
                  ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    };
  }
}

enum _AttachmentAction { gallery, camera }
